; Oracle SQL and PL/SQL highlighting for njank/tree-sitter-plsql.
; Kuana applies captures in query order and a later match wins, so the
; catch-alls come first and the specific rules after them.

(identifier) @variable

; ------------------------------------------------------------- names in definitions

(create_package package_name: (identifier) @type)
(create_package_body package_name: (identifier) @type)
(create_type_body type_name: (identifier) @type)
(plsql_type_source type_name: (identifier) @type)
(create_table table_name: (identifier) @type)
(create_view view_name: (identifier) @type)
(create_sequence (referenced_element ref_name: (identifier) @type))
(create_trigger trigger_name: (identifier) @function)
(create_procedure prc_name: (identifier) @function)
(create_function fnc_name: (identifier) @function)
(function_definition fnc_name: (identifier) @function)
(function_declaration fnc_name: (identifier) @function)
(procedure_definition prc_name: (identifier) @function)
(procedure_declaration prc_name: (identifier) @function)
(element_spec_function_spec fnc_name: (identifier) @function.method)
(element_spec_procedure_spec prc_name: (identifier) @function.method)
(constructor_definition_in_body name: (identifier) @constructor)
(type_definition_collection type_collection_name: (identifier) @type)
(type_definition_record type_rec_name: (identifier) @type)
(type_definition_ref_cursor ref_cursor_name: (identifier) @type)
(type_definition_sub subtype_name: (identifier) @type)
(table_column_definition column_name: (identifier) @property)
(end_obj_named (identifier) @label)
(label (identifier) @label)

(create_package schema_name: (identifier) @namespace)
(create_package_body schema_name: (identifier) @namespace)
(create_procedure schema_name: (identifier) @namespace)
(create_function schema_name: (identifier) @namespace)
(create_table schema_name: (identifier) @namespace)
(create_view schema_name: (identifier) @namespace)
(create_trigger schema_name: (identifier) @namespace)

(parameter_declaration_element . (identifier) @variable.parameter)
(cursor_declaration_parameter . (identifier) @variable.parameter)
(parameter_name (identifier) @variable.parameter)

; ------------------------------------------------------------- references

(referenced_element ref_name_parent: (identifier) @namespace)
(ref_call (referenced_element ref_name: (identifier) @function.call))
(datatype (referenced_element ref_name: (identifier) @type))
(correlation_variable) @variable.builtin
(host_variable) @variable.special
(placeholder) @variable.special

; ------------------------------------------------------------- keywords

[
  (kw_access) (kw_accessible) (kw_add) (kw_after) (kw_agent) (kw_aggregate)
  (kw_all) (kw_allow) (kw_alter) (kw_analytic) (kw_analyze) (kw_and)
  (kw_any) (kw_apply) (kw_array) (kw_as) (kw_asc) (kw_associate)
  (kw_at) (kw_attribute) (kw_audit) (kw_authid) (kw_autonomous_transaction)
  (kw_badfile) (kw_batch) (kw_before) (kw_begin) (kw_between) (kw_block)
  (kw_body) (kw_both) (kw_breadth) (kw_bulk) (kw_by) (kw_c)
  (kw_cache) (kw_cascade) (kw_case) (kw_charsetfrom) (kw_charsetid) (kw_check)
  (kw_clone) (kw_close) (kw_collation) (kw_collect) (kw_columns) (kw_comment)
  (kw_commit) (kw_commtted) (kw_compile) (kw_compound) (kw_connect) (kw_constant)
  (kw_constraint) (kw_constructor) (kw_container) (kw_containers) (kw_context) (kw_continue)
  (kw_create) (kw_cross) (kw_crossedition) (kw_current) (kw_current_user) (kw_cursor)
  (kw_cycle) (kw_data) (kw_database) (kw_day) (kw_db_role_change) (kw_ddl)
  (kw_debug) (kw_declare) (kw_default) (kw_definer) (kw_delete) (kw_deleting)
  (kw_depth) (kw_desc) (kw_deterministic) (kw_directory) (kw_disable) (kw_disallow)
  (kw_disassociate) (kw_discardfile) (kw_distinct) (kw_drop) (kw_duration) (kw_each)
  (kw_editionable) (kw_element) (kw_else) (kw_elsif) (kw_empty) (kw_enable)
  (kw_end) (kw_error) (kw_errors) (kw_escape) (kw_evalname) (kw_except)
  (kw_exception) (kw_exception_init) (kw_exceptions) (kw_execute) (kw_exists) (kw_exit)
  (kw_extend) (kw_external) (kw_fact) (kw_fetch) (kw_filter) (kw_final)
  (kw_first) (kw_following) (kw_follows) (kw_for) (kw_forall) (kw_force)
  (kw_foreign) (kw_format) (kw_forward) (kw_from) (kw_full) (kw_function)
  (kw_goto) (kw_grant) (kw_group) (kw_having) (kw_hierarchies) (kw_hour)
  (kw_if) (kw_immediate) (kw_immutable) (kw_in) (kw_including) (kw_increment)
  (kw_index) (kw_indicator) (kw_indices) (kw_inline) (kw_inner) (kw_insert)
  (kw_inserting) (kw_instantiable) (kw_instead) (kw_intersect) (kw_interval) (kw_into)
  (kw_invalidate) (kw_is) (kw_isolation) (kw_java) (kw_join) (kw_json)
  (kw_keep) (kw_key) (kw_language) (kw_last) (kw_lateral) (kw_lax)
  (kw_leading) (kw_left) (kw_level) (kw_library) (kw_like) (kw_limit)
  (kw_local) (kw_location) (kw_lock) (kw_locked) (kw_log) (kw_logfile)
  (kw_logging) (kw_logoff) (kw_logon) (kw_loop) (kw_map) (kw_matched)
  (kw_maxlen) (kw_maxvalue) (kw_measure) (kw_measures) (kw_member) (kw_merge)
  (kw_metadata) (kw_minus) (kw_minute) (kw_minvalue) (kw_mode) (kw_modify)
  (kw_month) (kw_multiset) (kw_mutable) (kw_name) (kw_national) (kw_natural)
  (kw_nested) (kw_next) (kw_noaudit) (kw_nocache) (kw_nocopy) (kw_nocycle)
  (kw_nologging) (kw_none) (kw_noneditionable) (kw_noorder) (kw_not) (kw_nowait)
  (kw_nulls) (kw_object) (kw_of) (kw_offset) (kw_oid) (kw_on)
  (kw_only) (kw_open) (kw_option) (kw_or) (kw_order) (kw_ordinality)
  (kw_others) (kw_out) (kw_outer) (kw_over) (kw_overflow) (kw_overriding)
  (kw_package) (kw_pairs) (kw_parallel_enable) (kw_parameters) (kw_parent) (kw_partition)
  (kw_passing) (kw_path) (kw_percent) (kw_persistable) (kw_pipe) (kw_pipelined)
  (kw_pluggable) (kw_pragma) (kw_precedes) (kw_preceding) (kw_primary) (kw_prior)
  (kw_procedure) (kw_raise) (kw_range) (kw_read) (kw_record) (kw_ref)
  (kw_reference) (kw_references) (kw_referencing) (kw_reject) (kw_relies_on) (kw_rename)
  (kw_repeat) (kw_replace) (kw_reset) (kw_result) (kw_result_cache) (kw_return)
  (kw_returning) (kw_reuse) (kw_reverse) (kw_revoke) (kw_right) (kw_rollback)
  (kw_row) (kw_rows) (kw_sample) (kw_save) (kw_savepoint) (kw_scalars)
  (kw_schema) (kw_search) (kw_second) (kw_seed) (kw_segment) (kw_select)
  (kw_sequence) (kw_serializable) (kw_servererror) (kw_set) (kw_settings) (kw_shards)
  (kw_shutdown) (kw_siblings) (kw_skip) (kw_specification) (kw_start) (kw_startup)
  (kw_statement) (kw_static) (kw_statistics) (kw_strict) (kw_struct) (kw_subpartition)
  (kw_substitutable) (kw_subtype) (kw_suspend) (kw_sys) (kw_table) (kw_tablespace)
  (kw_tdo) (kw_then) (kw_ties) (kw_time) (kw_to) (kw_trailing)
  (kw_transaction) (kw_trigger) (kw_truncate) (kw_type) (kw_unbounded) (kw_under)
  (kw_union) (kw_unique) (kw_unlimited) (kw_unplug) (kw_update) (kw_updating)
  (kw_use) (kw_using) (kw_using_nls_comp) (kw_validate) (kw_value) (kw_values)
  (kw_varray) (kw_varying) (kw_view) (kw_wait) (kw_when) (kw_where)
  (kw_while) (kw_with) (kw_within) (kw_without) (kw_work) (kw_write)
  (kw_year) (kw_zone)
] @keyword

[
  (kw_anydata) (kw_anydataset) (kw_anytype) (kw_bfile) (kw_binary_double) (kw_binary_float)
  (kw_binary_integer) (kw_blob) (kw_boolean) (kw_byte) (kw_char) (kw_character)
  (kw_clob) (kw_datatype_rowtype) (kw_datatype_type) (kw_date) (kw_decimal) (kw_double)
  (kw_float) (kw_int) (kw_integer) (kw_json_array_t) (kw_json_element_t) (kw_json_key_list)
  (kw_json_object_t) (kw_json_scalar_t) (kw_long) (kw_nchar) (kw_nclob) (kw_number)
  (kw_numeric) (kw_nvarchar2) (kw_pls_integer) (kw_precision) (kw_raw) (kw_real)
  (kw_refcursor) (kw_rowid) (kw_sdo_geometry) (kw_sdo_georaster) (kw_sdo_topo_geometry) (kw_smallint)
  (kw_string) (kw_timestamp) (kw_uritype) (kw_urowid) (kw_varchar) (kw_varchar2)
  (kw_xmltype)
] @type.builtin

[
  (kw_avg) (kw_cast) (kw_connect_by_root) (kw_convert) (kw_count) (kw_dense_rank)
  (kw_extract) (kw_json_table) (kw_length) (kw_listagg) (kw_max) (kw_min)
  (kw_mod) (kw_raise_application_error) (kw_rank) (kw_row_number) (kw_sum) (kw_treat)
  (kw_trim) (kw_xmlagg) (kw_xmlattributes) (kw_xmlelement) (kw_xmlforest) (kw_xmltable)
] @function.builtin

[
  (kw_false) (kw_true)
] @boolean

[
  (kw_dup_val_on_index) (kw_null)
] @constant.builtin

[
  (kw_bulk_exceptions) (kw_bulk_rowcount) (kw_found) (kw_isopen) (kw_notfound) (kw_rowcount)
] @attribute

[
  (kw_new) (kw_old) (kw_self) (kw_sql)
] @variable.builtin


; ------------------------------------------------------------- literals and comments

(literal_string) @string
(number) @number
(float) @number
(comment_sl) @comment
(comment_ml) @comment
(conditional_compilation) @keyword.directive
(inquiry_directive) @constant.macro

; ------------------------------------------------------------- punctuation and operators

[
  "+" "-" "*" "/" "**" "||" "=" "!=" "<>" "^=" "~=" "<" "<=" ">" ">=" ":=" "=>" ".." "%"
] @operator
(outer_join_marker) @operator
(kw_asterisk) @operator
["(" ")"] @punctuation.bracket
["<<" ">>"] @punctuation.bracket
["," ";" "." ":"] @punctuation.delimiter

; ------------------------------------------------------------- Oracle's built-ins
; The grammar reads these as plain identifiers; matched last so they win.

((identifier) @function.builtin
  (#match? @function.builtin "^(?i)(abs|add_months|ascii|bitand|ceil|chr|coalesce|concat|cos|current_date|current_timestamp|decode|dump|empty_blob|empty_clob|exp|floor|from_tz|greatest|hextoraw|initcap|instr|last_day|least|lengthb|ln|localtimestamp|log|lower|lpad|ltrim|months_between|nanvl|new_time|next_day|nls_initcap|nls_lower|nls_upper|nullif|numtodsinterval|numtoyminterval|nvl|nvl2|power|rawtohex|regexp_count|regexp_instr|regexp_like|regexp_replace|regexp_substr|remainder|replace|round|rpad|rtrim|sign|sin|soundex|sqlcode|sqlerrm|sqrt|standard_hash|substr|substrb|sys_context|sys_guid|systimestamp|sysdate|tan|to_blob|to_char|to_clob|to_date|to_dsinterval|to_number|to_timestamp|to_timestamp_tz|to_yminterval|translate|trunc|uid|upper|user|userenv|vsize|width_bucket|lag|lead|first_value|last_value|ntile|percent_rank|cume_dist|ratio_to_report|stddev|variance|median|json_value|json_query|json_object|json_arrayagg|json_objectagg|xmlquery|xmlserialize|ora_hash)$"))

((identifier) @constant.builtin
  (#match? @constant.builtin "^(?i)(no_data_found|too_many_rows|zero_divide|invalid_number|invalid_cursor|value_error|cursor_already_open|login_denied|not_logged_on|program_error|storage_error|timeout_on_resource|collection_is_null|subscript_beyond_count|subscript_outside_limit|case_not_found|rowtype_mismatch|self_is_null|access_into_null|sys_invalid_rowid|others|rownum|level|nextval|currval|dual)$"))

((identifier) @namespace
  (#match? @namespace "^(?i)(dbms_[a-z_]+|utl_[a-z_]+|apex_[a-z_]+|owa_[a-z_]+|htp|htf|sys|standard)$"))
