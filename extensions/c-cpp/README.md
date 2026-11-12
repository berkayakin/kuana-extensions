# C and C++ for Kuana

Syntax highlighting, File Structure (outline), breadcrumbs, folding, indentation and bracket matching
for C and C++, and [clangd](https://clangd.llvm.org) for completion, diagnostics, go to definition,
find usages, rename, hover, inlay hints and formatting.

Files: C `.c`; C++ `.cc`, `.cpp`, `.cxx`, `.c++`, `.cp`, `.cppm`, `.ixx`, `.cu`, `.ino`, and headers
`.h`, `.hh`, `.hpp`, `.hxx`, `.h++`, `.ipp`, `.inl`, `.tpp`, `.txx`, `.cuh`. Headers open as C++ (as in
Zed and clangd), since C++'s grammar reads C as well; clangd still compiles them as your build does.

## clangd

clangd has to be installed: on macOS it comes with Xcode's command line tools
(`xcode-select --install`), on Linux with your distribution's `clangd` package, elsewhere from
[LLVM](https://clangd.llvm.org/installation). Kuana finds it on your PATH, or set a command:

```json
{ "lsp": { "clangd": { "binary": { "path": "/opt/llvm/bin/clangd", "arguments": ["--clang-tidy"] } } } }
```

clangd reads your build's flags from `compile_commands.json` (CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`;
Make: [Bear](https://github.com/rizsotto/Bear)) or `compile_flags.txt` in the project. Without them it
guesses, and headers from your own include folders show as not found.

## Licenses

It uses [tree-sitter-c](https://github.com/tree-sitter/tree-sitter-c) and
[tree-sitter-cpp](https://github.com/tree-sitter/tree-sitter-cpp) (MIT); the queries in `languages/`
are written for Kuana.

Licensed under MIT OR Apache-2.0, like Kuana. The grammars keep their own MIT licenses.
