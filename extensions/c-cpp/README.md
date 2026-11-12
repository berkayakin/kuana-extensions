# C and C++ for Kuana

Syntax highlighting (macro bodies included), File Structure (outline), breadcrumbs, folding,
indentation and bracket matching for C and C++, and [clangd](https://clangd.llvm.org) for completion,
diagnostics, go to definition, find usages, rename, hover, signature help, inlay hints and formatting.

Files: C `.c`; C++ `.cc`, `.cpp`, `.cxx`, `.c++`, `.cp`, `.cppm`, `.ixx`, `.cu`, `.ino`, and headers
`.h`, `.hh`, `.hpp`, `.hxx`, `.h++`, `.ipp`, `.inl`, `.tpp`, `.txx`, `.cuh`. Headers open as C++ (as in
Zed and clangd), since C++'s grammar reads C as well; clangd still compiles them as your build does.

With Kuana 0.1.32 or later:

- **Run and debug:** a ▶ on `main`. In a CMake project it configures `build/` once (a Debug build,
  with `compile_commands.json` for clangd), builds the executable that file belongs to and runs it;
  Debug does the same under lldb-dap, with breakpoints, stepping and variables. Outside CMake it
  compiles the file on its own (`cc`/`c++ -g`, with `compile_flags.txt`'s flags).
- **Switch Header/Source:** ⌃⌘↑ (JetBrains keymap; Alt+O in VS Code's), or Find Action.
- **Install clangd:** when it isn't on your PATH, the status bar offers to download clangd's own
  release (macOS, Linux x86_64, Windows x86_64).

## clangd

On macOS clangd comes with Xcode's command line tools (`xcode-select --install`), on Linux with your
distribution's `clangd` package; otherwise the status bar's Install downloads it. Or set a command:

```json
{ "lsp": { "clangd": { "binary": { "path": "/opt/llvm/bin/clangd", "arguments": ["--clang-tidy"] } } } }
```

clangd reads your build's flags from `compile_commands.json` (CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`,
which Run sets up; Make: [Bear](https://github.com/rizsotto/Bear)) or `compile_flags.txt` in the
project. Without them it guesses, and headers from your own include folders show as not found.

## Licenses

It uses [tree-sitter-c](https://github.com/tree-sitter/tree-sitter-c) and
[tree-sitter-cpp](https://github.com/tree-sitter/tree-sitter-cpp) (MIT); the queries in `languages/`
are written for Kuana.

Licensed under MIT OR Apache-2.0, like Kuana. The grammars keep their own MIT licenses.
