; Namespace bodies stay level with `namespace`, as most C++ styles have them.
[
  (compound_statement)
  (field_declaration_list)
  (enumerator_list)
  (initializer_list)
  (argument_list)
  (parameter_list)
  (template_argument_list)
  (field_initializer_list)
] @indent

; A case's statements go one deeper than its label.
(case_statement ":" @start) @indent
