# Kuana extensions

The extensions you can install from [Kuana](https://github.com/berkayakin/kuana-editor)'s
**Settings → Extensions → Available**. They're open-source extensions in Zed's extension format,
which Kuana reads: languages (grammar, highlighting, outline, indentation), their language servers,
themes and snippets.

Each one is built here from its author's repository, at the commit listed in
[`extensions.toml`](extensions.toml): the version published in Zed's extension registry, which Zed
reviewed. A package has its grammars compiled to WebAssembly and, for extensions whose code finds or
downloads their language server, that code compiled too, so installing one needs no compiler. Kuana
runs that code sandboxed.

## How it works

- [`scripts/build.py`](scripts/build.py) builds each extension:
  - It fetches the repository at its commit.
  - It compiles the extension's Rust code to WebAssembly (`wasm32-wasip2`) when the code is for an
    extension API Kuana runs (0.6, 0.7).
  - It runs `kuana extension check`. That compiles the grammars with wasi-sdk, loads the code, and
    compiles every query against its grammar. An extension with errors isn't published.
  - It packages what Kuana reads, with the licenses.
- [GitHub Actions](.github/workflows/build.yml) runs it when `extensions.toml` changes. Only
  extensions whose commit changed are rebuilt.
- Everything is published on the [`packages`](../../releases/tag/packages) release: one `.tar.gz` per
  extension, and `index.json`, which lists them with their SHA-256 checksums.
- `index.json` is signed with this registry's minisign key. Kuana installs a package only when the
  index's signature and the package's checksum both match.

## Licenses

Every extension is its authors' work, under its own license, given for each in `extensions.toml`.
Only extensions with a clear open-source license are listed (MIT or Apache-2.0 so far). Each package
includes the extension's license and notice files, and its grammars' licenses (in
`licenses/grammars/`). Each package's source is the repository and commit in `extensions.toml`.

The scripts and workflow in this repository are licensed under MIT OR Apache-2.0, like Kuana.

Kuana reads Zed's extension format for compatibility. This registry isn't affiliated with or
endorsed by Zed Industries, and doesn't use Zed's servers.

## Adding an extension

An extension can be listed when:

- it's open source under a license that allows redistribution (MIT, Apache-2.0, BSD…), with a license
  file in its repository;
- `python3 scripts/build.py` builds it and `kuana extension check` finds no errors.

Add it to `extensions.toml`, with its repository, the commit to build and its license, and open a pull
request.

## Building locally

You need git, Rust with the `wasm32-wasip2` target (`rustup target add wasm32-wasip2`), wasi-sdk and a
Kuana binary:

```bash
WASI_SDK_PATH=~/.config/kuana/toolchains/wasi-sdk-34.0 python3 scripts/build.py --kuana /path/to/kuana \
  --base-url "file://$PWD/dist/packages/" --only dart zig
```

Packages and `index.json` go to `dist/`, and `dist/report.md` says what was built and what failed. A
debug build of Kuana can install from that local index. Sign it first, then point Kuana at it:

```bash
minisign -S -s ~/.minisign/kuana-extensions.key -m dist/index.json
KUANA_REGISTRY=file://$PWD/dist/index.json kuana
```
