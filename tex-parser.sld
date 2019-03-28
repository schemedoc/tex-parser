(define-library (tex-parser)
  (export parse-tex-from-port)
  (import (scheme base) (scheme char) (scheme file))
  (include "tex-parser.scm"))
