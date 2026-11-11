# Oracle SQL and PL/SQL for Kuana

Syntax highlighting, File Structure (outline), breadcrumbs, folding and indentation for Oracle SQL
and PL/SQL: packages and package bodies, procedures, functions, triggers, object types, views,
tables and scripts.

Files: `.sql`, `.pls`, `.plb`, `.pks`, `.pkb`, `.pkg`, `.pck`, `.spc`, `.bdy`, `.prc`, `.fnc`,
`.fct`, `.trg`, `.tps`, `.tpb`, `.typ`, `.vw`.

It uses [tree-sitter-plsql](https://github.com/njank/tree-sitter-plsql) by njank (MIT); the
queries in `languages/plsql/` are written for Kuana.

To connect to a database (to browse schemas, edit and compile PL/SQL and run SQL), use Kuana's
**Database** view on the activity bar. It's built into Kuana, since an extension can't add panels.
See [Databases](https://github.com/berkayakin/kuana-editor/blob/main/docs/database.md).

Licensed under MIT OR Apache-2.0, like Kuana. The grammar keeps its own MIT license.
