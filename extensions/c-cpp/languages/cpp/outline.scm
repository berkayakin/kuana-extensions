; File Structure for C++: namespaces, classes, structs, unions and enums with
; their members, functions and methods (definitions and declarations), type
; aliases, concepts and macros. `@context` keywords give a type's kind.

(namespace_definition
  "namespace" @context
  name: (_) @name
  body: (_)) @item

(class_specifier
  "class" @context
  name: (_) @name
  body: (_)) @item

(struct_specifier
  "struct" @context
  name: (_) @name
  body: (_)) @item

(union_specifier
  "union" @context
  name: (_) @name
  body: (_)) @item

(enum_specifier
  "enum" @context
  name: (_) @name
  body: (_)) @item

; Functions defined in a class are methods (before the general pattern: the
; first pattern matching a definition gives its kind).
(field_declaration_list
  (function_definition
    declarator: [
      (function_declarator declarator: (_) @name)
      (pointer_declarator declarator: (function_declarator declarator: (_) @name))
      (reference_declarator (function_declarator declarator: (_) @name))
    ]) @definition.method)

; A template member function: the definition itself is the item, so the
; general pattern below matches the same node and this kind wins.
(field_declaration_list
  (template_declaration
    (function_definition
      declarator: [
        (function_declarator declarator: (_) @name)
        (pointer_declarator declarator: (function_declarator declarator: (_) @name))
        (reference_declarator (function_declarator declarator: (_) @name))
      ]) @definition.method))

(field_declaration_list
  (template_declaration
    (declaration
      declarator: (function_declarator declarator: (_) @name)) @definition.method))

(function_definition
  declarator: [
    (function_declarator declarator: (_) @name)
    (pointer_declarator declarator: (function_declarator declarator: (_) @name))
    (reference_declarator (function_declarator declarator: (_) @name))
  ]) @definition.function

; Declarations: prototypes at the top level and in namespaces, methods in a class.
([(translation_unit) (declaration_list)]
  (declaration
    declarator: [
      (function_declarator declarator: (_) @name)
      (pointer_declarator declarator: (function_declarator declarator: (_) @name))
      (reference_declarator (function_declarator declarator: (_) @name))
    ]) @definition.function)

(field_declaration_list
  (declaration
    declarator: (function_declarator declarator: (_) @name)) @definition.method)

(field_declaration
  declarator: [
    (function_declarator declarator: (_) @name)
    (pointer_declarator declarator: (function_declarator declarator: (_) @name))
    (reference_declarator (function_declarator declarator: (_) @name))
  ]) @definition.method

; Each field of `double x, y;` is its own entry, so the declarator is the item.
(field_declaration
  declarator: [
    (field_identifier) @name @item
    (pointer_declarator declarator: (field_identifier) @name) @item
    (reference_declarator (field_identifier) @name) @item
    (array_declarator declarator: (field_identifier) @name) @item
  ])

(type_definition
  declarator: [
    (type_identifier) @name
    (pointer_declarator declarator: (type_identifier) @name)
  ]) @definition.type

(alias_declaration
  name: (type_identifier) @name) @definition.type

(concept_definition
  name: (identifier) @name) @definition.type

(enumerator
  name: (identifier) @name) @definition.constant

(preproc_def
  name: (identifier) @name) @definition.macro

(preproc_function_def
  name: (identifier) @name) @definition.macro
