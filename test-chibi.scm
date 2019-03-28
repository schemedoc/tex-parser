#! /usr/bin/env chibi-scheme

(import (scheme base)
        (scheme file)
        (scheme process-context)
        (scheme write)
        (tex-parser))

(define (main arguments)
  (for-each (lambda (tex-file)
              (display (with-input-from-file tex-file read-tex-document))
              (newline))
            (cdr arguments)))

(main (command-line))
