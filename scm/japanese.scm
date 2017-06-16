;;;
;;; Copyright (c) 2003-2013 uim Project https://github.com/uim/uim
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. Neither the name of authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this software
;;;    without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

;; Japanese EUC

(require-extension (srfi 1 2))
(require-custom "japanese-custom.scm")
(require "util.scm")

(define ja-rk-rule-additional
  '(
    ((("d" "s" "u"). ())("��" "��" "��"))

    ((("d" "h" "a"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "h" "i"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "h" "u"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "h" "e"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "h" "o"). ())(("��" "��" "�Î�") ("��" "��" "��")))

    ((("d" "w" "a"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "w" "i"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "w" "u"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "w" "e"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "w" "o"). ())(("��" "��" "�Ď�") ("��" "��" "��")))

    ((("k" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("s" "h" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "h" "i"). ())("��" "��" "��"))
    ((("s" "h" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "h" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "h" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("s" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("t" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("t" "h" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "h" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "h" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "h" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "h" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("h" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("f" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("f" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("f" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("f" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("f" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("x" "w" "a"). ())("��" "��" "��"))
    ((("x" "w" "i"). ())("��" "��" "��"))
    ((("x" "w" "e"). ())("��" "��" "��"))

    ((("w" "y" "i"). ())("��" "��" "��"))
    ((("w" "y" "e"). ())("��" "��" "��"))

    ((("c" "h" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "h" "i"). ())("��" "��" "��"))
    ((("c" "h" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "h" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "h" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("q" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("q" "y" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "y" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "y" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "y" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("q" "y" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("g" "w" "a"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "i"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "u"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "e"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "o"). ())(("��" "��" "����") ("��" "��" "��")))

    ((("z" "w" "a"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "w" "i"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "w" "u"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "w" "e"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "w" "o"). ())(("��" "��" "����") ("��" "��" "��")))

    ;((("n" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ;((("n" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ;((("n" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ;((("n" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ;((("n" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("b" "w" "a"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("b" "w" "i"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("b" "w" "u"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("b" "w" "e"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("b" "w" "o"). ())(("��" "��" "�̎�") ("��" "��" "��")))

    ((("p" "w" "a"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("p" "w" "i"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("p" "w" "u"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("p" "w" "e"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("p" "w" "o"). ())(("��" "��" "�̎�") ("��" "��" "��")))

    ((("m" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("y" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("r" "w" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "w" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "w" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "w" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "w" "o"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("d" "'" "i"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "'" "y" "u"). ())(("��" "��" "�Î�") ("��" "��" "��")))

    ((("d" "'" "u"). ())(("��" "��" "�Ď�") ("��" "��" "��")))

    ((("t" "'" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "'" "y" "u"). ())(("��" "��" "��") ("��" "��" "��")))

    ((("t" "'" "u"). ())(("��" "��" "��") ("��" "��" "��")))

    ))

(define ja-rk-rule (append ja-rk-rule-basic ja-rk-rule-additional))

(define ja-wide-rule
  '(("a" "��")
    ("b" "��")
    ("c" "��")
    ("d" "��")
    ("e" "��")
    ("f" "��")
    ("g" "��")
    ("h" "��")
    ("i" "��")
    ("j" "��")
    ("k" "��")
    ("l" "��")
    ("m" "��")
    ("n" "��")
    ("o" "��")
    ("p" "��")
    ("q" "��")
    ("r" "��")
    ("s" "��")
    ("t" "��")
    ("u" "��")
    ("v" "��")
    ("w" "��")
    ("x" "��")
    ("y" "��")
    ("z" "��")
    ("A" "��")
    ("B" "��")
    ("C" "��")
    ("D" "��")
    ("E" "��")
    ("F" "��")
    ("G" "��")
    ("H" "��")
    ("I" "��")
    ("J" "��")
    ("K" "��")
    ("L" "��")
    ("M" "��")
    ("N" "��")
    ("O" "��")
    ("P" "��")
    ("Q" "��")
    ("R" "��")
    ("S" "��")
    ("T" "��")
    ("U" "��")
    ("V" "��")
    ("W" "��")
    ("X" "��")
    ("Y" "��")
    ("Z" "��")

    ("1" "��")
    ("2" "��")
    ("3" "��")
    ("4" "��")
    ("5" "��")
    ("6" "��")
    ("7" "��")
    ("8" "��")
    ("9" "��")
    ("0" "��")

    ("-" "��")
    ("," "��")
    ("." "��")
    ("!" "��")
    ("\"" "��")
    ("#" "��")
    ("$" "��")
    ("%" "��")
    ("&" "��")
    ("'" "��")
    ("(" "��")
    (")" "��")
    ("~" "��")
    ("=" "��")
    ("^" "��")
    ("\\" "��")
    ("yen" "��")
    ("|" "��")
    ("`" "��")
    ("@" "��")
    ("{" "��")
    ("[" "��")
    ("+" "��")
    (";" "��")
    ("*" "��")
    (":" "��")
    ("}" "��")
    ("]" "��")
    ("<" "��")
    (">" "��")
    ("?" "��")
    ("/" "��")
    ("_"  "��")
    (" " "��")
    ))

;;
;; 2004-08-30 Takuro Ashie <ashie@homa.ne.jp>
;;
;;   It's a ad-hoc way to detect vowel and consonant in roma string.
;;   FIXME!
;;
(define ja-vowel-table
 '(("a" "a")
   ("i" "i")
   ("u" "u")
   ("e" "e")
   ("o" "o")
    ))

(define ja-consonant-syllable-table
 '(("b" "")
   ("c" "")
   ("d" "")
   ("f" "fa")
   ("g" "")
   ("h" "")
   ("j" "ji")
   ("k" "")
   ("l" "")
   ("m" "")
   ("n" "nn")
   ("p" "")
   ("q" "")
   ("r" "")
   ("s" "")
   ("t" "")
   ("v" "vu")
   ("w" "wu")
   ("x" "")
   ("y" "")
   ("z" "")
   ("ky" "ki")
   ("gy" "gi")
   ("sy" "si")
   ("zy" "zi")
   ("jy" "ji")
   ("ty" "ti")
   ("ts" "tu")
   ("cy" "ti")
   ("dy" "di")
   ("ny" "ni")
   ("hy" "hi")
   ("fy" "fu")
   ("by" "bi")
   ("py" "pi")
   ("my" "mi")
   ("ly" "li")
   ("ry" "ri")
   ("wh" "wu")
   ("ds" "du")
   ("dh" "de")
   ("dw" "do")
   ("kw" "ku")
   ("sh" "si")
   ("sw" "su")
   ("tw" "to")
   ("th" "te")
   ("hw" "hu")
   ("fw" "fu")
   ("xw" "wa")
   ("wy" "wi")
   ("ch" "ti")
   ("qw" "ku")
   ("qy" "ku")
   ("gw" "gu")
   ("zw" "zu")
   ("bw" "bu")
   ("pw" "pu")
   ("mw" "mu")
   ("yw" "yu")
   ("rw" "ru")
   ))

(define ja-default-small-tsu-roma "ltu")

;; "ja-direct-rule" seems to be used to commit a character immediately
;; even when japanese-context (i.e. preedit mode) is on.  I don't think the
;; rule is needed normally.  So I leave it null by default.  -- ekato
(define ja-direct-rule
  '(
    ))

;; space on (hiragana katakana halfkana) input mode
(define ja-space
  '("��" "��" " "))

;; space on (halfwidth-alnum fullwidth-alnum) input mode
(define ja-alnum-space
  '(" " "��"))

;;
(define ja-find-rec
  (lambda (c rule)
    (if (null? rule)
	#f
	(let ((r (car rule)))
	  (if (string=? c (car r))
	      (cadr r)
	      (ja-find-rec c (cdr rule)))))))

(define ja-wide
  (lambda (c)
    (or (ja-find-rec c ja-wide-rule)
        c)))

(define ja-direct
  (lambda (c)
    (ja-find-rec c ja-direct-rule)))

(define ja-vowel
  (lambda (c)
    (ja-find-rec c ja-vowel-table)))

(define ja-consonant-to-syllable
  (lambda (c)
    (ja-find-rec c ja-consonant-syllable-table)))

;;
;; 2004-08-30 Takuro Ashie <ashie@homa.ne.jp>
;;
;; ja-string-list-to-wide-alphabet
;;
;;   Convert alphabets in string list to wide alphabets.
;;   This procedure is ad-hoc. Maybe more generalize is needed.
;;
(define ja-string-list-to-wide-alphabet
  (lambda (char-list)
    (if (not (null? char-list))
        (string-append (ja-string-list-to-wide-alphabet (cdr char-list))
                       (ja-wide (car char-list)))
        "")))


;; Convert a invalid roma consonant at the end of string-list to a valid roma
;; consonant or valid roma string.
;;
;; "Invalid roma string-list" will be generated while editing a preedit string:
;;
;;     Convert a "n" which is followed by a vowel to "nn":
;;       1. at first, type a following string:
;;          ("ka" "n" "ki")
;;       2: press backspace (or move the cursor):
;;          ("ka" "n")
;;       3. type a vowel:
;;          ("ka" "n" "i")
;;       4. On this case, this procedure converts the list to:
;;          ("ka" "nn" "i")
;;
;;     Fix a broken "��":
;;       1.  at fisrt, type a following string:
;;             ("a" "t" "ti")
;;       2.  press backspace (or move the cursor):
;;             ("a" "t")
;;       3.  type remaining strings:
;;             ("a" "t" "ka" "nn" "be" "-")
;;      (3'. On this case, this procedure converts the list to:
;;             ("a" "t") -> ("a" "ltu"))
;;       4.  On this case, this procedure converts the list to:
;;             ("a" "k" "ka" "nn" "be" "-")
(define ja-fix-deleted-raw-str-to-valid-roma!
  (lambda (raw-str)
    (if (not (null? (car raw-str)))
	(let ((lst (car raw-str)))
	  (if (ja-consonant-to-syllable (car lst))
	      (if (= (string-length (ja-consonant-to-syllable (car lst))) 2)
		  (set-car! lst (ja-consonant-to-syllable (car lst)))
		  (set-car! lst ja-default-small-tsu-roma)))))))

;; not sure this is the good place and the procedure is well written...
(define (list-seq-contained? large small)
  (define (list-seq-partial-equal-internal ll sl n)
    (let ((len (length sl)))
      (if (> len (length ll))
	  #f
	  (if (= len (length (filter-map equal? ll sl)))
	      n
	      (list-seq-partial-equal-internal (cdr ll) sl (+ n 1))))))
  (if (null? small)
      #f
      (list-seq-partial-equal-internal large small 0)))

;; revise string list contains "����"
;; (("��") ("��")) -> ("����")
(define ja-join-vu
  (lambda (lst)
    (let ((sub (member "��" lst)))
      (if (and
	   sub
	   (not (null? (cdr sub)))
	   (string=? (car (cdr sub)) "��"))
	  (append
	   (list-head lst (- (length lst) (length sub)))
	   '("����")
	   (ja-join-vu (list-tail lst (+ (- (length lst) (length sub)) 2))))
	  (if (and
	       sub
	       (member "��" (cdr sub)))
	      (append
	       (list-head lst (+ (- (length lst) (length sub)) 1))
	       (ja-join-vu (cdr sub)))
	      lst)))))

;; get ("��" "��" "��") from "��"
(define ja-find-kana-list-from-rule
  (lambda (rule str)
    (if (not (null? rule))
	(if (pair? (member str (car (cdr (car rule)))))
	    (car (cdr (car rule)))
	    (ja-find-kana-list-from-rule (cdr rule) str))
        (if (string=?  str "��")
	    (list "��" "��" "��")
	    (list str str str)))))

;; (("��" "��" "����") ("��" "��" "��") ("��" "��" "��")) from ("��" "��" "��")
(define ja-make-kana-str-list
  (lambda (sl)
    (if (not (null? sl))
	(append (list (ja-find-kana-list-from-rule ja-rk-rule-basic (car sl)))
		(ja-make-kana-str-list (cdr sl)))
	'())))

(define ja-type-direct	       -1)
(define ja-type-hiragana	0)
(define ja-type-katakana	1)
(define ja-type-halfkana	2)
(define ja-type-halfwidth-alnum	3)
(define ja-type-fullwidth-alnum	4)

(define ja-opposite-kana
  (lambda (kana)
    (cond
     ((= kana ja-type-hiragana)
      ja-type-katakana)
     ((= kana ja-type-katakana)
      ja-type-hiragana)
     ((= kana ja-type-halfkana)
      ja-type-hiragana))))

;; getting required type of kana string from above kana-str-list
;; (ja-make-kana-str
;;  (("��" "��" "����") ("��" "��" "��") ("��" "��" "��"))
;;  ja-type-katakana)
;;  -> "����"
(define ja-make-kana-str
  (lambda (sl type)
    (let ((get-str-by-type
	   (lambda (l)
	     (cond
	      ((= type ja-type-hiragana)
	       (caar l))
	      ((= type ja-type-katakana)
	       (car (cdar l)))
	      ((= type ja-type-halfkana)
	       (cadr (cdar l)))))))
      (if (not (null? sl))
	  (string-append (ja-make-kana-str (cdr sl) type)
			 (get-str-by-type sl))
	  ""))))

(define japanese-roma-set-yen-representation
  (lambda ()
    ;; Since ordinary Japanese users press the "yen sign" key on
    ;; Japanese keyboard in alphanumeric-mode "to input character code
    ;; 134" rather than "to input yen sign symbol", I changed the
    ;; fullwidth yen sign with backslash.  -- YamaKen 2007-09-17
    ;;(set-symbol-value! 'yen "��")  ;; XXX
    (set-symbol-value! 'yen "\\")
    ))

;; TODO: Support new custom type string-list.
(define japanese-auto-start-henkan-keyword-list '("��" "��" "��" "��" "��" "��" "��" "��" "��" ")" ";" ":" "��" "��" "��" "��" "��" "��" "��" "��" "��" "}" "]" "?" "." "," "!"))

(define ja-rk-rule-consonant-to-keep
  (map (lambda (c)
         (if (= (string-length c) 1)
           (list (cons (list c) '()) (list c c c))
           (let ((lst (reverse (string-to-list c))))
             (list (cons lst '()) (list (list (car lst) (car lst) (car lst))
                                        (list (cadr lst) (cadr lst) (cadr lst)))))))
       (filter (lambda (x) (not (string=? "n" x)))
               (map car ja-consonant-syllable-table))))

(define ja-rk-rule-keep-consonant-update
  (lambda ()
    (if ja-rk-rule-keep-consonant?
      (set! ja-rk-rule (append ja-rk-rule-consonant-to-keep
                               ja-rk-rule-basic
                               ja-rk-rule-additional))
      (set! ja-rk-rule (append ja-rk-rule-basic
                               ja-rk-rule-additional)))))

;; In ja-rk-rule-update,
;; don't set ja-rk-rule-basic to ja-rk-rule-basic-uim
;;
;; If you do so, when the following conditions are met
;;   1) users call ja-rk-rule-update in ~/.uim
;;   2) ja-rk-rule-type is 'uim (default value)
;; ja-rk-rule-basic is always overridden
;; with ja-rk-rule-basic-uim.
;; This is an unwanted behavior for users.
(define ja-rk-rule-update
  (lambda ()
    (and
      (eq? ja-rk-rule-type 'custom)
      (set! ja-rk-rule-basic
        (ja-rk-rule-table->rule ja-rk-rule-table-basic)))
    (ja-rk-rule-keep-consonant-update)))

;;; Convert EUC-JP code to EUC-JP string (cf. ucs->utf8-string in ichar.scm)
(define (ja-euc-jp-code->euc-jp-string code)
  (with-char-codec "EUC-JP"
    (lambda ()
      (let ((str (list->string (list (integer->char code)))))
        (with-char-codec "ISO-8859-1"
          (lambda ()
            (%%string-reconstruct! str)))))))

;;; Convert JIS code(ISO-2022-JP) to EUC-JP string
(define (ja-jis-code->euc-jp-string state jis1 jis2)
  (let
    ((ej0 (if (eq? state 'jisx0213-plane2) #x8f 0))
     (ej1 (+ jis1 #x80))
     (ej2 (+ jis2 #x80)))
    (and
      ;; sigscheme/src/encoding.c:eucjp_int2str()
      (<= #xa1 ej1 #xfe) ; IN_GR94()
      (if (= ej0 #x8f) ; SS3?
        (<= #xa1 ej2 #xfe) ; IN_GR94()
        (<= #xa0 ej2 #xff)) ; IN_GR96()
      (ja-euc-jp-code->euc-jp-string
        (+ (* ej0 #x10000) (* ej1 #x100) ej2)))))

;;; Convert reverse string list of JIS code to one EUC-JP kanji string
;;; ("d" "2" "0" "5") -> "Э"
(define (ja-kanji-code-input-jis str-list)
  (and-let*
    ((length=4? (= (length str-list) 4))
     (str1 (string-list-concat (take-right str-list 2)))
     (str2 (string-list-concat (take str-list 2)))
     (jis1 (string->number str1 16))
     (jis2 (string->number str2 16)))
    (ja-jis-code->euc-jp-string 'jisx0213-plane1 jis1 jis2)))

;;; Convert reverse string list of Kuten code to one EUC-JP kanji string
;;; ("3" "1" "-" "8" "4" "-" "1") -> "Э"
(define (ja-kanji-code-input-kuten str-list)
  (let*
    ((numlist (string-split (string-list-concat str-list) "-"))
     (men-exists? (>= (length numlist) 3))
     (men (if men-exists? (string->number (list-ref numlist 0)) 1))
     (ku (string->number (list-ref numlist (if men-exists? 1 0))))
     (ten (string->number (list-ref numlist (if men-exists? 2 1)))))
    (and men ku ten (<= 1 men 2)
      (ja-jis-code->euc-jp-string
        (if (= men 2) 'jisx0213-plane2 'jisx0213-plane1)
        (+ ku #x20) (+ ten #x20)))))

;;; Convert reverse string list of UCS to one EUC-JP kanji string
;;; ("5" "8" "E" "4" "+" "U") -> "Э"
(define (ja-kanji-code-input-ucs str-list)
  (and-let*
    ((str-list-1 (drop-right str-list 1)) ; drop last "U"
     (not-only-u? (not (null? str-list-1)))
     (ucs-str (if (string=? (last str-list-1) "+")
                (drop-right str-list-1 1)
                str-list-1))
     (ucs (string->number (string-list-concat ucs-str) 16))
     ;; range check to avoid error
     (valid? ; sigscheme/src/sigschemeinternal.h:ICHAR_VALID_UNICODEP()
      (or
        (<= 0 ucs #xd7ff)
        (<= #xe000 ucs #x10ffff)))
     (utf8-str (ucs->utf8-string ucs)))
    (iconv-convert "EUC-JP" "UTF-8" utf8-str)))

;;; Convert reverse string list to one EUC-JP kanji string
(define (ja-kanji-code-input str-list)
  (cond
    ((string-ci=? (last str-list) "u")
      (ja-kanji-code-input-ucs str-list))
    ((member "-" str-list)
      (ja-kanji-code-input-kuten str-list))
    (else
      (ja-kanji-code-input-jis str-list))))

;;
(require "rk.scm")

(ja-rk-rule-update)
