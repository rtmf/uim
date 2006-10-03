;;  Filename : test-define.scm
;;  About    : unit test for R5RS 'define'
;;
;;  Copyright (C) 2005-2006 Kazuki Ohta <mover AT hct.zaq.ne.jp>
;;
;;  All rights reserved.
;;
;;  Redistribution and use in source and binary forms, with or without
;;  modification, are permitted provided that the following conditions
;;  are met:
;;
;;  1. Redistributions of source code must retain the above copyright
;;     notice, this list of conditions and the following disclaimer.
;;  2. Redistributions in binary form must reproduce the above copyright
;;     notice, this list of conditions and the following disclaimer in the
;;     documentation and/or other materials provided with the distribution.
;;  3. Neither the name of authors nor the names of its contributors
;;     may be used to endorse or promote products derived from this software
;;     without specific prior written permission.
;;
;;  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS
;;  IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
;;  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
;;  PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR
;;  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;;  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;; internal definitions in 'define' are writtin at test-define-internal.scm
;; internal definitions in 'let' variants are writtin at test-let.scm
;; see also test-begin.scm for top-level definitions

(load "./test/unittest.scm")

(define tn test-name)
(define *test-track-progress* #f)

(tn "define invalid form")
(assert-error (tn)
	      (lambda ()
		(define)))
(assert-error (tn)
	      (lambda ()
		(define . a)))
(assert-error (tn)
	      (lambda ()
		(define a)))
(assert-error (tn)
	      (lambda ()
		(define a . 2)))
(assert-error (tn)
	      (lambda ()
		(define a 1 'excessive)))
(assert-error (tn)
	      (lambda ()
		(define a 1 . 'excessive)))
;; <variable> is not a symbol
(assert-error (tn)
	      (lambda ()
		(define 1)))
(assert-error (tn)
	      (lambda ()
		(define 1 . 1)))
(assert-error (tn)
	      (lambda ()
		(define 1 1)))
(assert-error (tn)
	      (lambda ()
		(define #t 1)))
(assert-error (tn)
	      (lambda ()
		(define #f 1)))
(assert-error (tn)
	      (lambda ()
		(define 1 1 'excessive)))
(assert-error (tn)
	      (lambda ()
		(define 1 1 . 'excessive)))
;; function forms
(assert-error (tn)
	      (lambda ()
		(define ())))
(assert-error (tn)
	      (lambda ()
		(define () 1)))
(assert-error (tn)
              (lambda ()
                (define (f))))
(assert-error (tn)
              (lambda ()
                (define (f) . 1)))
(assert-error (tn)
              (lambda ()
                (define (f) 1 . 1)))
(assert-error (tn)
              (lambda ()
                (define (f x))))
(assert-error (tn)
              (lambda ()
                (define (f x) . 1)))
(assert-error (tn)
              (lambda ()
                (define (f x) 1 . 1)))
(assert-error (tn)
              (lambda ()
                (define (f . x))))
(assert-error (tn)
              (lambda ()
                (define (f . x) . 1)))
(assert-error (tn)
              (lambda ()
                (define (f . x) 1 . 1)))

(tn "define syntactic keywords as value")
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn define)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn if)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn and)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn cond)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn begin)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn do)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn delay)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn let*)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn else)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn =>)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn quote)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn quasiquote)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn unquote)
                       (interaction-environment))))
(assert-error  (tn)
               (lambda ()
                 (eval '(define syn unquote-splicing)
                       (interaction-environment))))

(tn "define syntactic keywords as value internally")
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn define)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn if)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn and)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn cond)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn begin)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn do)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn delay)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn let*)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn else)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn =>)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn quote)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn quasiquote)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn unquote)
                   #t)))
(assert-error  (tn)
               (lambda ()
                 (let ()
                   (define syn unquote-splicing)
                   #t)))

(if (and (provided? "sigscheme")
         (provided? "strict-argcheck"))
    (begin
      (tn "define function form: boolean as an arg")
      (assert-error (tn) (lambda () (define (f . #t) #t)))
      (assert-error (tn) (lambda () (define (f #t) #t)))
      (assert-error (tn) (lambda () (define (f x #t) #t)))
      (assert-error (tn) (lambda () (define (f #t x) #t)))
      (assert-error (tn) (lambda () (define (f x . #t) #t)))
      (assert-error (tn) (lambda () (define (f #t . x) #t)))
      (assert-error (tn) (lambda () (define (f x y #t) #t)))
      (assert-error (tn) (lambda () (define (f x y . #t) #t)))
      (assert-error (tn) (lambda () (define (f x #t y) #t)))
      (assert-error (tn) (lambda () (define (f x #t . y) #t)))
      (tn "define function form: intger as an arg")
      (assert-error (tn) (lambda () (define (f . 1) #t)))
      (assert-error (tn) (lambda () (define (f 1) #t)))
      (assert-error (tn) (lambda () (define (f x 1) #t)))
      (assert-error (tn) (lambda () (define (f 1 x) #t)))
      (assert-error (tn) (lambda () (define (f x . 1) #t)))
      (assert-error (tn) (lambda () (define (f 1 . x) #t)))
      (assert-error (tn) (lambda () (define (f x y 1) #t)))
      (assert-error (tn) (lambda () (define (f x y . 1) #t)))
      (assert-error (tn) (lambda () (define (f x 1 y) #t)))
      (assert-error (tn) (lambda () (define (f x 1 . y) #t)))
      (tn "define function form: null as an arg")
      (assert-true  (tn)            (define (f . ()) #t))
      (assert-error (tn) (lambda () (define (f ()) #t)))
      (assert-error (tn) (lambda () (define (f x ()) #t)))
      (assert-error (tn) (lambda () (define (f () x) #t)))
      (assert-true  (tn)            (define (f x . ()) #t))
      (assert-error (tn) (lambda () (define (f () . x) #t)))
      (assert-error (tn) (lambda () (define (f x y ()) #t)))
      (assert-true  (tn)            (define (f x y . ()) #t))
      (assert-error (tn) (lambda () (define (f x () y) #t)))
      (assert-error (tn) (lambda () (define (f x () . y) #t)))
      (tn "define function form: pair as an arg")
      (assert-true  (tn)            (define (f . (a)) #t))
      (assert-error (tn) (lambda () (define (f (a)) #t)))
      (assert-error (tn) (lambda () (define (f x (a)) #t)))
      (assert-error (tn) (lambda () (define (f (a) x) #t)))
      (assert-true  (tn)            (define (f x . (a)) #t))
      (assert-error (tn) (lambda () (define (f (a) . x) #t)))
      (assert-error (tn) (lambda () (define (f x y (a)) #t)))
      (assert-true  (tn)            (define (f x y . (a)) #t))
      (assert-error (tn) (lambda () (define (f x (a) y) #t)))
      (assert-error (tn) (lambda () (define (f x (a) . y) #t)))
      (tn "define function form: char as an arg")
      (assert-error (tn) (lambda () (define (f . #\a) #t)))
      (assert-error (tn) (lambda () (define (f #\a) #t)))
      (assert-error (tn) (lambda () (define (f x #\a) #t)))
      (assert-error (tn) (lambda () (define (f #\a x) #t)))
      (assert-error (tn) (lambda () (define (f x . #\a) #t)))
      (assert-error (tn) (lambda () (define (f #\a . x) #t)))
      (assert-error (tn) (lambda () (define (f x y #\a) #t)))
      (assert-error (tn) (lambda () (define (f x y . #\a) #t)))
      (assert-error (tn) (lambda () (define (f x #\a y) #t)))
      (assert-error (tn) (lambda () (define (f x #\a . y) #t)))
      (tn "define function form: string as an arg")
      (assert-error (tn) (lambda () (define (f . "a") #t)))
      (assert-error (tn) (lambda () (define (f "a") #t)))
      (assert-error (tn) (lambda () (define (f x "a") #t)))
      (assert-error (tn) (lambda () (define (f "a" x) #t)))
      (assert-error (tn) (lambda () (define (f x . "a") #t)))
      (assert-error (tn) (lambda () (define (f "a" . x) #t)))
      (assert-error (tn) (lambda () (define (f x y "a") #t)))
      (assert-error (tn) (lambda () (define (f x y . "a") #t)))
      (assert-error (tn) (lambda () (define (f x "a" y) #t)))
      (assert-error (tn) (lambda () (define (f x "a" . y) #t)))
      (tn "define function form: vector as an arg")
      (assert-error (tn) (lambda () (define (f . #(a)) #t)))
      (assert-error (tn) (lambda () (define (f #(a)) #t)))
      (assert-error (tn) (lambda () (define (f x #(a)) #t)))
      (assert-error (tn) (lambda () (define (f #(a) x) #t)))
      (assert-error (tn) (lambda () (define (f x . #(a)) #t)))
      (assert-error (tn) (lambda () (define (f #(a) . x) #t)))
      (assert-error (tn) (lambda () (define (f x y #(a)) #t)))
      (assert-error (tn) (lambda () (define (f x y . #(a)) #t)))
      (assert-error (tn) (lambda () (define (f x #(a) y) #t)))
      (assert-error (tn) (lambda () (define (f x #(a) . y) #t)))))

(tn "top-level definition invalid forms")
;; top-level define cannot be placed under a non-begin structure.
;; See also test-begin.scm for top-level definitions.
(if (provided? "strict-toplevel-definitions")
    (begin
      (assert-error  (tn)
                     (lambda ()
                       (eval '(if #t (define var0 1))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(if #f #t (define var0 1))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(and (define var0 1))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(or (define var0 1))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(cond (#t (define var0 1)))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(cond (else (define var0 1)))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(case 'key ((key) (define var0 1)))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(case 'key (else (define var0 1)))
                             (interaction-environment))))
      (tn "ttt")
      ;; test being evaled at non-tail part of <sequence>
      (assert-error  (tn)
                     (lambda ()
                       (eval '(and (define var0 1) #t)
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(or (define var0 1) #t)
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(cond (#t (define var0 1) #t))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(cond (else (define var0 1) #t))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(case 'key ((key) (define var0 1) #t))
                             (interaction-environment))))
      (assert-error  (tn)
                     (lambda ()
                       (eval '(case 'key (else (define var0 1) #t))
                             (interaction-environment))))))

; basic define
(define val1 3)
(assert-equal? "basic define check" 3 val1)

; redefine
(define val1 5)
(assert-equal? "redefine check" 5 val1)

; define lambda
(define (what? x)
  "DEADBEEF" x)
(assert-equal? "func define" 10 (what? 10))

(define what2?
  (lambda (x)
    "DEADBEEF" x))
(assert-equal? "func define" 10 (what2? 10))

(define (nullarg)
  "nullarg")
(assert-equal? "nullarg test" "nullarg" (nullarg))

(define (add x y)
  (+ x y))
(assert-equal? "func define" 10 (add 2 8))

; tests for dot list arguments
(define (dotarg1 . a)
  a)
(assert-equal? "dot arg test 1" '(1 2) (dotarg1 1 2))

(define (dotarg2 a . b)
  a)
(assert-equal? "dot arg test 2" 1 (dotarg2 1 2))

(define (dotarg3 a . b)
  b)
(assert-equal? "dot arg test 3" '(2) (dotarg3 1 2))
(assert-equal? "dot arg test 4" '(2 3) (dotarg3 1 2 3))


(define (dotarg4 a b . c)
  b)
(assert-equal? "dot arg test 5" 2 (dotarg4 1 2 3))

(define (dotarg5 a b . c)
  c)
(assert-equal? "dot arg test 6" '(3 4) (dotarg5 1 2 3 4))

; set!
(define (set-dot a . b)
  (set! b '(1 2))
  b)
(assert-equal? "set dot test" '(1 2) (set-dot '()))

; test for internal define
; more comprehensive tests are written at test-define-internal.scm
(define (idefine-o a)
  (define (idefine-i c)
    (+ c 3))
  (idefine-i a))
(assert-equal? "internal define1" 5 (idefine-o 2))

(define (idefine0 a)
  (define (idefine1 . args)
    (apply +  args))
  (define (idefine2 c)
    (+ c 2))
  (+ (idefine1 1 2 3 4 5) (idefine2 a)))
(assert-equal? "internal define2" 17 (idefine0 0))


(total-report)