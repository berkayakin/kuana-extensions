; File Structure, breadcrumbs and sticky scroll.

(create_package
  (kw_package) @context
  package_name: (identifier) @name) @item

(create_package_body
  (kw_package) @context
  (kw_body) @context
  package_name: (identifier) @name) @item

(create_type
  (kw_type) @context
  (plsql_type_source type_name: (identifier) @name)) @item

(create_type_body
  (kw_type) @context
  (kw_body) @context
  type_name: (identifier) @name) @item

(create_procedure
  (kw_procedure) @context
  prc_name: (identifier) @name) @item

(create_function
  (kw_function) @context
  fnc_name: (identifier) @name) @item

(create_trigger
  (kw_trigger) @context
  trigger_name: (identifier) @name) @item

(create_table
  (kw_table) @context
  table_name: (identifier) @name) @item

(create_view
  (kw_view) @context
  view_name: (identifier) @name) @item

(create_sequence
  (kw_sequence) @context
  (referenced_element ref_name: (identifier) @name)) @item

(function_definition
  (kw_function) @context
  fnc_name: (identifier) @name) @item

(function_declaration
  (kw_function) @context
  fnc_name: (identifier) @name) @item

(procedure_definition
  (kw_procedure) @context
  prc_name: (identifier) @name) @item

(procedure_declaration
  (kw_procedure) @context
  prc_name: (identifier) @name) @item

(element_spec_function_spec
  (kw_function) @context
  fnc_name: (identifier) @name) @item

(element_spec_procedure_spec
  (kw_procedure) @context
  prc_name: (identifier) @name) @item

(cursor_definition
  (kw_cursor) @context
  . (identifier) @name) @item

(type_definition_collection
  (kw_type) @context
  type_collection_name: (identifier) @name) @item

(type_definition_record
  (kw_type) @context
  type_rec_name: (identifier) @name) @item

(type_definition_ref_cursor
  (kw_type) @context
  ref_cursor_name: (identifier) @name) @item
