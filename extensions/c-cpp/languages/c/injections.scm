; A macro's body is C code (`injection.self`: Kuana skips injecting a file's
; own language unless a pattern says so): `#define MIN(a, b) ((a) < (b) ? (a) : (b))`.
(preproc_def
  value: (preproc_arg) @injection.content
  (#set! injection.language "c")
  (#set! injection.self))

(preproc_function_def
  value: (preproc_arg) @injection.content
  (#set! injection.language "c")
  (#set! injection.self))
