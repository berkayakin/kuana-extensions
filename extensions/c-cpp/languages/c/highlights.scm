; C highlighting for Kuana. A later match wins, so catch-alls come first.

(identifier) @variable

((identifier) @constant
  (#match? @constant "^_*[A-Z][A-Z0-9_]*$"))

; Keywords

[
  "break"
  "case"
  "continue"
  "default"
  "do"
  "else"
  "for"
  "goto"
  "if"
  "return"
  "switch"
  "while"
] @keyword.control

[
  "_Alignas"
  "_Alignof"
  "_Atomic"
  "_Generic"
  "_Noreturn"
  "__asm__"
  "__attribute__"
  "__declspec"
  "__extension__"
  "__inline"
  "__inline__"
  "__restrict__"
  "__thread"
  "__volatile__"
  "alignas"
  "alignof"
  "asm"
  "const"
  "constexpr"
  "enum"
  "extern"
  "inline"
  "noreturn"
  "offsetof"
  "register"
  "restrict"
  "sizeof"
  "static"
  "struct"
  "thread_local"
  "typedef"
  "union"
  "volatile"
  (storage_class_specifier)
  (type_qualifier)
] @keyword

[
  "#define"
  "#elif"
  "#elifdef"
  "#elifndef"
  "#else"
  "#endif"
  "#if"
  "#ifdef"
  "#ifndef"
  "#include"
  (preproc_directive)
] @keyword.directive

"defined" @keyword.directive

; Types

(type_identifier) @type
[
  (primitive_type)
  (sized_type_specifier)
] @type.builtin

; Literals

[
  (string_literal)
  (system_lib_string)
  (char_literal)
] @string

(escape_sequence) @escape

(number_literal) @number

[
  (true)
  (false)
  (null)
] @constant.builtin

; Names

(field_identifier) @property
(statement_identifier) @label

(parameter_declaration
  declarator: (identifier) @variable.parameter)
(parameter_declaration
  declarator: (pointer_declarator
    declarator: (identifier) @variable.parameter))
(parameter_declaration
  declarator: (array_declarator
    declarator: (identifier) @variable.parameter))

(preproc_def
  name: (identifier) @constant.macro)
(preproc_function_def
  name: (identifier) @function.macro)
(preproc_params
  (identifier) @variable.parameter)

(enumerator
  name: (identifier) @constant)

; Functions

(call_expression
  function: (identifier) @function)
(call_expression
  function: (field_expression
    field: (field_identifier) @function.method))
(function_declarator
  declarator: (identifier) @function)
(function_declarator
  declarator: (parenthesized_declarator
    (pointer_declarator
      declarator: (identifier) @function)))

; Operators and punctuation

[
  "--"
  "-"
  "-="
  "->"
  "="
  "!="
  "!"
  "*"
  "*="
  "/"
  "/="
  "%"
  "%="
  "&"
  "&="
  "&&"
  "|"
  "|="
  "||"
  "^"
  "^="
  "~"
  "+"
  "++"
  "+="
  "<"
  "<="
  "<<"
  "<<="
  "=="
  ">"
  ">="
  ">>"
  ">>="
  "?"
  ":"
] @operator

[
  "."
  ","
  ";"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

(comment) @comment
