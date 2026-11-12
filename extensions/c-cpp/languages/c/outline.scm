; File Structure for C: functions (definitions and prototypes), types, their
; fields and enumerators, and macros. `@context` keywords give a type's kind.

(function_definition
  declarator: [
    (function_declarator declarator: (identifier) @name)
    (pointer_declarator declarator: (function_declarator declarator: (identifier) @name))
    (pointer_declarator declarator: (pointer_declarator declarator: (function_declarator declarator: (identifier) @name)))
  ]) @definition.function

(translation_unit
  (declaration
    declarator: [
      (function_declarator declarator: (identifier) @name)
      (pointer_declarator declarator: (function_declarator declarator: (identifier) @name))
    ]) @definition.function)

(struct_specifier
  "struct" @context
  name: (type_identifier) @name
  body: (_)) @item

(union_specifier
  "union" @context
  name: (type_identifier) @name
  body: (_)) @item

(enum_specifier
  "enum" @context
  name: (type_identifier) @name
  body: (_)) @item

(type_definition
  declarator: [
    (type_identifier) @name
    (pointer_declarator declarator: (type_identifier) @name)
    (function_declarator declarator: (type_identifier) @name)
  ]) @definition.type

; Each field of `double x, y;` is its own entry, so the declarator is the item.
(field_declaration
  declarator: [
    (field_identifier) @name @item
    (pointer_declarator declarator: (field_identifier) @name) @item
    (array_declarator declarator: (field_identifier) @name) @item
    (function_declarator declarator: (parenthesized_declarator (pointer_declarator declarator: (field_identifier) @name))) @item
  ])

(enumerator
  name: (identifier) @name) @definition.constant

(preproc_def
  name: (identifier) @name) @definition.macro

(preproc_function_def
  name: (identifier) @name) @definition.macro
