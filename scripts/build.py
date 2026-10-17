#!/usr/bin/env python3
"""Builds Kuana's extension registry: each extension in extensions.toml, from
its repository at its commit, into a package (a .tar.gz in the layout Kuana
installs) and one index of them all.

    python3 scripts/build.py --kuana PATH [--previous INDEX] [--base-url URL]
                             [--out DIR] [--only ID ...] [--all]

For each extension:

1. fetch its repository at the listed commit;
2. compile its own code to WebAssembly (extension.wasm), when it's for an
   extension API whose code Kuana runs (0.6, 0.7); other code is left out
   and Kuana finds the extension's language server itself;
3. run `kuana extension check`, which compiles its grammars to WebAssembly
   (with wasi-sdk: WASI_SDK_PATH) and every query against them, and fails on
   errors;
4. package what Kuana reads, with the extension's licenses and its grammars'.

An extension at the commit the previous index lists keeps its entry (its
package is published already), unless `--all`. One that fails keeps its
previous entry, if any. The outcome is in report.md.

Needs git, cargo with the wasm32-wasip2 target, wasi-sdk and a Kuana binary.
Nothing but the standard library.
"""

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tarfile
import tomllib
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
# Extension APIs whose code Kuana runs (src/extensions/wasm.rs).
KUANA_APIS = ("0.6.", "0.7.")
# What Kuana reads from an extension, besides extension.wasm and grammars/*.wasm.
CONTENT = ["extension.toml", "languages", "themes", "icon_themes", "snippets"]
LICENSE_FILE = re.compile(r"^(LICEN[CS]E|COPYING|NOTICE)", re.IGNORECASE)


class Failed(Exception):
    pass


def run(cmd, cwd=None, env=None):
    result = subprocess.run([str(c) for c in cmd], cwd=cwd, env=env, capture_output=True, text=True)
    if result.returncode != 0:
        output = (result.stdout + result.stderr).strip()
        raise Failed(f"`{' '.join(str(c) for c in cmd[:4])}` failed:\n{output[-3000:]}")
    return result.stdout


def fetch(repository, commit, into):
    """The repository at exactly `commit`, shallow."""
    if into.exists():
        shutil.rmtree(into)
    into.mkdir(parents=True)
    run(["git", "init", "--quiet"], cwd=into)
    run(["git", "remote", "add", "origin", repository], cwd=into)
    run(["git", "fetch", "--quiet", "--depth", "1", "origin", commit], cwd=into)
    run(["git", "checkout", "--quiet", "FETCH_HEAD"], cwd=into)


def build_code(ext, target_dir, toolchain):
    """Compiles the extension's Rust code to a WebAssembly component. Returns
    (the .wasm, the extension API it's for), or (None, API) when Kuana doesn't
    run code for that API."""
    env = dict(os.environ, RUSTUP_TOOLCHAIN=toolchain, CARGO_TARGET_DIR=str(target_dir))
    metadata = json.loads(run(["cargo", "metadata", "--format-version", "1", "--manifest-path", ext / "Cargo.toml"], env=env))
    api = next((p["version"] for p in metadata["packages"] if p["name"] == "zed_extension_api"), None)
    if api is None:
        raise Failed("its code doesn't use zed_extension_api")
    if not api.startswith(KUANA_APIS):
        return None, api
    root = next(p for p in metadata["packages"] if p["id"] == metadata["resolve"]["root"])
    lib = next((t["name"] for t in root["targets"] if "cdylib" in t["kind"]), None)
    if lib is None:
        raise Failed("its crate isn't a cdylib")
    run(["cargo", "build", "--quiet", "--release", "--target", "wasm32-wasip2", "--manifest-path", ext / "Cargo.toml"], env=env)
    wasm = target_dir / "wasm32-wasip2" / "release" / f"{lib.replace('-', '_')}.wasm"
    if not wasm.is_file():
        raise Failed(f"cargo made no {wasm.name}")
    return wasm, api


def with_lib(manifest_text, api):
    """The manifest with `[lib]` saying which API the code is for (Kuana runs
    the code only for the versions it knows)."""
    text = re.sub(r"(?ms)^\[lib\]\n.*?(?=^\[|\Z)", "", manifest_text).rstrip() + "\n"
    return text + f'\n[lib]\nkind = "Rust"\nversion = "{api}"\n'


def copy_licenses(source, into):
    for file in sorted(source.iterdir()) if source.is_dir() else []:
        if file.is_file() and LICENSE_FILE.match(file.name):
            into.mkdir(parents=True, exist_ok=True)
            shutil.copy2(file, into / file.name)


def provides(staging, manifest):
    found = []
    if any((d / "config.toml").is_file() for d in (staging / "languages").glob("*")):
        found.append("languages")
    for key, name in [("grammars", "grammars"), ("language_servers", "language-servers")]:
        if manifest.get(key):
            found.append(name)
    for folder, name in [("themes", "themes"), ("icon_themes", "icon-themes"), ("snippets", "snippets")]:
        if any((staging / folder).glob("*")):
            found.append(name)
    if manifest.get("debug_adapters"):
        found.append("debug-adapters")
    return found


def package(staging, out_file):
    def clean(info):
        info.uid = info.gid = 0
        info.uname = info.gname = ""
        return info

    with tarfile.open(out_file, "w:gz") as tar:
        for path in sorted(staging.rglob("*")):
            if path.is_file():
                tar.add(path, arcname=path.relative_to(staging).as_posix(), filter=clean)


def sha256(path):
    digest = hashlib.sha256()
    with open(path, "rb") as file:
        for chunk in iter(lambda: file.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build_one(id, spec, args, work):
    """Builds one extension into args.out/packages/. Returns its index entry and
    notes (Kuana's findings, code left out)."""
    repo = work / id / "repo"
    fetch(spec["repository"], spec["commit"], repo)
    ext = repo / spec.get("path", "")
    manifest_text = (ext / "extension.toml").read_text()
    manifest = tomllib.loads(manifest_text)
    if manifest.get("id") != id:
        raise Failed(f"its extension.toml says id {manifest.get('id')!r}")
    version = manifest.get("version", "")
    if not re.fullmatch(r"[0-9A-Za-z.+-]+", version):
        raise Failed(f"its version {version!r} can't name a file")

    staging = work / id / "package"
    if staging.exists():
        shutil.rmtree(staging)
    staging.mkdir(parents=True)
    for item in CONTENT + ["grammars"]:
        source = ext / item
        if source.is_dir():
            shutil.copytree(source, staging / item)
        elif source.is_file():
            shutil.copy2(source, staging / item)
    copy_licenses(repo, staging)
    if ext != repo:
        copy_licenses(ext, staging)
    if not any(LICENSE_FILE.match(f.name) for f in staging.iterdir()):
        raise Failed("it has no license file")

    notes = []
    api = None
    if (ext / "Cargo.toml").is_file():
        wasm, api = build_code(ext, work / "target", args.toolchain)
        if wasm is None:
            notes.append(f"its code is for extension API {api}, which Kuana doesn't run: left out")
        else:
            shutil.copy2(wasm, staging / "extension.wasm")
            (staging / "extension.toml").write_text(with_lib(manifest_text, api))

    env = dict(os.environ)
    check = subprocess.run([args.kuana, "extension", "check", staging], env=env, capture_output=True, text=True)
    findings = (check.stdout + check.stderr).strip()
    if check.returncode != 0:
        raise Failed(f"kuana extension check found errors:\n{findings[-3000:]}")
    notes.extend(line for line in findings.splitlines() if line.strip() and "built" not in line)

    # Grammars: their compiled WebAssembly stays, their sources go (their
    # licenses are kept).
    for grammar in sorted(manifest.get("grammars", {})):
        if not (staging / "grammars" / f"{grammar}.wasm").is_file():
            raise Failed(f"grammar {grammar} wasn't built")
        copy_licenses(staging / "grammars" / grammar, staging / "licenses" / "grammars" / grammar)
    for path in list((staging / "grammars").glob("*")):
        if path.is_dir():
            shutil.rmtree(path)
        elif path.suffix != ".wasm":
            path.unlink()

    file = f"{id}-{version}.tar.gz"
    out_file = args.out / "packages" / file
    package(staging, out_file)
    entry = {
        "id": id,
        "name": manifest.get("name", id),
        "version": version,
        "description": manifest.get("description", ""),
        "authors": manifest.get("authors", []),
        "repository": spec["repository"],
        "commit": spec["commit"],
        "license": spec["license"],
        "provides": provides(staging, manifest),
        "wasm_api_version": api if (staging / "extension.wasm").is_file() else None,
        "package": {"url": args.base_url + file, "sha256": sha256(out_file), "size": out_file.stat().st_size},
    }
    return entry, notes


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--kuana", required=True, type=Path, help="a Kuana binary, for `kuana extension check`")
    parser.add_argument("--previous", type=Path, help="the published index.json, to keep what didn't change")
    parser.add_argument("--base-url", default="", help="where packages are downloaded from (ends in /)")
    parser.add_argument("--out", type=Path, default=ROOT / "dist")
    parser.add_argument("--work", type=Path, default=ROOT / "build")
    parser.add_argument("--toolchain", default="stable", help="the Rust toolchain extensions' code is built with")
    parser.add_argument("--only", nargs="*", help="build only these extensions (the rest keep their previous entries)")
    parser.add_argument("--all", action="store_true", help="rebuild what didn't change too")
    args = parser.parse_args()
    if "WASI_SDK_PATH" not in os.environ:
        sys.exit("Set WASI_SDK_PATH to wasi-sdk (Kuana compiles grammars with it)")

    listed = tomllib.loads((ROOT / "extensions.toml").read_text())
    previous = {}
    if args.previous and args.previous.is_file():
        previous = {e["id"]: e for e in json.loads(args.previous.read_text())["extensions"]}
    (args.out / "packages").mkdir(parents=True, exist_ok=True)
    args.work.mkdir(parents=True, exist_ok=True)

    entries, report = [], []
    for id in sorted(listed):
        spec = listed[id]
        old = previous.get(id)
        if args.only is not None and id not in args.only or (old and old["commit"] == spec["commit"] and not args.all):
            if old:
                entries.append(old)
                report.append(f"- {id}: kept {old['version']}")
            continue
        print(f"{id}…", flush=True)
        try:
            entry, notes = build_one(id, spec, args, args.work)
            entries.append(entry)
            report.append(f"- {id}: **built {entry['version']}** ({', '.join(entry['provides'])})")
            report.extend(f"  - {note}" for note in notes)
        except Failed as err:
            if old:
                entries.append(old)
            kept = f" (kept {old['version']})" if old else ""
            report.append(f"- {id}: **failed**{kept}\n\n  ```\n  " + str(err).replace("\n", "\n  ") + "\n  ```")
            print(f"{id} failed: {err}", file=sys.stderr)

    index = {
        "format": 1,
        "generated": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "extensions": sorted(entries, key=lambda e: e["id"]),
    }
    (args.out / "index.json").write_text(json.dumps(index, indent=1, ensure_ascii=False) + "\n")
    (args.out / "report.md").write_text("# Build report\n\n" + "\n".join(report) + "\n")
    failed = sum("**failed**" in line for line in report)
    print(f"{len(entries)} extensions in the index, {failed} failed (see report.md)")


if __name__ == "__main__":
    main()
