; A macro's body is C++ code (`injection.self`: Kuana skips injecting a file's
; own language unless a pattern says so): `#define MIN(a, b) ((a) < (b) ? (a) : (b))`.
(preproc_def
  value: (preproc_arg) @injection.content
  (#set! injection.language "cpp")
  (#set! injection.self))

(preproc_function_def
  value: (preproc_arg) @injection.content
  (#set! injection.language "cpp")
  (#set! injection.self))

; A raw string whose delimiter names a language: R"sql(SELECT 1)sql".
(raw_string_literal
  delimiter: (raw_string_delimiter) @injection.language
  (raw_string_content) @injection.content)
