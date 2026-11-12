; C++ highlighting for Kuana: C's (as in languages/c/highlights.scm), then C++'s
; own. A later match wins, so catch-alls come first.

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


; C++

[
  "catch"
  "co_await"
  "co_return"
  "co_yield"
  "throw"
  "try"
] @keyword.control

[
  "class"
  "concept"
  "consteval"
  "constinit"
  "decltype"
  "delete"
  "explicit"
  "final"
  "friend"
  "mutable"
  "namespace"
  "new"
  "noexcept"
  "operator"
  "override"
  "private"
  "protected"
  "public"
  "requires"
  "static_assert"
  "template"
  "typename"
  "using"
  "virtual"
  (auto)
  (virtual_specifier)
] @keyword

[
  "and"
  "and_eq"
  "bitand"
  "bitor"
  "compl"
  "not"
  "not_eq"
  "or"
  "or_eq"
  "xor"
  "xor_eq"
  "::"
  "<=>"
  ".*"
  "->*"
  "..."
] @operator

(this) @variable.builtin

(raw_string_literal) @string
(user_defined_literal (literal_suffix) @type)

(namespace_identifier) @type.namespace
(namespace_definition
  name: (namespace_identifier) @type.namespace)

(template_type
  name: (type_identifier) @type)
(concept_definition
  name: (identifier) @type)
(type_parameter_declaration
  (type_identifier) @type)

(optional_parameter_declaration
  declarator: (identifier) @variable.parameter)
(parameter_declaration
  declarator: (reference_declarator
    (identifier) @variable.parameter))

; Functions and methods

(call_expression
  function: (qualified_identifier
    name: (identifier) @function))
(call_expression
  function: (qualified_identifier
    name: (qualified_identifier
      name: (identifier) @function)))
(call_expression
  function: (template_function
    name: (identifier) @function))
(call_expression
  function: (qualified_identifier
    name: (template_function
      name: (identifier) @function)))
(call_expression
  function: (field_expression
    field: (template_method
      name: (field_identifier) @function.method)))

(function_declarator
  declarator: (field_identifier) @function.method)
(function_declarator
  declarator: (qualified_identifier
    name: (identifier) @function))
(function_declarator
  declarator: (qualified_identifier
    name: (qualified_identifier
      name: (identifier) @function)))
(function_declarator
  declarator: (template_function
    name: (identifier) @function))
(function_declarator
  declarator: (destructor_name) @function.method)
(function_declarator
  declarator: (qualified_identifier
    name: (destructor_name) @function.method))
(function_declarator
  declarator: (operator_name) @function.method)
(function_declarator
  declarator: (qualified_identifier
    name: (operator_name) @function.method))

; A constructor: a class's own name as a function.
((function_declarator
  declarator: (qualified_identifier
    scope: (namespace_identifier) @_scope
    name: (identifier) @function.method))
  (#eq? @_scope @function.method))

(new_expression
  type: (type_identifier) @type)

(lambda_capture_specifier
  [
    (identifier) @variable
    (lambda_default_capture) @operator
  ])

(comment) @comment
