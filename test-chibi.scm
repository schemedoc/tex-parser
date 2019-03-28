#! /usr/bin/env chibi-scheme

(import (scheme base)
        (scheme file)
        (scheme process-context)
        (scheme write)
        (tex-parser))

(define (main arguments)
  (for-each (lambda (tex-file)
              (display (call-with-input-file tex-file parse-tex-from-port))
              (newline))
            (cdr arguments)))

(main (command-line))
