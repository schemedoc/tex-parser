(define (match-char? k char)
  (cond ((procedure? k) (not (not (k char))))
        ((char? k) (equal? k char))
        (else #f)))

(define (read-char? k)
  ;;(fprintf (current-error-port) "read-char? ~a~%" k)
  (and (match-char? k (peek-char))
       (begin (let ((char (read-char)))
                ;;(display char (current-error-port))
                ;;(newline (current-error-port))
                char))))

(define (read-char* k)
  (let* ((first-char (read-char? k))
         (chars (let ((out (open-output-string)))
                  (let loop ((char first-char))
                    (cond ((or (equal? #f char) (eof-object? char))
                           (get-output-string out))
                          (else
                           (write-char char out)
                           (loop (read-char? k))))))))
    (if (= 0 (string-length chars)) #f chars)))

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
          (cond ((not thing)
                 things)
                (else
                 ;;(fprintf (current-error-port) "Read thing: ~a~%" thing)
                 (loop (append things (list thing)))))))))

(define (parse-tex-from-port char-input-port)
  (parameterize ((current-input-port char-input-port))
    (read-tex-until eof-object?)))
