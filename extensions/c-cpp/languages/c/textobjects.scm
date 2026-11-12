(function_definition
  body: (compound_statement "{" (_)* @function.inside "}")) @function.around

(struct_specifier
  body: (field_declaration_list "{" (_)* @class.inside "}")) @class.around

(union_specifier
  body: (field_declaration_list "{" (_)* @class.inside "}")) @class.around

(enum_specifier
  body: (enumerator_list "{" (_)* @class.inside "}")) @class.around

(comment) @comment.around
