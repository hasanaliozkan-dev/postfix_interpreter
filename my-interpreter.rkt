#lang br/quicklang

; Racket Reader
; read-syntax runs when execute your language.
; It turns language into Racket code.
;It reads from the port and return a syntax-object.
(define (read-syntax path port)                                                ;This function takes two positional argumenets path and port.
  (define src-lines (port->lines port))                                        ;port->lines  converts the contents of port to a list of strings. 
  (define src-datums (my-format-datums src-lines))                             ;we convert these strings into datums our custom method.
  
  ;(define src-datums (format-datums '~a src-lines))                           ;original line on fun-stacker chapter.
  ; (displayln src-datums) ; debugging
  
  (define module-datum `(module my-interpreter-mod "my-interpreter.rkt"        ;we make our module datum.
                          (handle-args ,@src-datums)))                         ; ',@' (unquote-splicing) is used to insert list of multiple values to a list.
  ;(displayln module-datum) ; debugging
  (datum->syntax #f module-datum))                                             ;datum->syntax is convert our datum to a syntax object.
              
(provide read-syntax)                                                          ;in order to make public.


;it takes all of the lines in the file 
;it splits  line and apply second helper function  
(define (my-format-datums lines)
  ; (writeln lines)
  (for/list ((l lines)
             ;(writeln l);debugging
             #:unless (string=? "" l))
    (apply my-format-datum (string-split l))))

;it takes line's args and converts to them to a datum object.
(define (my-format-datum . args)
  ;(writeln args)
  `(handle-args ,@args))


; Racket expander
(define-macro (my-interpreter-module-begin HANDLE-ARGS-EXPR)                   ;we defining our macro
  #'(#%module-begin                                                            ;Every expander must export a #%module-begin macro. 
     HANDLE-ARGS-EXPR)) 

(provide (rename-out (my-interpreter-module-begin #%module-begin)))            ;we make public but this time my-interpreter-module-begin is avail­able outside   
;this source file with the correct #%module-begin name.

;To determine the string is numeric or not
(define (string-numeric? s) 
  (number? (string->number s)))

(define op-result 0)                                                           ;general opeartion's result it changes depend on the operator.

;Our handle method everything is in here.
(define (handle-args . args) ;'.' means there can be any number of arguments.
  ;(writeln args);debugging
  
  (for/fold ([stack-acc empty])
            ([arg (in-list args)])
    
    ;to display the top of the stack(result the operation) if the result is +nan.0 that means division by zero error.
    (cond
      [(list? arg)
       (if (equal? (first arg) +nan.0)
           (displayln "Error: Division By Zero Error!!!")
           (displayln (first arg)))]

      ;Check the item is a number if it is push it to a stack.
      [(string-numeric? arg) (cons (string->number arg) stack-acc) ] ;(display "numeric ") (displayln arg) (displayln stack-acc)];debugging

      ;to do adding operations it adds all number in the stack until find the '+' operator
      ;then push the result into the stack.
      [(string=? "+" arg)
       (set! op-result 0)
       (for ([i stack-acc])
         (set! op-result (+  op-result (first stack-acc)))
         (set! stack-acc (rest stack-acc))
         )

       (cons op-result  stack-acc )]


      
      ;to do subtracting operations it subtracts all number in the stack until find the '-' operator
      ;then push the result into the stack.
      [(string=? "-" arg)
       (cond [(=(length stack-acc) 1) (set! op-result 0)]);to take negate
       
       (cond [ (>(length stack-acc) 1) (set! op-result (last stack-acc))
              (set! stack-acc (take stack-acc (- (length stack-acc) 1)))])
       
       ;(writeln result);debugging

       ;order of racket prefix implementation we subtract the number left to right
       ;so we reach the item that is at bottom of the stack.
       (for ([i stack-acc])
         (set! op-result (-  op-result (last stack-acc)))
         (set! stack-acc (take stack-acc (- (length stack-acc) 1)))
         ;(writeln stack-acc);debugging
         ;(display "i->");debugging
         ;(writeln i);debugging
         )
       (cons op-result  stack-acc )]

      ;to do dividing operations it divides all number in the stack until find the '/' operator
      ;then push the result into the stack.
      [(string=? "/" arg)
      
       (cond
         [(and (=(length stack-acc) 1) (=(first stack-acc) 0)) 
          ;(displayln "Error: Division By Zero Error!!!")
          (define op-result +nan.f);to prevent getting actual error while taking reverse a number by multiplication.
          (cons op-result  stack-acc )]
         
         [(=(length stack-acc) 1)                                              ;take reverse a number by multiplication.
          (define op-result (/ 1 (first stack-acc)))
          (set! stack-acc (rest stack-acc))
          (cons op-result stack-acc)];

         [ (=(first stack-acc) 0)
          ;(displayln "Error: Division By Zero Error!!!")
          (define op-result +nan.f);to prevent getting actual error
          (cons op-result  stack-acc )]
         ;order of racket prefix implementation we divide the number left to right
         ;so we reach the item that is at bottom of the stack.
         [else 
          (set! op-result (last stack-acc))
          (set! stack-acc (take stack-acc (-(length stack-acc)1)))

          (for ([i stack-acc])
            (set! op-result (/  op-result (last stack-acc)));
            (set! stack-acc (take stack-acc (-(length stack-acc)1))))

          (cons op-result  stack-acc )])]

      
      ;to do multiplaying operations it multiplies all number in the stack until find the '*' operator
      ;then push the result into the stack.
      [(string=? "*" arg)
       (set! op-result 1)
       (for ([i stack-acc])
         (set! op-result (*  op-result (first stack-acc)))
         (set! stack-acc (rest stack-acc))
         )

       (cons op-result  stack-acc )])))

(provide handle-args)                                                          ;to make public