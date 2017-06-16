;;; anthy.scm: Anthy for uim.
;;; charset: EUC-JP
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

(require-extension (srfi 1 8))

(require "util.scm")
(require "ustr.scm")
(require "japanese.scm")
(require-custom "generic-key-custom.scm")
(require-custom "anthy-custom.scm")
(require-custom "anthy-key-custom.scm")


;;; implementations

(define anthy-lib-initialized? #f)
(define anthy-version #f)

(define anthy-type-direct          ja-type-direct)
(define anthy-type-hiragana        ja-type-hiragana)
(define anthy-type-katakana        ja-type-katakana)
(define anthy-type-halfkana        ja-type-halfkana)
(define anthy-type-halfwidth-alnum ja-type-halfwidth-alnum)
(define anthy-type-fullwidth-alnum ja-type-fullwidth-alnum)

(define anthy-input-rule-roma 0)
(define anthy-input-rule-kana 1)
(define anthy-input-rule-azik 2)
(define anthy-input-rule-act 3)
(define anthy-input-rule-kzik 4)

(define anthy-candidate-type-katakana -2)
(define anthy-candidate-type-hiragana -3)
(define anthy-candidate-type-halfkana -4)
;; below are not defined in Anthy
(define anthy-candidate-type-halfwidth-alnum -5)
(define anthy-candidate-type-fullwidth-alnum -6)
(define anthy-candidate-type-upper-halfwidth-alnum -7)
(define anthy-candidate-type-upper-fullwidth-alnum -8)

;; I don't think the key needs to be customizable.
(define-key anthy-space-key? '(" "))

;; Handle Anthy's version scheme like 7100b, 8158memm.
(define anthy-version->major.minor
  (lambda (vstr)
    (if (string=? vstr "(unknown)")
	'("-1" . "")
	(receive (maj min) (span char-numeric? (string->list vstr))
	  (cons (list->string maj)
		(list->string min))))))

(define anthy-prepare-input-rule-activation
  (lambda (ac)
    (cond
     ((anthy-context-converting ac)
      (anthy-do-commit ac))
     ((anthy-context-transposing ac)
      (im-commit ac (anthy-transposing-text ac)))
     ((and
       (anthy-context-on ac)
       (anthy-has-preedit? ac))
      (im-commit
       ac (anthy-make-whole-string ac #t (anthy-context-kana-mode ac)))))
    (anthy-flush ac)
    (anthy-update-preedit ac)))

(define anthy-prepare-input-mode-activation
  (lambda (ac new-mode)
    (let ((old-kana (anthy-context-kana-mode ac)))
      (cond
       ((anthy-context-converting ac)
	(anthy-do-commit ac))
       ((anthy-context-transposing ac)
	(im-commit ac (anthy-transposing-text ac))
	(anthy-flush ac))
       ((and
	 (anthy-context-on ac)
	 (anthy-has-preedit? ac)
	 (not (= old-kana new-mode)))
	(im-commit
	 ac (anthy-make-whole-string ac #t (anthy-context-kana-mode ac)))
	(anthy-flush ac)))
      (anthy-update-preedit ac))))

(register-action 'action_anthy_hiragana
;;		 (indication-alist-indicator 'action_anthy_hiragana
;;					     anthy-input-mode-indication-alist)
		 (lambda (ac) ;; indication handler
		   '(ja_hiragana
		     "��"
		     "�Ҥ餬��"
		     "�Ҥ餬�����ϥ⡼��"))

		 (lambda (ac) ;; activity predicate
		   (and (anthy-context-on ac)
			(not (anthy-context-alnum ac))
			(= (anthy-context-kana-mode ac)
			   anthy-type-hiragana)))

		 (lambda (ac) ;; action handler
		   (anthy-prepare-input-mode-activation ac anthy-type-hiragana)
		   (anthy-context-set-on! ac #t)
		   (anthy-context-set-alnum! ac #f)
		   (anthy-context-change-kana-mode! ac anthy-type-hiragana)))

(register-action 'action_anthy_katakana
;;		 (indication-alist-indicator 'action_anthy_katakana
;;					     anthy-input-mode-indication-alist)
		 (lambda (ac)
		   '(ja_katakana
		     "��"
		     "��������"
		     "�����������ϥ⡼��"))
		 (lambda (ac)
		   (and (anthy-context-on ac)
			(not (anthy-context-alnum ac))
			(= (anthy-context-kana-mode ac)
			   anthy-type-katakana)))
		 (lambda (ac)
		   (anthy-prepare-input-mode-activation ac anthy-type-katakana)
		   (anthy-context-set-on! ac #t)
		   (anthy-context-set-alnum! ac #f)
		   (anthy-context-change-kana-mode! ac anthy-type-katakana)))

(register-action 'action_anthy_halfkana
;;		 (indication-alist-indicator 'action_anthy_halfkana
;;					     anthy-input-mode-indication-alist)
		 (lambda (ac)
		   '(ja_halfkana
		     "��"
		     "Ⱦ�ѥ�������"
		     "Ⱦ�ѥ����������ϥ⡼��"))
		 (lambda (ac)
		   (and (anthy-context-on ac)
			(not (anthy-context-alnum ac))
			(= (anthy-context-kana-mode ac)
			   anthy-type-halfkana)))
		 (lambda (ac)
		   (anthy-prepare-input-mode-activation ac anthy-type-halfkana)
		   (anthy-context-set-on! ac #t)
		   (anthy-context-set-alnum! ac #f)
		   (anthy-context-change-kana-mode! ac anthy-type-halfkana)))

(register-action 'action_anthy_halfwidth_alnum
		 (lambda (ac)
		   '(ja_halfwidth_alnum
		     "a"
		     "Ⱦ�ѱѿ�"
		     "Ⱦ�ѱѿ����ϥ⡼��"))
		 (lambda (ac)
		   (and (anthy-context-on ac)
			(anthy-context-alnum ac)
			(= (anthy-context-alnum-type ac)
			   anthy-type-halfwidth-alnum)))
		 (lambda (ac)
		   (anthy-prepare-input-mode-activation
		    ac (anthy-context-kana-mode ac))
		   (anthy-context-set-on! ac #t)
		   (anthy-context-set-alnum! ac #t)
		   (anthy-context-set-alnum-type!
		    ac anthy-type-halfwidth-alnum)))

(register-action 'action_anthy_direct
;;		 (indication-alist-indicator 'action_anthy_direct
;;					     anthy-input-mode-indication-alist)
		 (lambda (ac)
		   '(ja_direct
		     "-"
		     "ľ������"
		     "ľ��(̵�Ѵ�)���ϥ⡼��"))
		 (lambda (ac)
		   (not (anthy-context-on ac)))
		 (lambda (ac)
		   (anthy-prepare-input-mode-activation ac anthy-type-direct)
		   (anthy-context-set-on! ac #f)))

(register-action 'action_anthy_fullwidth_alnum
;;		 (indication-alist-indicator 'action_anthy_fullwidth_alnum
;;					     anthy-input-mode-indication-alist)
		 (lambda (ac)
		   '(ja_fullwidth_alnum
		     "��"
		     "���ѱѿ�"
		     "���ѱѿ����ϥ⡼��"))
		 (lambda (ac)
		   (and (anthy-context-on ac)
			(anthy-context-alnum ac)
			(= (anthy-context-alnum-type ac)
			   anthy-type-fullwidth-alnum)))
		 (lambda (ac)
		   (anthy-prepare-input-mode-activation
		    ac (anthy-context-kana-mode ac))
		   (anthy-context-set-on! ac #t)
		   (anthy-context-set-alnum! ac #t)
		   (anthy-context-set-alnum-type!
		    ac anthy-type-fullwidth-alnum)))

(register-action 'action_anthy_roma
;;		 (indication-alist-indicator 'action_anthy_roma
;;					     anthy-kana-input-method-indication-alist)
		 (lambda (ac)
		   '(ja_romaji
		     "��"
		     "���޻�"
		     "���޻����ϥ⡼��"))
		 (lambda (ac)
		   (= (anthy-context-input-rule ac)
		      anthy-input-rule-roma))
		 (lambda (ac)
		   (anthy-prepare-input-rule-activation ac)
		   (rk-context-set-rule! (anthy-context-rkc ac)
					 ja-rk-rule)
		   (japanese-roma-set-yen-representation)
		   (anthy-context-set-input-rule! ac anthy-input-rule-roma)))

(register-action 'action_anthy_kana
;;		 (indication-alist-indicator 'action_anthy_kana
;;					     anthy-kana-input-method-indication-alist)
		 (lambda (ac)
		   '(ja_kana
		     "��"
		     "����"
		     "�������ϥ⡼��"))
		 (lambda (ac)
		   (= (anthy-context-input-rule ac)
		      anthy-input-rule-kana))
		 (lambda (ac)
		   (anthy-prepare-input-rule-activation ac)
                   (require "japanese-kana.scm")
		   (anthy-context-set-input-rule! ac anthy-input-rule-kana)
		   (anthy-context-change-kana-mode! ac (anthy-context-kana-mode ac))
		   (anthy-context-set-alnum! ac #f)
		   (japanese-roma-set-yen-representation)
		   ;;(define-key anthy-kana-toggle-key? "")
		   ;;(define-key anthy-on-key? generic-on-key?)
		   ;;(define-key anthy-fullwidth-alnum-key? "")
		   ))

(register-action 'action_anthy_azik
;;		 (indication-alist-indicator 'action_anthy_azik
;;					     anthy-kana-input-method-indication-alist)
		 (lambda (ac)
		   '(ja_azik
		     "��"
		     "AZIK"
		     "AZIK��ĥ���޻����ϥ⡼��"))
		 (lambda (ac)
		   (= (anthy-context-input-rule ac)
		      anthy-input-rule-azik))
		 (lambda (ac)
		   (anthy-prepare-input-rule-activation ac)
                   (require "japanese-azik.scm")
		   (rk-context-set-rule! (anthy-context-rkc ac)
					 ja-azik-rule)
		   (japanese-roma-set-yen-representation)
		   (anthy-context-set-input-rule! ac anthy-input-rule-azik)))

(register-action 'action_anthy_kzik
;;		 (indication-alist-indicator 'action_anthy_kzik
;;					     anthy-kana-input-method-indication-alist)
		 (lambda (ac)
		   '(ja_kzik
		     "��"
		     "KZIK"
		     "KZIK��ĥ���޻����ϥ⡼��"))
		 (lambda (ac)
		   (= (anthy-context-input-rule ac)
		      anthy-input-rule-kzik))
		 (lambda (ac)
		   (anthy-prepare-input-rule-activation ac)
                   (require "japanese-kzik.scm")
		   (rk-context-set-rule! (anthy-context-rkc ac)
					 ja-kzik-rule)
		   (japanese-roma-set-yen-representation)
		   (anthy-context-set-input-rule! ac anthy-input-rule-kzik)))

(register-action 'action_anthy_act
		 (lambda (ac)
		   '(ja_act
		     "��"
		     "ACT"
		     "ACT��ĥ���޻����ϥ⡼��"))
		 (lambda (ac)
		   (= (anthy-context-input-rule ac)
		      anthy-input-rule-act))
		 (lambda (ac)
		   (anthy-prepare-input-rule-activation ac)
                   (require "japanese-act.scm")
		   (rk-context-set-rule! (anthy-context-rkc ac)
					 ja-act-rule)
		   (japanese-roma-set-yen-representation)
		   (anthy-context-set-input-rule! ac anthy-input-rule-act)))


;; Update widget definitions based on action configurations. The
;; procedure is needed for on-the-fly reconfiguration involving the
;; custom API
(define anthy-configure-widgets
  (lambda ()
    (register-widget 'widget_anthy_input_mode
		     (activity-indicator-new anthy-input-mode-actions)
		     (actions-new anthy-input-mode-actions))

    (register-widget 'widget_anthy_kana_input_method
		     (activity-indicator-new anthy-kana-input-method-actions)
		     (actions-new anthy-kana-input-method-actions))
    (context-list-replace-widgets! 'anthy anthy-widgets)))

(define anthy-context-rec-spec
  (append
   context-rec-spec
   (list
    (list 'on                 #f)
    (list 'converting         #f)
    (list 'transposing        #f)
    (list 'predicting         #f)
    (list 'ac-id              #f) ;; anthy-context-id
    (list 'preconv-ustr       #f) ;; preedit strings
    (list 'rkc                #f)
    (list 'segments           #f) ;; ustr of candidate indices
    (list 'candidate-window   #f)
    (list 'candidate-op-count 0)
    (list 'transposing-type   0)
    (list 'prediction-window  #f)
    (list 'prediction-index   #f)
    (list 'kana-mode          anthy-type-hiragana)
    (list 'alnum              #f)
    (list 'alnum-type         anthy-type-halfwidth-alnum)
    (list 'commit-raw         #t)
    (list 'input-rule         anthy-input-rule-roma)
    (list 'raw-ustr           #f))))
(define-record 'anthy-context anthy-context-rec-spec)
(define anthy-context-new-internal anthy-context-new)

(define anthy-context-new
 (lambda (id im)
   (let ((ac (anthy-context-new-internal id im))
	 (rkc (rk-context-new ja-rk-rule #t #f)))
     (if (symbol-bound? 'anthy-lib-init)
         (begin
	   (set! anthy-lib-initialized? (anthy-lib-init))
	   (set! anthy-version (anthy-version->major.minor
				(anthy-lib-get-anthy-version)))))
     (if anthy-lib-initialized?
	 (anthy-context-set-ac-id! ac (anthy-lib-alloc-context)))
     (anthy-context-set-widgets! ac anthy-widgets)
     (anthy-context-set-rkc! ac rkc)
     (anthy-context-set-preconv-ustr! ac (ustr-new '()))
     (anthy-context-set-raw-ustr! ac (ustr-new '()))
     (anthy-context-set-segments! ac (ustr-new '()))
     ac)))

(define anthy-commit-raw
  (lambda (ac)
    (im-commit-raw ac)
    (anthy-context-set-commit-raw! ac #t)))

(define anthy-context-kana-toggle
  (lambda (ac)
    (let* ((kana (anthy-context-kana-mode ac))
	   (opposite-kana (ja-opposite-kana kana)))
      (anthy-context-change-kana-mode! ac opposite-kana))))

(define anthy-context-alkana-toggle
  (lambda (ac)
    (let ((alnum-state (anthy-context-alnum ac)))
      (anthy-context-set-alnum! ac (not alnum-state)))))

(define anthy-context-change-kana-mode!
  (lambda (ac kana-mode)
    (if (= (anthy-context-input-rule ac)
           anthy-input-rule-kana)
        (rk-context-set-rule!
	 (anthy-context-rkc ac)
	 (cond
	  ((= kana-mode anthy-type-hiragana) ja-kana-hiragana-rule)
	  ((= kana-mode anthy-type-katakana) ja-kana-katakana-rule)
	  ((= kana-mode anthy-type-halfkana)  ja-kana-halfkana-rule))))
    (anthy-context-set-kana-mode! ac kana-mode)))

;; TODO: generarize as multi-segment procedure
;; side effect: none. rkc will not be altered
(define anthy-make-whole-string
  (lambda (ac convert-pending-into-kana? kana)
    (let* ((rkc (anthy-context-rkc ac))
	   (pending (rk-pending rkc))
	   (residual-kana (rk-peek-terminal-match rkc))
	   (rule (anthy-context-input-rule ac))
	   (preconv-str (anthy-context-preconv-ustr ac))
	   (extract-kana
	    (if (= rule anthy-input-rule-kana)
		(lambda (entry) (car entry))
		(lambda (entry) (list-ref entry kana)))))

      (if (= rule anthy-input-rule-kana)
	  (ja-make-kana-str
	   (ja-make-kana-str-list
	    (string-to-list
	     (string-append
	      (string-append-map-ustr-former extract-kana preconv-str)
	      (if convert-pending-into-kana?
		  (if residual-kana
                    (if (list? (car residual-kana))
                      (string-append-map extract-kana residual-kana)
		      (extract-kana residual-kana))
                    pending)
		  pending)
	      (string-append-map-ustr-latter extract-kana preconv-str))))
	   kana)
	  (string-append
	   (string-append-map-ustr-former extract-kana preconv-str)
	   (if convert-pending-into-kana?
	       (if residual-kana
                 (if (list? (car residual-kana))
                   (string-append-map extract-kana residual-kana)
		   (extract-kana residual-kana))
                 "")
	       pending)
	   (string-append-map-ustr-latter extract-kana preconv-str))))))

(define anthy-make-raw-string
  (lambda (raw-str-list wide? upper?)
    (if (not (null? raw-str-list))
	(if wide?
	    (string-append
	     (ja-string-list-to-wide-alphabet
	      (if upper?
		  (map
		   (lambda (x)
		     (if (ichar-alphabetic? (string->charcode x))
			 (charcode->string (ichar-upcase (string->charcode x)))
			 x))
		   (string-to-list (car raw-str-list)))
		  (string-to-list (car raw-str-list))))
	     (anthy-make-raw-string (cdr raw-str-list) wide? upper?))
	    (string-append
	     (if upper?
		 (string-list-concat
		  (map
		   (lambda (x)
		     (if (ichar-alphabetic? (string->charcode x))
			 (charcode->string (ichar-upcase (string->charcode x)))
			 x))
		   (string-to-list (car raw-str-list))))
		 (car raw-str-list))
	     (anthy-make-raw-string (cdr raw-str-list) wide? upper?)))
	"")))

(define anthy-make-whole-raw-string
  (lambda (ac wide? upper?)
    (anthy-make-raw-string (anthy-get-raw-str-seq ac) wide? upper?)))

(define anthy-init-handler
  (lambda (id im arg)
    (anthy-context-new id im)))

(define anthy-release-handler
  (lambda (ac)
    (let ((ac-id (anthy-context-ac-id ac)))
      (if ac-id
	  (anthy-lib-free-context ac-id)))))

(define anthy-flush
  (lambda (ac)
    (rk-flush (anthy-context-rkc ac))
    (ustr-clear! (anthy-context-preconv-ustr ac))
    (ustr-clear! (anthy-context-raw-ustr ac))
    (ustr-clear! (anthy-context-segments ac))
    (anthy-context-set-transposing! ac #f)
    (anthy-context-set-converting! ac #f)
    (anthy-context-set-predicting! ac #f)
    (if (or
         (anthy-context-candidate-window ac)
         (anthy-context-prediction-window ac))
	(im-deactivate-candidate-selector ac))
    (anthy-context-set-candidate-window! ac #f)
    (anthy-context-set-prediction-window! ac #f)
    (anthy-context-set-candidate-op-count! ac 0)))

(define anthy-begin-input
  (lambda (ac key key-state)
    (if (cond
	 ((anthy-on-key? key key-state)
	  #t)
	 ((and
	   anthy-use-mode-transition-keys-in-off-mode?
	   (cond
	    ((anthy-hiragana-key? key key-state)
	     (anthy-context-set-kana-mode! ac anthy-type-hiragana)
	     (anthy-context-set-alnum! ac #f)
	     #t)
	    ((anthy-katakana-key? key key-state)
	     (anthy-context-set-kana-mode! ac anthy-type-katakana)
	     (anthy-context-set-alnum! ac #f)
	     #t)
	    ((anthy-halfkana-key? key key-state)
	     (anthy-context-set-kana-mode! ac anthy-type-halfkana)
	     (anthy-context-set-alnum! ac #f)
	     #t)
	    ((anthy-halfwidth-alnum-key? key key-state)
	     (anthy-context-set-alnum-type! ac anthy-type-halfwidth-alnum)
	     (anthy-context-set-alnum! ac #t)
	     #t)
	    ((anthy-fullwidth-alnum-key? key key-state)
	     (anthy-context-set-alnum-type! ac anthy-type-fullwidth-alnum)
	     (anthy-context-set-alnum! ac #t)
	     #t)
	    ((anthy-kana-toggle-key? key key-state)
	     (anthy-context-kana-toggle ac)
	     (anthy-context-set-alnum! ac #f)
	     #t)
	    ((anthy-alkana-toggle-key? key key-state)
	     (anthy-context-alkana-toggle ac)
	     #t)
	    (else
	     #f))))
	 (else
	  #f))
	(begin
	  (anthy-context-set-on! ac #t)
	  (rk-flush (anthy-context-rkc ac))
	  (anthy-context-set-converting! ac #f)
	  #t)
	#f)))

(define anthy-update-preedit
  (lambda (ac)
    (if (not (anthy-context-commit-raw ac))
	(let ((segments (if (anthy-context-on ac)
			    (if (anthy-context-transposing ac)
				(anthy-context-transposing-state-preedit ac)
				(if (anthy-context-converting ac)
				    (anthy-converting-state-preedit ac)
				    (if (anthy-context-predicting ac)
				        (anthy-predicting-state-preedit ac)
				        (anthy-input-state-preedit ac))))
			    ())))
	  (context-update-preedit ac segments))
	(anthy-context-set-commit-raw! ac #f))))
  
(define anthy-proc-raw-state
  (lambda (ac key key-state)
    (if (not (anthy-begin-input ac key key-state))
	(anthy-commit-raw ac))))

(define anthy-begin-conv
  (lambda (ac)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (kana (anthy-context-kana-mode ac))
	   (preconv-str (anthy-make-whole-string ac #t anthy-type-hiragana)))
      (if (and ac-id
	       (> (string-length preconv-str)
		  0))
	  (begin
	    (anthy-lib-set-string ac-id preconv-str)
	    (let ((nr-segments (anthy-lib-get-nr-segments ac-id)))
	      (ustr-set-latter-seq! (anthy-context-segments ac)
				    (make-list nr-segments 0))
	      (anthy-context-set-converting! ac #t)
	      ;; Don't perform rk-flush here. The rkc must be restored when
	      ;; anthy-cancel-conv invoked -- YamaKen 2004-10-25
	      ))))))

(define anthy-cancel-conv
  (lambda (ac)
    (anthy-reset-candidate-window ac)
    (anthy-context-set-converting! ac #f)
    (ustr-clear! (anthy-context-segments ac))))

(define kana-keys?
  (lambda (key)
    (if (not (symbol? key))
	#f
	(cond
	 ((eq? 'kana-lock key)
	  #f)
	 ((eq? 'kana-shift key)
	  #f)
	 (else
	   (let ((name (symbol->string key)))
	     (if (> (string-length name) 5)
		 (let ((keysym-head
			(string-list-concat
		       (list-head (reverse (string-to-list name)) 5))))
		   (if (string=? keysym-head "-anak") ;; reverse
		       #t
		       #f))
		 #f)))))))

(define anthy-non-composing-symbol?
  (lambda (ac key)
    (if (and
	 (symbol? key)
	 (not (kana-keys? key))
	 (not (eq? key 'yen)))
	#t
	#f)))

(define anthy-proc-input-state-no-preedit
  (lambda (ac key key-state)
    (let ((rkc (anthy-context-rkc ac))
	  (direct (ja-direct (charcode->string key)))
	  (rule (anthy-context-input-rule ac)))
      (cond
       ((and anthy-use-with-vi?
             (anthy-vi-escape-key? key key-state))
	(anthy-flush ac)
	(anthy-context-set-on! ac #f)
	(anthy-commit-raw ac))

       ((anthy-off-key? key key-state)
	(anthy-flush ac)
	(anthy-context-set-on! ac #f))

       ((anthy-backspace-key? key key-state)
	(anthy-commit-raw ac))

       ((anthy-delete-key? key key-state)
	(anthy-commit-raw ac))
       
       ((and
         (anthy-hiragana-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-kana-mode ac) anthy-type-hiragana)
	   (not (anthy-context-alnum ac)))))
	(anthy-context-change-kana-mode! ac anthy-type-hiragana)
	(anthy-context-set-alnum! ac #f))

       ((and
         (anthy-katakana-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-kana-mode ac) anthy-type-katakana)
	   (not (anthy-context-alnum ac)))))
	(anthy-context-change-kana-mode! ac anthy-type-katakana)
	(anthy-context-set-alnum! ac #f))

       ((and
         (anthy-halfkana-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-kana-mode ac) anthy-type-halfkana)
	   (not (anthy-context-alnum ac)))))
	(anthy-context-change-kana-mode! ac anthy-type-halfkana)
	(anthy-context-set-alnum! ac #f))

       ((and
         (anthy-halfwidth-alnum-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-alnum-type ac) anthy-type-halfwidth-alnum)
	   (anthy-context-alnum ac))))
	(anthy-context-set-alnum-type! ac anthy-type-halfwidth-alnum)
	(anthy-context-set-alnum! ac #t))

       ((and
         (anthy-fullwidth-alnum-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-alnum-type ac) anthy-type-fullwidth-alnum)
	   (anthy-context-alnum ac))))
	(anthy-context-set-alnum-type! ac anthy-type-fullwidth-alnum)
	(anthy-context-set-alnum! ac #t))

       ((and
	 (not (anthy-context-alnum ac))
	 (anthy-kana-toggle-key? key key-state))
	(anthy-context-kana-toggle ac))

       ((anthy-alkana-toggle-key? key key-state)
	(anthy-context-alkana-toggle ac))

       ;; modifiers (except shift) => ignore
       ((and (modifier-key-mask key-state)
	     (not (shift-key-mask key-state)))
	(anthy-commit-raw ac))
       
       ;; direct key => commit
       (direct
	(im-commit ac direct))

       ;; space key => commit
       ((anthy-space-key? key key-state)
	(if (anthy-context-alnum ac)
	    (im-commit ac (list-ref
			   ja-alnum-space
			   (- (anthy-context-alnum-type ac)
			      anthy-type-halfwidth-alnum)))
	    (im-commit ac (list-ref ja-space (anthy-context-kana-mode ac)))))

       ((anthy-non-composing-symbol? ac key)
	(anthy-commit-raw ac))

       (else
	(if (anthy-context-alnum ac)
	    (let ((key-str (if (symbol? key)
			       (if (symbol-bound? key)
				   (symbol-value key)
				   "?") ;; shouldn't happen
			       (charcode->string key))))
	      (ustr-insert-elem! (anthy-context-preconv-ustr ac)
				 (if (= (anthy-context-alnum-type ac)
					anthy-type-halfwidth-alnum)
				     (list key-str key-str key-str)
				     (list (ja-wide key-str) (ja-wide key-str)
					   (ja-wide key-str))))
	      (ustr-insert-elem! (anthy-context-raw-ustr ac) key-str))
	    (let* ((key-str (if (= rule anthy-input-rule-kana)
	    			(if (symbol? key)
				    (symbol->string key)
				    (charcode->string key))
				(if (symbol? key)
				    (symbol->string key)
				    (charcode->string (ichar-downcase key)))))
		   (res (rk-push-key! rkc key-str)))
	      (if res
		  (begin
		    (if (list? (car res))
		      (ustr-insert-seq! (anthy-context-preconv-ustr ac) res)
		      (ustr-insert-elem! (anthy-context-preconv-ustr ac) res))
		    (ustr-insert-elem! (anthy-context-raw-ustr ac)
				       (if (and (intern-key-symbol key-str)
						(symbol-bound?
						 (string->symbol key-str)))
					   (symbol-value
					    (string->symbol key-str))
					   key-str)))
		  (if (null? (rk-context-seq rkc))
		      (anthy-commit-raw ac))))))))))

(define anthy-has-preedit?
  (lambda (ac)
    (or (not (ustr-empty? (anthy-context-preconv-ustr ac)))
	(> (string-length (rk-pending (anthy-context-rkc ac))) 0))))

(define anthy-rotate-transposing-alnum-type
  (lambda (cur-type state)
    (cond
     ((and
       (= cur-type anthy-type-halfwidth-alnum)
       (= state anthy-type-halfwidth-alnum))
      anthy-candidate-type-upper-halfwidth-alnum)
     ((and
       (= cur-type anthy-type-fullwidth-alnum)
       (= state anthy-type-fullwidth-alnum))
      anthy-candidate-type-upper-fullwidth-alnum)
     (else
      state))))

(define anthy-learn-transposing-text
  (lambda (ac)
    (let ((ac-id (anthy-context-ac-id ac))
          (transposing-type (anthy-context-transposing-type ac))
          (preconv-str (anthy-make-whole-string ac #t anthy-type-hiragana))
          (type #f))
      (define (expand-segment)
        (if (not (= (anthy-lib-get-nr-segments ac-id) 1))
          (begin
            (anthy-lib-resize-segment ac-id 0 1)
            (expand-segment))))
      (cond
       ((= transposing-type anthy-type-hiragana)
        (set! type anthy-candidate-type-hiragana))
       ((= transposing-type anthy-type-katakana)
        (set! type anthy-candidate-type-katakana)))
      (if (and ac-id
               (> (string-length preconv-str) 0)
               type)
        (begin
          (anthy-lib-set-string ac-id preconv-str)
          (expand-segment)
          (anthy-lib-commit-segment ac-id 0 type))))))

(define anthy-proc-transposing-state
  (lambda (ac key key-state)
    (let ((rotate-list '())
	  (state #f))
      (if (anthy-transpose-as-fullwidth-alnum-key? key key-state)
	  (set! rotate-list (cons anthy-type-fullwidth-alnum rotate-list)))
      (if (anthy-transpose-as-halfwidth-alnum-key? key key-state)
	  (set! rotate-list (cons anthy-type-halfwidth-alnum rotate-list)))
      (if (anthy-transpose-as-halfkana-key? key key-state)
	  (set! rotate-list (cons anthy-type-halfkana rotate-list)))
      (if (anthy-transpose-as-katakana-key? key key-state)
	  (set! rotate-list (cons anthy-type-katakana rotate-list)))
      (if (anthy-transpose-as-hiragana-key? key key-state)
	  (set! rotate-list (cons anthy-type-hiragana rotate-list)))

      (if (anthy-context-transposing ac)
	  (let ((lst (member (anthy-context-transposing-type ac) rotate-list)))
	    (if (and lst
		     (not (null? (cdr lst))))
		(set! state (car (cdr lst)))
		(if (not (null? rotate-list))
		    (set! state (anthy-rotate-transposing-alnum-type
				 (anthy-context-transposing-type ac)
				 (car rotate-list))))))
	  (begin
	    (anthy-context-set-transposing! ac #t)
	    (set! state (car rotate-list))))

      (cond
       ((and state
	     (or
	      (= state anthy-type-hiragana)
	      (= state anthy-type-katakana)
	      (= state anthy-type-halfkana)))
	(anthy-context-set-transposing-type! ac state))
       ((and state
	     (or
	      (= state anthy-type-halfwidth-alnum)
	      (= state anthy-candidate-type-upper-halfwidth-alnum)
	      (= state anthy-type-fullwidth-alnum)
	      (= state anthy-candidate-type-upper-fullwidth-alnum)))
	(if (not (= (anthy-context-input-rule ac) anthy-input-rule-kana))
	    (anthy-context-set-transposing-type! ac state)))
       (else
	(and
	 ; commit
	 (if (anthy-commit-key? key key-state)
	     (begin
	       (anthy-learn-transposing-text ac)
	       (im-commit ac (anthy-transposing-text ac))
	       (anthy-flush ac)
	       #f)
	     #t)
	 ; begin-conv
	 (if (anthy-begin-conv-key? key key-state)
	     (begin
	       (anthy-context-set-transposing! ac #f)
	       (anthy-begin-conv ac)
	       #f)
	     #t)
	 ; cancel
	 (if (or
	      (anthy-cancel-key? key key-state)
	      (anthy-backspace-key? key key-state))
	     (begin
	       (anthy-context-set-transposing! ac #f)
	       #f)
	     #t)
	 ; ignore
	 (if (or
	      (anthy-prev-page-key? key key-state)
	      (anthy-next-page-key? key key-state)
	      (anthy-extend-segment-key? key key-state)
	      (anthy-shrink-segment-key? key key-state)
	      (anthy-next-segment-key? key key-state)
	      (anthy-prev-segment-key? key key-state)
	      (anthy-beginning-of-preedit-key? key key-state)
	      (anthy-end-of-preedit-key? key key-state)
	      (anthy-next-candidate-key? key key-state)
	      (anthy-prev-candidate-key? key key-state)
	      (and (modifier-key-mask key-state)
		   (not (shift-key-mask key-state)))
	      (anthy-non-composing-symbol? ac key))
	     #f
	     #t)
	 ; implicit commit
	 (begin
	   (im-commit ac (anthy-transposing-text ac))
	   (anthy-flush ac)
	   (anthy-proc-input-state ac key key-state))))))))

(define anthy-move-prediction
  (lambda (ac offset)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (nr (anthy-lib-get-nr-predictions ac-id))
	   (idx (anthy-context-prediction-index ac))
	   (n (if (not idx)
		  0 
		  (+ idx offset)))
	   (compensated-n (cond
			   ((>= n nr)
			    0)
			   ((< n 0)
			    (- nr 1))
			   (else
			    n))))
      (im-select-candidate ac compensated-n)
      (anthy-context-set-prediction-index! ac compensated-n))))

(define anthy-move-prediction-in-page
  (lambda (ac numeralc)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (nr (anthy-lib-get-nr-predictions ac-id))
	   (p-idx (anthy-context-prediction-index ac))
	   (n (if (not p-idx)
		  0
		  p-idx))
	   (cur-page (if (= anthy-nr-candidate-max 0)
			 0
			 (quotient n anthy-nr-candidate-max)))
	   (pageidx (- (numeric-ichar->integer numeralc) 1))
	   (compensated-pageidx (cond
				 ((< pageidx 0) ; pressing key_0
				  (+ pageidx 10))
				 (else
				  pageidx)))
	   (idx (+ (* cur-page anthy-nr-candidate-max) compensated-pageidx))
	   (compensated-idx (cond
			     ((>= idx nr)
			      #f)
			     (else
			      idx)))
	   (selected-pageidx (if (not p-idx)
				 #f
				 (if (= anthy-nr-candidate-max 0)
				     p-idx
				     (remainder p-idx
						anthy-nr-candidate-max)))))
      (if (and
	   compensated-idx
	   (not (eqv? compensated-pageidx selected-pageidx)))
	  (begin
	    (anthy-context-set-prediction-index! ac compensated-idx)
	    (im-select-candidate ac compensated-idx)
	    #t)
	  #f))))
    
(define anthy-prediction-select-non-existing-index?
  (lambda (ac numeralc)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (nr (anthy-lib-get-nr-predictions ac-id))
	   (p-idx (anthy-context-prediction-index ac))
	   (cur-page (if (= anthy-nr-candidate-max 0)
			 0
			 (quotient p-idx anthy-nr-candidate-max)))
	   (pageidx (- (numeric-ichar->integer numeralc) 1))
	   (compensated-pageidx (cond
				 ((< pageidx 0) ; pressing key_0
				  (+ pageidx 10))
				 (else
				  pageidx)))
	   (idx (+ (* cur-page anthy-nr-candidate-max) compensated-pageidx)))
    (if (>= idx nr)
	#t
	#f))))

(define anthy-prediction-keys-handled?
  (lambda (ac key key-state)
    (cond
     ((anthy-next-prediction-key? key key-state)
      (anthy-move-prediction ac 1)
      #t)
     ((anthy-prev-prediction-key? key key-state)
      (anthy-move-prediction ac -1)
      #t)
     ((and
       anthy-select-prediction-by-numeral-key?
       (ichar-numeric? key))
      (anthy-move-prediction-in-page ac key))
     ((and
       (anthy-context-prediction-index ac)
       (anthy-prev-page-key? key key-state))
      (im-shift-page-candidate ac #f)
      #t)
     ((and
       (anthy-context-prediction-index ac)
       (anthy-next-page-key? key key-state))
      (im-shift-page-candidate ac #t)
      #t)
     (else
      #f))))

(define anthy-proc-prediction-state
  (lambda (ac key key-state)
    (cond
     ;; prediction index change
     ((anthy-prediction-keys-handled? ac key key-state))

     ;; cancel
     ((anthy-cancel-key? key key-state)
      (if (anthy-context-prediction-index ac)
	  (anthy-reset-prediction-window ac)
	  (begin
	    (anthy-reset-prediction-window ac)
	    (anthy-proc-input-state ac key key-state))))

     ;; commit
     ((and
       (anthy-context-prediction-index ac)
       (anthy-commit-key? key key-state))
      (anthy-do-commit-prediction ac))
     (else
      (if (and
	   anthy-use-implicit-commit-prediction?
	   (anthy-context-prediction-index ac))
	  (cond
	    ((or
	      ;; check keys used in anthy-proc-input-state-with-preedit
	      (anthy-begin-conv-key? key key-state)
	      (anthy-backspace-key? key key-state)
	      (anthy-delete-key? key key-state)
	      (anthy-kill-key? key key-state)
	      (anthy-kill-backward-key? key key-state)
	      (and
	       (not (anthy-context-alnum ac))
	       (anthy-commit-as-opposite-kana-key? key key-state))
	      (anthy-transpose-as-hiragana-key? key key-state)
	      (anthy-transpose-as-katakana-key? key key-state)
	      (anthy-transpose-as-halfkana-key? key key-state)
	      (and
	       (not (= (anthy-context-input-rule ac) anthy-input-rule-kana))
	       (or
		(anthy-transpose-as-halfwidth-alnum-key? key key-state)
		(anthy-transpose-as-fullwidth-alnum-key? key key-state)))
	      (anthy-hiragana-key? key key-state)
	      (anthy-katakana-key? key key-state)
	      (anthy-halfkana-key? key key-state)
	      (anthy-halfwidth-alnum-key? key key-state)
	      (anthy-fullwidth-alnum-key? key key-state)
	      (and
	       (not (anthy-context-alnum ac))
	       (anthy-kana-toggle-key? key key-state))
	      (anthy-alkana-toggle-key? key key-state)
	      (anthy-go-left-key? key key-state)
	      (anthy-go-right-key? key key-state)
	      (anthy-beginning-of-preedit-key? key key-state)
	      (anthy-end-of-preedit-key? key key-state)
	      (and
	       (modifier-key-mask key-state)
	       (not (shift-key-mask key-state))))
	     ;; go back to unselected prediction
	     (anthy-reset-prediction-window ac)
	     (anthy-check-prediction ac #f))
	    ((and
	      (ichar-numeric? key)
	      anthy-select-prediction-by-numeral-key?
	      (not (anthy-prediction-select-non-existing-index? ac key)))
	     (anthy-context-set-predicting! ac #f)
	     (anthy-context-set-prediction-index! ac #f)
	     (anthy-proc-input-state ac key key-state))
	    (else
	     ;; implicit commit
	     (anthy-do-commit-prediction ac)
	     (anthy-proc-input-state ac key key-state)))
	  (begin
	    (anthy-context-set-predicting! ac #f)
	    (anthy-context-set-prediction-index! ac #f)
	    (if (not anthy-use-prediction?)
		(anthy-reset-prediction-window ac))
	    (anthy-proc-input-state ac key key-state)))))))

(define anthy-proc-input-state-with-preedit
  (lambda (ac key key-state)
    (define (check-auto-conv str)
      (and
	str
	anthy-auto-start-henkan?
	(string-find japanese-auto-start-henkan-keyword-list str)
	(begin
	  (anthy-reset-prediction-window ac)
	  (anthy-begin-conv ac))))
    (let ((preconv-str (anthy-context-preconv-ustr ac))
	  (raw-str (anthy-context-raw-ustr ac))
	  (rkc (anthy-context-rkc ac))
	  (kana (anthy-context-kana-mode ac))
	  (rule (anthy-context-input-rule ac)))
      (cond

       ;; begin conversion
       ((anthy-begin-conv-key? key key-state)
	(anthy-reset-prediction-window ac)
	(anthy-begin-conv ac))

       ;; prediction 
       ((anthy-next-prediction-key? key key-state)
	(anthy-check-prediction ac #t))

       ;; backspace
       ((anthy-backspace-key? key key-state)
	(if (not (rk-backspace rkc))
            (begin
	      (ustr-cursor-delete-backside! preconv-str)
	      (ustr-cursor-delete-backside! raw-str)
	      ;; fix to valid roma
	      (if (and
		   (= (anthy-context-input-rule ac) anthy-input-rule-roma)
		   (not (null? (ustr-former-seq preconv-str)))
		   (not (ichar-printable?	;; check for kana
			 (string->ichar
			  (car (last (ustr-former-seq preconv-str)))))))
		  (ja-fix-deleted-raw-str-to-valid-roma! raw-str)))))

       ;; delete
       ((anthy-delete-key? key key-state)
	(if (not (rk-delete rkc))
            (begin
	      (ustr-cursor-delete-frontside! preconv-str)
	      (ustr-cursor-delete-frontside! raw-str))))

       ;; kill
       ((anthy-kill-key? key key-state)
	(ustr-clear-latter! preconv-str)
	(ustr-clear-latter! raw-str))
       
       ;; kill-backward
       ((anthy-kill-backward-key? key key-state)
	(rk-flush rkc)
	(ustr-clear-former! preconv-str)
	(ustr-clear-former! raw-str))

       ;; ���ߤȤϵդΤ��ʥ⡼�ɤǤ��ʤ���ꤹ��
       ((and
         (not (anthy-context-alnum ac))
         (anthy-commit-as-opposite-kana-key? key key-state))
	(begin
	  (im-commit
	   ac
	   (anthy-make-whole-string ac #t (ja-opposite-kana kana)))
	  (anthy-flush ac)))

       ;; Transposing���֤ذܹ�
       ((or (anthy-transpose-as-hiragana-key? key key-state)
	    (anthy-transpose-as-katakana-key? key key-state)
	    (anthy-transpose-as-halfkana-key? key key-state)
	    (and
	     (not (= (anthy-context-input-rule ac) anthy-input-rule-kana ))
	     (or
	      (anthy-transpose-as-halfwidth-alnum-key? key key-state)
	      (anthy-transpose-as-fullwidth-alnum-key? key key-state))))
	(anthy-reset-prediction-window ac)
	(anthy-proc-transposing-state ac key key-state))

       ((anthy-hiragana-key? key key-state)
        (if (not (= kana anthy-type-hiragana))
	  (begin
	    (im-commit ac (anthy-make-whole-string ac #t kana))
	    (anthy-flush ac)))
	(anthy-context-set-kana-mode! ac anthy-type-hiragana)
	(anthy-context-set-alnum! ac #f))

       ((anthy-katakana-key? key key-state)
        (if (not (= kana anthy-type-katakana))
	  (begin
	    (im-commit ac (anthy-make-whole-string ac #t kana))
	    (anthy-flush ac)))
	(anthy-context-set-kana-mode! ac anthy-type-katakana)
	(anthy-context-set-alnum! ac #f))

       ((anthy-halfkana-key? key key-state)
        (if (not (= kana anthy-type-halfkana))
	  (begin
	    (im-commit ac (anthy-make-whole-string ac #t kana))
	    (anthy-flush ac)))
	(anthy-context-set-kana-mode! ac anthy-type-halfkana)
	(anthy-context-set-alnum! ac #f))

       ((and
         (anthy-halfwidth-alnum-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-alnum-type ac) anthy-type-halfwidth-alnum)
	   (anthy-context-alnum ac))))
	(anthy-context-set-alnum-type! ac anthy-type-halfwidth-alnum)
	(anthy-context-set-alnum! ac #t))

       ((and
         (anthy-fullwidth-alnum-key? key key-state)
	 (not
	  (and
	   (= (anthy-context-alnum-type ac) anthy-type-fullwidth-alnum)
	   (anthy-context-alnum ac))))
	(anthy-context-set-alnum-type! ac anthy-type-fullwidth-alnum)
	(anthy-context-set-alnum! ac #t))

       ;; Commit current preedit string, then toggle hiragana/katakana mode.
       ((and
	 (not (anthy-context-alnum ac))
	 (anthy-kana-toggle-key? key key-state))
	(begin
	  (im-commit ac (anthy-make-whole-string ac #t kana))
	  (anthy-flush ac)
	  (anthy-context-kana-toggle ac)))

       ((anthy-alkana-toggle-key? key key-state)
	(anthy-context-alkana-toggle ac))

       ;; cancel
       ((anthy-cancel-key? key key-state)
	(anthy-flush ac))

       ;; commit
       ((anthy-commit-key? key key-state)
	(begin
	  (im-commit
	   ac
	   (anthy-make-whole-string ac #t kana))
	  (anthy-flush ac)))

       ;; left
       ;; 2004-08-27 Takuro Ashie <ashie@homa.ne.jp>
       ;;   * We should restore pending state of rk-context when the input-rule
       ;;     is kana mode.
       ((anthy-go-left-key? key key-state)
	(anthy-context-confirm-kana! ac)
	(ustr-cursor-move-backward! preconv-str)
	(ustr-cursor-move-backward! raw-str))

       ;; right
       ;; 2004-08-27 Takuro Ashie <ashie@homa.ne.jp>
       ;;   * We should restore pending state of rk-context when the input-rule
       ;;     is kana mode.
       ((anthy-go-right-key? key key-state)
	(anthy-context-confirm-kana! ac)
	(ustr-cursor-move-forward! preconv-str)
	(ustr-cursor-move-forward! raw-str))

       ;; beginning-of-preedit
       ;; 2004-08-27 Takuro Ashie <ashie@homa.ne.jp>
       ;;   * We should restore pending state of rk-context when the input-rule
       ;;     is kana mode.
       ((anthy-beginning-of-preedit-key? key key-state)
	(anthy-context-confirm-kana! ac)
	(ustr-cursor-move-beginning! preconv-str)
	(ustr-cursor-move-beginning! raw-str))

       ;; end-of-preedit
       ;; 2004-08-27 Takuro Ashie <ashie@homa.ne.jp>
       ;;   * We should restore pending state of rk-context when the input-rule
       ;;     is kana mode.
       ((anthy-end-of-preedit-key? key key-state)
	(anthy-context-confirm-kana! ac)
	(ustr-cursor-move-end! preconv-str)
	(ustr-cursor-move-end! raw-str))

       ;; modifiers (except shift) => ignore
       ((and (modifier-key-mask key-state)
	     (not (shift-key-mask key-state)))
	#f)

       ((anthy-non-composing-symbol? ac key)
	#f)

       (else	
	(if (anthy-context-alnum ac)
	    (let ((key-str (if (symbol? key)
			       (if (symbol-bound? key)
				   (symbol-value key)
				   "?") ;; shouldn't happen
			       (charcode->string key)))
		  (pend (rk-pending rkc))
		  (residual-kana (rk-peek-terminal-match rkc)))
	      (rk-flush rkc) ;; OK to reset rkc here.
	      (if residual-kana
		  (begin
                    (if (list? (car residual-kana))
                      (begin
                        (ustr-insert-seq! preconv-str residual-kana)
                        (ustr-insert-seq! raw-str (reverse
                                                    (string-to-list pend))))
                      (begin
                        (ustr-insert-elem! preconv-str residual-kana)
                        (ustr-insert-elem! raw-str pend)))))
	      (ustr-insert-elem! preconv-str 
				 (if (= (anthy-context-alnum-type ac)
					anthy-type-halfwidth-alnum)
				     (list key-str key-str key-str)
				     (list (ja-wide key-str) (ja-wide key-str)
					   (ja-wide key-str))))
	      (ustr-insert-elem! raw-str key-str)
	      (check-auto-conv key-str))
	    (let* ((key-str (if (= rule anthy-input-rule-kana)
	    			(if (symbol? key)
				    (symbol->string key)
				    (charcode->string key))
				(if (symbol? key)
				    (symbol->string key)
				    (charcode->string (ichar-downcase key)))))
		   (pend (rk-pending rkc))
		   (res (rk-push-key! rkc key-str)))
	      (if (and res
		       (or (list? (car res))
			   (not (string=? (car res) ""))))
		  (let ((next-pend (rk-pending rkc)))
		    (if (list? (car res))
			(ustr-insert-seq!  preconv-str res)
			(ustr-insert-elem! preconv-str res))
		    (if (and next-pend
			     (not (string=? next-pend "")))
                        (ustr-insert-seq! raw-str
                                          (reverse (string-to-list pend)))
			(if (list? (car res))
			    (begin
                              (if (member pend
                                          (map car
                                               ja-consonant-syllable-table))
                                ;; treat consonant having more than one
                                ;; charactear as one raw-str in this case
                                (ustr-insert-elem! raw-str pend)
                                (ustr-insert-seq! raw-str (reverse
                                                            (string-to-list
                                                              pend))))
                              ;; assume key-str as a vowel
			      (ustr-insert-elem!
			       raw-str (if (and (intern-key-symbol key-str)
						(symbol-bound?
						 (string->symbol key-str)))
					   (symbol-value
					    (string->symbol key-str))
					   key-str)))
			    (ustr-insert-elem!
			     raw-str
			     (string-append
			      pend
			      (if (and
				   (intern-key-symbol key-str)
				   (symbol-bound? (string->symbol key-str)))
				  (symbol-value (string->symbol key-str))
				  key-str)))))))
	      (check-auto-conv (if res (car res) #f)))))))))

(define anthy-context-confirm-kana!
  (lambda (ac)
    (if (= (anthy-context-input-rule ac)
	   anthy-input-rule-kana)
	(let* ((preconv-str (anthy-context-preconv-ustr ac))
	       (rkc (anthy-context-rkc ac))
	       (residual-kana (rk-peek-terminal-match rkc)))
	    (if residual-kana
		(begin
                  (if (list? (car residual-kana))
                    (ustr-insert-seq! preconv-str residual-kana)
                    (ustr-insert-elem! preconv-str residual-kana))
		  (rk-flush rkc)))))))

(define anthy-reset-prediction-window
  (lambda (ac)
    (if (anthy-context-prediction-window ac)
        (im-deactivate-candidate-selector ac))
    (anthy-context-set-predicting! ac #f)
    (anthy-context-set-prediction-window! ac #f)
    (anthy-context-set-prediction-index! ac #f)))

(define anthy-check-prediction
  (lambda (ac force-check?)
    (if (and
	 (not (anthy-context-converting ac))
	 (not (anthy-context-transposing ac))
	 (not (anthy-context-predicting ac)))
	(let* ((use-pending-rk-for-prediction? #f)
	       (preconv-str
		(anthy-make-whole-string ac #t (anthy-context-kana-mode ac)))
	       (ac-id (anthy-context-ac-id ac))
	       (preedit-len
		(+
		 (ustr-length (anthy-context-preconv-ustr ac))
		 (if (not use-pending-rk-for-prediction?)
		     0
		     (string-length
		      (rk-pending (anthy-context-rkc ac)))))))
	  (if (or
	       (>= preedit-len anthy-prediction-start-char-count)
	       force-check?)
	      (begin
		(anthy-lib-set-prediction-src-string ac-id preconv-str)
		(let ((nr (anthy-lib-get-nr-predictions ac-id)))
		  (if (and
		       nr
		       (> nr 0))
		      (begin
			(im-activate-candidate-selector
			 ac nr anthy-nr-candidate-max)
			(anthy-context-set-prediction-window! ac #t)
			(anthy-context-set-predicting! ac #t))
		      (anthy-reset-prediction-window ac))))
	      (anthy-reset-prediction-window ac))))))

(define anthy-proc-input-state
  (lambda (ac key key-state)
    (if (anthy-has-preedit? ac)
	(anthy-proc-input-state-with-preedit ac key key-state)
	(anthy-proc-input-state-no-preedit ac key key-state))
    (if (and
	 anthy-use-prediction?
	 (not (anthy-context-predicting ac)))
	(anthy-check-prediction ac #f))))

(define anthy-separator
  (lambda (ac)
    (let ((attr (bitwise-ior preedit-separator
			     preedit-underline)))
      (if anthy-show-segment-separator?
	  (cons attr anthy-segment-separator)
	  #f))))

(define anthy-context-transposing-state-preedit
  (lambda (ac)
    (let ((transposing-text (anthy-transposing-text ac)))
      (list (cons preedit-reverse transposing-text)
	    (cons preedit-cursor "")))))

(define anthy-transposing-text
  (lambda (ac)
    (let* ((transposing-type (anthy-context-transposing-type ac)))
      (cond
       ((or
	 (= transposing-type anthy-type-hiragana)
	 (= transposing-type anthy-type-katakana)
	 (= transposing-type anthy-type-halfkana))
	(anthy-make-whole-string ac #t transposing-type))
       ((= transposing-type anthy-type-halfwidth-alnum)
	(anthy-make-whole-raw-string ac #f #f))
       ((= transposing-type anthy-candidate-type-upper-halfwidth-alnum)
	(anthy-make-whole-raw-string ac #f #t))
       ((= transposing-type anthy-type-fullwidth-alnum)
	(anthy-make-whole-raw-string ac #t #f))
       ((= transposing-type anthy-candidate-type-upper-fullwidth-alnum)
	(anthy-make-whole-raw-string ac #t #t))))))

(define anthy-get-raw-str-seq
  (lambda (ac)
    (let* ((rkc (anthy-context-rkc ac))
	   (pending (rk-pending rkc))
	   (residual-kana (rk-peek-terminal-match rkc))
	   (raw-str (anthy-context-raw-ustr ac))
	   (right-str (ustr-latter-seq raw-str))
	   (left-str (ustr-former-seq raw-str)))
      (append left-str
	      (if residual-kana
                (if (list? (car residual-kana))
		  (reverse (string-to-list pending))
		  (list pending))
		  '())
	      right-str))))

(define anthy-get-raw-candidate
  (lambda (ac ac-id seg-idx cand-idx)
    (let* ((preconv
	    (ja-join-vu (string-to-list
			 (anthy-make-whole-string ac #t anthy-type-hiragana))))
	   (unconv-candidate (anthy-lib-get-unconv-candidate ac-id seg-idx))
	   (unconv (if unconv-candidate
		       (ja-join-vu (string-to-list unconv-candidate))
		       '()))
	   (raw-str (reverse (anthy-get-raw-str-seq ac))))
      (if (not (null? unconv))
	  (if (member (car unconv) preconv)
	      (let ((start (list-seq-contained? preconv unconv))
		    (len (length unconv)))
		(if (and
                      start
                      (= (length raw-str) (length preconv))) ;; sanity check
		    (anthy-make-raw-string
		     (reverse (sublist-rel raw-str start len))
		     (if (or
			  (= cand-idx anthy-candidate-type-halfwidth-alnum)
			  (= cand-idx
			     anthy-candidate-type-upper-halfwidth-alnum))
			 #f
			 #t)
		     (if (or
			  (= cand-idx anthy-candidate-type-halfwidth-alnum)
			  (= cand-idx anthy-candidate-type-fullwidth-alnum))
			 #f
			 #t))
		    "??")) ;; FIXME
	      "???") ;; FIXME
	  "????")))) ;; shouldn't happen

(define anthy-predicting-state-preedit
  (lambda (ac)
    (if (or 
	 (not anthy-use-implicit-commit-prediction?)
	 (not (anthy-context-prediction-index ac)))
        (anthy-input-state-preedit ac)
	(let ((cand (anthy-get-prediction-string ac)))
	  (list (cons (bitwise-ior preedit-reverse preedit-cursor) cand))))))

(define anthy-converting-state-preedit
  (lambda (ac)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (segments (anthy-context-segments ac))
	   (cur-seg (ustr-cursor-pos segments))
	   (separator (anthy-separator ac)))
      (append-map
       (lambda (seg-idx cand-idx)
	 (let* ((attr (if (= seg-idx cur-seg)
			  (bitwise-ior preedit-reverse
				       preedit-cursor)
			  preedit-underline))
		(cand (if (> cand-idx anthy-candidate-type-halfwidth-alnum)
			  (anthy-lib-get-nth-candidate ac-id seg-idx cand-idx)
			  (anthy-get-raw-candidate ac ac-id seg-idx cand-idx)))
		(seg (list (cons attr cand))))
	   (if (and separator
		    (< 0 seg-idx))
	       (cons separator seg)
	       seg)))
       (iota (ustr-length segments))
       (ustr-whole-seq segments)))))

(define anthy-input-state-preedit
  (lambda (ac)
    (let* ((preconv-str (anthy-context-preconv-ustr ac))
	   (rkc (anthy-context-rkc ac))
	   (pending (rk-pending rkc))
	   (kana (anthy-context-kana-mode ac))
	   (rule (anthy-context-input-rule ac))
	   (extract-kana
	    (if (= rule anthy-input-rule-kana)
		(lambda (entry) (car entry))
		(lambda (entry) (list-ref entry kana)))))

      (list
       (and (not (ustr-cursor-at-beginning? preconv-str))
	    (cons preedit-underline
		  (string-append-map-ustr-former extract-kana preconv-str)))
       (and (> (string-length pending) 0)
	    (cons preedit-underline pending))
       (and (anthy-has-preedit? ac)
	    (cons preedit-cursor ""))
       (and (not (ustr-cursor-at-end? preconv-str))
	    (cons
	     preedit-underline
	     (string-append-map-ustr-latter extract-kana preconv-str)))))))

(define anthy-get-commit-string
  (lambda (ac)
    (let ((ac-id (anthy-context-ac-id ac))
	  (segments (anthy-context-segments ac)))
      (string-append-map (lambda (seg-idx cand-idx)
			   (if (> cand-idx
				  anthy-candidate-type-halfwidth-alnum)
			       (anthy-lib-get-nth-candidate
				ac-id seg-idx cand-idx)
			       (anthy-get-raw-candidate
				ac ac-id seg-idx cand-idx)))
			 (iota (ustr-length segments))
			 (ustr-whole-seq segments)))))

(define anthy-commit-string
  (lambda (ac)
    (let ((ac-id (anthy-context-ac-id ac))
	  (segments (anthy-context-segments ac)))
      (for-each (lambda (seg-idx cand-idx)
		  (if (> cand-idx anthy-candidate-type-halfwidth-alnum)
		      (anthy-lib-commit-segment ac-id seg-idx cand-idx)))
		(iota (ustr-length segments))
		(ustr-whole-seq segments)))))

(define anthy-do-commit
  (lambda (ac)
    (im-commit ac (anthy-get-commit-string ac))
    (anthy-commit-string ac)
    (anthy-reset-candidate-window ac)
    (anthy-flush ac)))

(define anthy-get-prediction-string
  (lambda (ac)
    (let ((ac-id (anthy-context-ac-id ac)))
      (anthy-lib-get-nth-prediction
       ac-id (anthy-context-prediction-index ac)))))

(define anthy-learn-prediction-string
  (lambda (ac)
    (let ((ac-id (anthy-context-ac-id ac)))
      (anthy-lib-commit-nth-prediction
       ac-id (anthy-context-prediction-index ac)))))

(define anthy-do-commit-prediction
  (lambda (ac)
    (im-commit ac (anthy-get-prediction-string ac))
    (anthy-learn-prediction-string ac)
    (anthy-reset-prediction-window ac)
    (anthy-flush ac)))

(define anthy-correct-segment-cursor
  (lambda (segments)
    (if (ustr-cursor-at-end? segments)
	(ustr-cursor-move-backward! segments))))

(define anthy-move-segment
  (lambda (ac offset)
    (anthy-reset-candidate-window ac)
    (let ((segments (anthy-context-segments ac)))
      (ustr-cursor-move! segments offset)
      (anthy-correct-segment-cursor segments))))

(define anthy-resize-segment
  (lambda (ac cnt)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (segments (anthy-context-segments ac))
	   (cur-seg (ustr-cursor-pos segments)))
      (anthy-reset-candidate-window ac)
      (anthy-lib-resize-segment ac-id cur-seg cnt)
      (let* ((resized-nseg (anthy-lib-get-nr-segments ac-id))
	     (latter-nseg (- resized-nseg cur-seg)))
	(ustr-set-latter-seq! segments (make-list latter-nseg 0))))))

(define anthy-move-candidate
  (lambda (ac offset)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (segments (anthy-context-segments ac))
	   (cur-seg (ustr-cursor-pos segments))
	   (max (anthy-lib-get-nr-candidates ac-id cur-seg))
	   (n (if (< (ustr-cursor-frontside segments) 0) ;; segment-transposing
		  0
		  (+ (ustr-cursor-frontside segments) offset)))
	   (compensated-n (cond
			   ((>= n max)
			    0)
			   ((< n 0)
			    (- max 1))
			   (else
			    n)))
	   (new-op-count (+ 1 (anthy-context-candidate-op-count ac))))
      (ustr-cursor-set-frontside! segments compensated-n)
      (anthy-context-set-candidate-op-count! ac new-op-count)
      (if (and anthy-use-candidate-window?
	       (= (anthy-context-candidate-op-count ac)
		  anthy-candidate-op-count))
	  (begin
	    (anthy-context-set-candidate-window! ac #t)
	    (im-activate-candidate-selector ac max anthy-nr-candidate-max)))
      (if (anthy-context-candidate-window ac)
	  (im-select-candidate ac compensated-n)))))

(define anthy-move-candidate-in-page
  (lambda (ac numeralc)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (segments (anthy-context-segments ac))
	   (cur-seg (ustr-cursor-pos segments))
	   (max (anthy-lib-get-nr-candidates ac-id cur-seg))
	   (n (ustr-cursor-frontside segments))
	   (cur-page (if (= anthy-nr-candidate-max 0)
	   		 0
			 (quotient n anthy-nr-candidate-max)))
	   (pageidx (- (numeric-ichar->integer numeralc) 1))
	   (compensated-pageidx (cond
				 ((< pageidx 0) ; pressing key_0
				  (+ pageidx 10))
				 (else
				  pageidx)))
	   (idx (+ (* cur-page anthy-nr-candidate-max) compensated-pageidx))
	   (compensated-idx (cond
			     ((>= idx max)
			      (- max 1))
			     (else
			      idx)))
	   (new-op-count (+ 1 (anthy-context-candidate-op-count ac))))
      (ustr-cursor-set-frontside! segments compensated-idx)
      (anthy-context-set-candidate-op-count! ac new-op-count)
      (im-select-candidate ac compensated-idx))))

(define anthy-reset-candidate-window
  (lambda (ac)
    (if (anthy-context-candidate-window ac)
	(begin
	  (im-deactivate-candidate-selector ac)
	  (anthy-context-set-candidate-window! ac #f)))
    (anthy-context-set-candidate-op-count! ac 0)))

(define anthy-rotate-segment-transposing-alnum-type
  (lambda (idx state)
    (cond
     ((and
       (= idx anthy-candidate-type-halfwidth-alnum)
       (= state anthy-candidate-type-halfwidth-alnum))
      anthy-candidate-type-upper-halfwidth-alnum)
     ((and
       (= idx anthy-candidate-type-fullwidth-alnum)
       (= state anthy-candidate-type-fullwidth-alnum))
      anthy-candidate-type-upper-fullwidth-alnum)
     (else
      state))))

(define anthy-set-segment-transposing
  (lambda (ac key key-state)
    (let ((segments (anthy-context-segments ac)))
      (if (and
	   anthy-version
	   (>= (string->number (car anthy-version)) 7802))
	  ;; anthy-7802 and upward
	  (let ((rotate-list '())
		(state #f)
		(idx (ustr-cursor-frontside segments)))
	    (anthy-reset-candidate-window ac)
	    (anthy-context-set-candidate-op-count! ac 0)

	    (if (anthy-transpose-as-fullwidth-alnum-key? key key-state)
		(set! rotate-list (cons anthy-candidate-type-fullwidth-alnum
					rotate-list)))
	    (if (anthy-transpose-as-halfwidth-alnum-key? key key-state)
		(set! rotate-list (cons anthy-candidate-type-halfwidth-alnum
					rotate-list)))
	    (if (anthy-transpose-as-halfkana-key? key key-state)
		(set! rotate-list (cons anthy-candidate-type-halfkana
					rotate-list)))
	    (if (anthy-transpose-as-katakana-key? key key-state)
		(set! rotate-list (cons anthy-candidate-type-katakana
					rotate-list)))
	    (if (anthy-transpose-as-hiragana-key? key key-state)
		(set! rotate-list (cons anthy-candidate-type-hiragana
					rotate-list)))
	    (if (or
		 (= idx anthy-candidate-type-hiragana)
		 (= idx anthy-candidate-type-katakana)
		 (= idx anthy-candidate-type-halfkana)
		 (= idx anthy-candidate-type-halfwidth-alnum)
		 (= idx anthy-candidate-type-fullwidth-alnum)
		 (= idx anthy-candidate-type-upper-halfwidth-alnum)
		 (= idx anthy-candidate-type-upper-fullwidth-alnum))
		(let ((lst (member idx rotate-list)))
		  (if (and lst
			   (not (null? (cdr lst))))
		      (set! state (car (cdr lst)))
		      (set! state (anthy-rotate-segment-transposing-alnum-type
				   idx (car rotate-list)))))
		(set! state (car rotate-list)))
	     (ustr-cursor-set-frontside! segments state))
	  ;; below anthy-7802
	  (begin
	    ;; FIXME: don't cancel conversion
	    (anthy-cancel-conv ac)
	    (anthy-proc-transposing-state ac key key-state))))))

(define anthy-proc-converting-state
  (lambda (ac key key-state)
    (cond
     ((anthy-prev-page-key? key key-state)
      (if (anthy-context-candidate-window ac)
	  (im-shift-page-candidate ac #f)))

     ((anthy-next-page-key? key key-state)
      (if (anthy-context-candidate-window ac)
	  (im-shift-page-candidate ac #t)))

     ((anthy-commit-key? key key-state)
      (anthy-do-commit ac))
     
     ((anthy-extend-segment-key? key key-state)
      (anthy-resize-segment ac 1))
     
     ((anthy-shrink-segment-key? key key-state)
      (anthy-resize-segment ac -1))
     
     ((anthy-next-segment-key? key key-state)
      (anthy-move-segment ac 1))
     
     ((anthy-prev-segment-key? key key-state)
      (anthy-move-segment ac -1))

     ((anthy-beginning-of-preedit-key? key key-state)
      (begin
	(ustr-cursor-move-beginning! (anthy-context-segments ac))
	(anthy-reset-candidate-window ac)))

     ((anthy-end-of-preedit-key? key key-state)
      (begin
	(ustr-cursor-move-end! (anthy-context-segments ac))
	(anthy-correct-segment-cursor (anthy-context-segments ac))
	(anthy-reset-candidate-window ac)))

     ((anthy-backspace-key? key key-state)
      (anthy-cancel-conv ac))

     ((anthy-next-candidate-key? key key-state)
      (anthy-move-candidate ac 1))

     ((anthy-prev-candidate-key? key key-state)
      (anthy-move-candidate ac -1))

     ((or (anthy-transpose-as-hiragana-key? key key-state)
	  (anthy-transpose-as-katakana-key? key key-state)
	  (anthy-transpose-as-halfkana-key? key key-state)
	  (and
	   (not (= (anthy-context-input-rule ac) anthy-input-rule-kana))
	   (or
	    (anthy-transpose-as-halfwidth-alnum-key? key key-state)
	    (anthy-transpose-as-fullwidth-alnum-key? key key-state))))
	(anthy-set-segment-transposing ac key key-state))

     ((anthy-cancel-key? key key-state)
      (anthy-cancel-conv ac))

     ((and anthy-select-candidate-by-numeral-key?
	   (ichar-numeric? key)
	   (anthy-context-candidate-window ac))
      (anthy-move-candidate-in-page ac key))

     ;; don't discard shift-modified keys. Some of them ("?", "~",
     ;; etc) are used to implicit commit. Reported by [Anthy-dev 745]
     ;; -- YamaKen 2004-04-08
     ((and (modifier-key-mask key-state)
	   (not (shift-key-mask key-state)))
      #f)  ;; use #f rather than () to conform to R5RS

     ((anthy-non-composing-symbol? ac key)
      #f)

     (else
      (begin
	(anthy-do-commit ac)
	(anthy-proc-input-state ac key key-state))))))

(define anthy-press-key-handler
  (lambda (ac key key-state)
    (if (ichar-control? key)
	(im-commit-raw ac)
	(if (anthy-context-on ac)
	    (if (anthy-context-transposing ac)
		(anthy-proc-transposing-state ac key key-state)
		(if (anthy-context-converting ac)
		    (anthy-proc-converting-state ac key key-state)
		    (if (anthy-context-predicting ac)
		        (anthy-proc-prediction-state ac key key-state)
		        (anthy-proc-input-state ac key key-state))))
	    (anthy-proc-raw-state ac key key-state)))
    ;; preedit
    (anthy-update-preedit ac)))


(define anthy-release-key-handler
  (lambda (ac key key-state)
    (if (or (ichar-control? key)
	    (not (anthy-context-on ac)))
	;; don't discard key release event for apps
	(anthy-commit-raw ac))))

(define anthy-reset-handler
  (lambda (ac)
    (if (anthy-context-on ac)
	(anthy-flush ac))
    ;; code to commit pending string must not be added to here.
    ;; -- YamaKen 2004-10-21
    ))

(define anthy-get-candidate-handler
  (lambda (ac idx accel-enum-hint)
    (let* ((ac-id (anthy-context-ac-id ac))
	   (cur-seg (ustr-cursor-pos (anthy-context-segments ac)))
	   (cand (if (anthy-context-converting ac)
	             (anthy-lib-get-nth-candidate ac-id cur-seg idx)
	             (anthy-lib-get-nth-prediction ac-id idx))))
      (list cand (digit->string (+ idx 1)) ""))))

(define anthy-set-candidate-index-handler
  (lambda (ac idx)
    (cond
     ((anthy-context-converting ac)
       (ustr-cursor-set-frontside! (anthy-context-segments ac) idx)
       (anthy-update-preedit ac))
     ((anthy-context-predicting ac)
       (anthy-context-set-prediction-index! ac idx)
       (anthy-update-preedit ac)))))

(anthy-configure-widgets)

(register-im
 'anthy
 "ja"
 "EUC-JP"
 anthy-im-name-label
 anthy-im-short-desc
 #f
 anthy-init-handler
 anthy-release-handler
 context-mode-handler
 anthy-press-key-handler
 anthy-release-key-handler
 anthy-reset-handler
 anthy-get-candidate-handler
 anthy-set-candidate-index-handler
 context-prop-activate-handler
 #f
 #f
 #f
 #f
 #f
)
