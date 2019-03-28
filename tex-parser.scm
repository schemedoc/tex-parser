(define (tex-command-char? ch)
  (or (char-alphabetic? ch)
      (char-numeric? ch)))

(define (not-tex-special-char? ch)
  (not (or (equal? ch #\{)
           (equal? ch #\})
           (equal? ch #\\))))

(define (read-tex-command-args)
  (let loop ((args '()))
    (if (not (read-char? #\{))
        args
        (loop (append args (list (read-tex-until #\})))))))

(define (read-tex-thing)
  (cond ((read-char? #\\)
         (let ((command (read-char* tex-command-char?)))
           (cond (command
                  (cons (string->symbol command)
                        (read-tex-command-args)))
                 (else
                  (read-char* not-tex-special-char?)))))
        ((read-char? #\{)
         (cons 'math (read-tex-until #\})))
        (else (read-char* not-tex-special-char?))))

(define (read-tex-until sentinel)
  (let loop ((things '()))
    (if (read-char? sentinel)
        things
        (let ((thing (read-tex-thing)))
          (if (not thing)
              things
              (loop (append things (list thing))))))))

(define (read-tex-document)
  (read-tex-until eof-object?))
