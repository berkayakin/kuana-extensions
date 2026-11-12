; (), [] and {} pair by the grammar's tokens without a query.
(string_literal "\"" @open "\"" @close)
(char_literal "'" @open "'" @close)
(raw_string_literal "R\"" @open "\"" @close)
(template_argument_list "<" @open ">" @close)
(template_parameter_list "<" @open ">" @close)
