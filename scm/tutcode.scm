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

;;; tutcode.scm: TUT-Code for Japanese input.
;;;
;;; TUT-Code<http://www.crew.sfc.keio.ac.jp/~chk/>���ϥ�����ץȡ�
;;; TUT-Code��������ܸ�����Ϥ�Ԥ���
;;; TUT-Code�ʳ���T-Code��Try-Code�����Ϥ⡢������ɽ������ˤ���ǽ��
;;;
;;; ����������Ѵ���(ala)
;;;   �Ƶ�Ū����������Ѵ����ǽ�Ǥ���
;;;   ��������Υ��르�ꥺ��ϰʲ���3�Ĥ��������ǽ�Ǥ���
;;;     - tc-2.1+[tcode-ml:1925]
;;;     - ��ľWin YAMANOBE
;;;     - tc-2.3.1-22.6 (����Ū����������Ѵ���Ʊ����������Ѥ���Τǡ�
;;;                      bushu.index2��bushu.expand�ե���������꤬ɬ��)
;;;
;;; * ����Ū����������Ѵ�
;;;   tc-2.3.1��tc-bushu.el�ΰܿ��Ǥ�(������sort�Ǥ��Ǥ��䤹���ι�θ��̤�б�)��
;;;   �ʲ��Τ褦������򤹤�Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;;   (define tutcode-use-interactive-bushu-conversion? #t)
;;;   (define tutcode-bushu-index2-filename "/usr/local/share/tc/bushu.index2")
;;;   (define tutcode-bushu-expand-filename "/usr/local/share/tc/bushu.expand")
;;;   (define tutcode-interactive-bushu-start-sequence "als")
;;;   bushu.index2��bushu.expand�ե�����ϡ�
;;;   tc-2.3.1�Υ��󥹥ȡ���������������󥹥ȡ��뤵���ե�����Ǥ���
;;;
;;; �ڸ򤼽��Ѵ���(alj)
;;;   �򤼽��Ѵ������tc2��Ʊ������(SKK�����Ʊ�ͤη���)�Ǥ���
;;; 
;;; * �򤼽��Ѵ�����(��:/usr/local/share/tc/mazegaki.dic)�ؤΥ���������
;;;   libuim-skk.so�ε�ǽ��ȤäƤ��ޤ���
;;;   ���Τ��ᡢ�ؽ���ǽ��SKK��Ʊ�ͤ�ư��ˤʤ�ޤ�:
;;;     + ���ꤷ������ϼ�����Ѵ�������Ƭ����ޤ���
;;;       tc2��Ʊ�ͤˡ���Ƭ���Ĥθ������Ѥ������ʤ����ϡ�
;;;       tutcode-mazegaki-fixed-priority-count�ˤ��θĿ������ꤷ�Ƥ���������
;;;     + ���ꤷ������ϸĿͼ���(~/.mazegaki.dic)����¸����ޤ���
;;;   �����γؽ���ǽ�򥪥դˤ���ˤϡ�
;;;   tutcode-enable-mazegaki-learning?�ѿ���#f�����ꤷ�Ƥ���������
;;; ** �򤼽��Ѵ�����ؤ���Ͽ�������SKK��Ʊ�ͤ�ư��ˤʤ�ޤ�:
;;;     + ~/.mazegaki.dic�ؤ���Ͽ�������
;;;     + ��Ͽ: �Ѵ�����κǸ�ޤǹԤä���Ƶ�Ū��Ͽ�⡼�ɤ˰ܹԡ�
;;;             ���뤤�ϡ��ɤߤ����ϸ塢|�򲡤���
;;;     + ���: ���񤫤�κ���ϡ��������������������!�򲡤���
;;; 
;;; * ���Ѥ������Ѵ�
;;;   tutcode-mazegaki-enable-inflection?�ѿ���#t�����ꤹ��ȡ����Ѥ��ʤ���
;;;   �Ȥ��Ƥ��Ѵ����䤬���Ĥ���ʤ��ä����ˡ����Ѥ����Ȥ����Ѵ����ߤޤ���
;;;   (�����������Ѥ��ʤ���θ��䤬1�Ĥξ��μ�ư����Ϥ��ʤ��ʤ�ޤ���
;;;    ����ʸ�������Ϥ򳫻Ϥ���г��ꤵ��ޤ���)
;;;   �ޤ����ǽ餫����Ѥ����Ȥ����Ѵ����������ϡ��ɤߤ�"��"���դ��뤫��
;;;   �ʲ��Υ������Ѵ����Ϥ��Ƥ���������
;;;     tutcode-postfix-mazegaki-inflection-start-sequence (���ַ��ѥ�����ή��)
;;;
;;;   ����ɽ����ϡ�<��>�����ˤ�ꡢ�촴(���Ѹ����ʳ�����ʬ)�ο��̤���ǽ�Ǥ���
;;;   (���������ɤߤ����ϻ���"��"���դ��Ƹ촴�����������������)
;;;
;;; * �ɤߤ򥫥����ʤȤ��Ƴ���
;;;   tutcode-katakana-commit-key�˥������ʳ��ꥭ�������ꤹ���
;;;   ���Ѳ�ǽ�ˤʤ�ޤ���
;;;
;;; * �ѻ��Ѵ�(SKK abbrev)�⡼�ɤ��ɲä��Ƥ��ޤ�(al/)��
;;;   �㤨�С���file�פ����Ϥ��ơ֥ե�����פ��Ѵ����뵡ǽ�Ǥ���
;;;
;;; �ڸ��ַ��Ѵ���
;;;   uim��surrounding text�ط���API(text acquisition API)��Ȥäơ�
;;;   ������������ʸ����μ����������Ԥ��ޤ���
;;;   ���Τ��ᡢuim��surrounding text API�򥵥ݡ��Ȥ��Ƥ���֥�å�
;;;   (uim-gtk, uim-qt3, uim-qt4)�ǤΤ߸��ַ��Ѵ�����ǽ�Ǥ���
;;;
;;;   �����ʳ��Υ֥�å��Ǥ���ַ��Ѵ���Ȥ�������硢
;;;   tutcode-enable-fallback-surrounding-text?��#t�����ꤹ��ȡ�
;;;   surrounding text API�����ѤǤ��ʤ����ˡ�
;;;   ʸ����μ����������γ����ʸ����Хåե�����Ԥ���
;;;   ʸ����κ����"\b"(tutcode-fallback-backspace-string)�����Ф��ޤ���
;;;     - \b(BS,0x08)ʸ������������˺����Ԥ����ץ�ǤΤ�ư�
;;;     - �����γ����ʸ����Хåե����䴰�ȷ��Ѥǡ�
;;;       Ĺ����tutcode-completion-chars-max���͡�
;;;
;;; * ���ַ���������Ѵ��ϡ����ϥ�����tutcode-postfix-bushu-start-sequence��
;;;   ���ꤹ��Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;; * ���ַ��򤼽��Ѵ��ϡ��ʲ��γ��ϥ��������ꤹ��Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;;  ���Ѥ��ʤ��� tutcode-postfix-mazegaki-start-sequence
;;;  ���Ѥ����   tutcode-postfix-mazegaki-inflection-start-sequence
;;;  ���Ѥ��ʤ���(�ɤ�1ʸ��) tutcode-postfix-mazegaki-1-start-sequence
;;;   ...
;;;  ���Ѥ��ʤ���(�ɤ�9ʸ��) tutcode-postfix-mazegaki-9-start-sequence
;;;  ���Ѥ����(�ɤ�1ʸ��) tutcode-postfix-mazegaki-inflection-1-start-sequence
;;;   ...
;;;  ���Ѥ����(�ɤ�9ʸ��) tutcode-postfix-mazegaki-inflection-9-start-sequence
;;; * ���ַ��򤼽��Ѵ��ˤ����롢�ɤ�/�촴�ο���
;;;   ����ɽ����ϡ�<��>�����ˤ�ꡢ�ɤ�/�촴�ο��̤���ǽ�Ǥ���
;;;   ���Ѥ����˴ؤ��Ƥϡ��촴��Ĺ����Τ�ͥ�褷���Ѵ����ޤ���
;;;     ��:�֤�������>�֤�����>�֤���
;;;         (tutcode-mazegaki-enable-inflection?��#t�ξ�硢
;;;          ����˽̤��ȳ��Ѥ����Ȥ����Ѵ�)
;;;        >�֤���������>�֤�������>�֤�������>�֤�����>�֤�����>�֤�����
;;;        (�ºݤˤ�tc2��°��mazegaki.dic�ˡ֤��������פ�̵���Τǥ����å�)
;;; ** �ɤߤ�ʸ��������ꤷ���Ѵ����Ϥ������
;;;    ���Ѥ����˴ؤ��Ƥϡ��ɤߤϻ��ꤵ�줿ʸ�����Ǹ��ꤷ�Ƹ촴�Τ߿��̡�
;;;      ��(�֤������פ��Ф���3ʸ������):�֤���������>�֤�������>�֤�����
;;; * ���ַ����������Ѵ��ϡ��ʲ��γ��ϥ��������ꤹ��Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;;  �оݿ��̥⡼��   tutcode-postfix-katakana-start-sequence
;;;    ���������Ѵ��оݤ�ʸ��������򤹤�⡼�ɤ򳫻�(���ַ��򤼽��Ѵ�Ʊ��)��
;;;  �Ҥ餬�ʤ�³���� tutcode-postfix-katakana-0-start-sequence
;;;    �Ҥ餬�ʤ�֡��פ�³�����о�ʸ����Ȥ��ơ��������ʤ��ִ���
;;;  �о�1ʸ��        tutcode-postfix-katakana-1-start-sequence
;;;   ...
;;;  �о�9ʸ��        tutcode-postfix-katakana-9-start-sequence
;;;    ����ʸ�����򥫥����ʤ��ִ���
;;;  1ʸ���������ִ�  tutcode-postfix-katakana-exclude-1-sequence
;;;   ...
;;;  6ʸ���������ִ�  tutcode-postfix-katakana-exclude-6-sequence
;;;    ����ʸ������Ҥ餬�ʤȤ��ƻĤ��ƥ������ʤ��ִ���
;;;    (�������ʤ��Ѵ�����ʸ����Ĺ����ʸ�����������Τ����ݤʾ�����)
;;;    ��:���㤨�Ф��פꤱ��������2ʸ���������ִ������㤨�Х��ץꥱ��������
;;;  1ʸ���̤��      tutcode-postfix-katakana-shrink-1-sequence
;;;   ...
;;;  6ʸ���̤��      tutcode-postfix-katakana-shrink-6-sequence
;;;    ľ���θ��ַ����������Ѵ������ʸ�����̤�ޤ��������֤��¹Բ�ǽ��
;;;    ��:���㤨�Ф��פꤱ�������פҤ餬�ʤ�³�����ִ�
;;;     �����㥨�Х��ץꥱ��������1ʸ���̤��
;;;     �����㤨�Х��ץꥱ��������1ʸ���̤��
;;;     �����㤨�Х��ץꥱ��������
;;; * ���ַ����������ϥ��������Ѵ�
;;;   TUT-Code���󡦥��դΥ⡼���ڤ��ؤ��ʤ��Ǳ�ñ������Ϥ��ơ�
;;;   �夫��ѻ������뤿��ε�ǽ�Ǥ���
;;;   tutcode-keep-illegal-sequence?��#t�����ꤷ����ǡ�
;;;   ��ñ�����ϸ�ˡ�tutcode-verbose-stroke-key(�ǥե���Ȥϥ��ڡ�������)��
;;;   �Ǹ����뤳�Ȥǥ������󥹤�ü������ˡ��ʲ��γ��ϥ��������Ϥ��Ʋ�������
;;;   (�Ѵ���ˡ��Ǹ��tutcode-verbose-stroke-key�ϼ�ư������ޤ�)
;;;   ��:"undo "���Ǹ������"��"��ɽ�����졢�ʲ��γ��ϥ����ǡ�"undo"���Ѵ���
;;;               tutcode-postfix-kanji2seq-start-sequence
;;;     ����1ʸ�� tutcode-postfix-kanji2seq-1-start-sequence
;;;      ...
;;;     ����9ʸ�� tutcode-postfix-kanji2seq-9-start-sequence
;;;   ʸ��������ꤷ�ʤ���硢<��>�����ˤ�ꡢ�����ο��̤���ǽ�Ǥ���
;;;   ʸ��������ꤷ�ʤ���硢��ñ���������˥��ڡ��������Ϥ��Ƥ����ȡ�
;;;   ���ڡ��������ʸ����ѻ����Ѵ����ޤ���
;;;   ���ΤȤ�����ñ��ζ��ڤ�Τ�������Ϥ������ڡ�����ư�������ˤϡ�
;;;   tutcode-delete-leading-delimiter-on-postfix-kanji2seq?��
;;;   #t�����ꤷ�Ƥ���������
;;;   ��:" code "���Ǹ������" ��� "��ɽ�����졢���ϥ����ǡ�"code"���Ѵ���
;;;   �ʤ���ʸ��������ʤ��ξ��Ǥ⡢�������ʤ��Ǳѻ����ִ���������С�
;;;   ~/.uim�˰ʲ��򵭽�(���ϥ�����";0"�ˤ�����):
;;;   (tutcode-rule-set-sequences!
;;;     `((((";" "0"))
;;;         (,(lambda (state pc)
;;;           (tutcode-begin-postfix-kanji2seq-conversion pc 0))))))
;;;   ��:��ñ��������ַ��򤼽��Ѵ����Ϥʤɤε�ǽ���Ф��륷�����󥹤�
;;;      �ޤޤ�Ƥ���ȡ��������뵡ǽ���¹Ԥ���Ƥ��ޤ��ޤ���
;;;      �����Ǥϡ������ε�ǽ���Ф��륷�����󥹤�
;;;      ��ñ����ǤϽи����ʤ��������󥹤��ѹ����뤳�Ȥǲ��򤷤Ƥ���������
;;;      ��:"/local/"���ǤĤ�"����"�θ��"al/"�ˤ�����ַ��ѻ��Ѵ��⡼�ɤ�����
;;;         (�ʤ���"local/"�ξ���"����Ŭ"�ʤΤ�����ʤ�)
;;; * ���ַ����ϥ������󥹢������Ѵ�
;;;   TUT-Code����ˤ�˺���TUT-Code�����Ϥ������˸夫��������Ѵ����뤿���
;;;   ��ǽ�Ǥ���
;;;           tutcode-postfix-seq2kanji-start-sequence
;;;     1ʸ�� tutcode-postfix-seq2kanji-1-start-sequence
;;;      ...
;;;     9ʸ�� tutcode-postfix-seq2kanji-9-start-sequence
;;;   ���ַ��򤼽��Ѵ����ɤ����Ϥʤɡ����ꤵ��Ƥ��ʤ����ϤϾä��ޤ���
;;;   ��:"aljekri"���Ѵ���""��"ekri"�����Ѵ���"����"��
;;;      "aljekri \n"�Τ褦�˳��ꤵ��Ƥ����碪"����"
;;;
;;; ��selection���Ф����Ѵ���
;;;   uim��surrounding text�ط���API(text acquisition API)��Ȥäơ�
;;;   selectionʸ����μ����������Ԥ��ޤ���
;;; * �򤼽��Ѵ�
;;;     ���Ѥ��ʤ���  tutcode-selection-mazegaki-start-sequence
;;;     ���Ѥ����    tutcode-selection-mazegaki-inflection-start-sequence
;;; * ���������Ѵ�    tutcode-selection-katakana-start-sequence
;;; * ���������ϥ��������Ѵ�  tutcode-selection-kanji2seq-start-sequence
;;; * ���ϥ������󥹢������Ѵ�  tutcode-selection-seq2kanji-start-sequence
;;;
;;; �ڥإ�׵�ǽ��
;;; * ���۸���ɽ��(ɽ�����θ��䥦����ɥ���ή��)
;;;   �ư��֤Υ������Ǹ��ˤ�����Ϥ����ʸ����ɽ�����ޤ���
;;;   uim-pref-gtk�Ǥ�ɽ������ɽ�������¾�ˡ�
;;;   <Control>/�ǰ��Ū��ɽ������ɽ�����ڤ��ؤ����ǽ�Ǥ���
;;;   (�Ǥ���������դ��ʸ�������Ϥ���Ȥ�����ɽ����������礬����Τ�)
;;;  - ��*�����դ�ʸ��:�����������Ǹ��ˤ�ꡢ
;;;    ����ʸ����ޤಾ�۸��פ�ɽ������뤳�Ȥ�ɽ���ޤ���(����Ǹ�)
;;;  - ��+�����դ�ʸ��:����������������ʸ��������Ǹ��Ǥ��뤳�Ȥ�ɽ���ޤ���
;;;    (�ϸ쥬���ɤ�����Ǹ�)
;;;  - ��+�׸��դ�ʸ��:�ϸ쥬���ɤκǽ��Ǹ��Ǥ��뤳�Ȥ�ɽ���ޤ���
;;; * ��ư�إ��ɽ����ǽ(ɽ�����θ��䥦����ɥ���ή��)
;;;   �򤼽��Ѵ�����������Ѵ������Ϥ���ʸ�����Ǥ�����ɽ�����ޤ���
;;;   ���������ˡ�Υإ�פϡ�bushu.help�ե����뤬���ꤵ��Ƥ����
;;;   ��ʬõ������ɽ�����ޤ���bushu.help��˸��Ĥ���ʤ����Ǥ⡢
;;;   ��ñ����������˴ؤ��Ƥ�ɽ����ǽ�Ǥ���
;;;   ��:�򤼽��Ѵ��ǡ�ͫݵ�פ���ꤷ�����
;;;    ������������������������������������������������������������
;;;    ��  ��  ��  ��  ��  ��  ��            ��  ��  ��      ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��  ��  ��b ��  ��            ��  ��  ��f     ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��3 ��  ��  ��  ��  ��            ��  ��  ��1(ͫ) ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��d ��  ��e ��  ��2a(ݵ���Ӵ�)��  ��  ��      ��  ��
;;;    ������������������������������������������������������������
;;; * ʸ���إ��ɽ����ǽ(tutcode-help-sequence)
;;;   �����������ľ����ʸ���Υإ��(�Ǥ���)��ɽ�����ޤ���
;;;   (uim��surrounding text API��Ȥäƥ����������ľ����ʸ�������)
;;; * ľ���ɽ������(��ư)�إ�פκ�ɽ��(tutcode-auto-help-redisplay-sequence)
;;; * ľ���ɽ������(��ư)�إ�פΥ����(tutcode-auto-help-dump-sequence)
;;;   ���䥦����ɥ���ɽ�������إ�����Ƥ�ʲ��Τ褦��ʸ����ˤ���commit���ޤ���
;;;   (���������������(��:"�Ӵ�")�򥳥ԡ����ơ���ǥ���åץܡ��ɤ���
;;;    ���ַ���������Ѵ���preedit�إڡ����Ȥ����Ѵ�������������)
;;;       |  |  |  |  ||            |  |  |     |  ||
;;;       |  |  |  | b||            |  |  |  f  |  ||
;;;       | 3|  |  |  ||            |  |  |1(ͫ)|  ||
;;;       |  | d|  | e||2a(ݵ���Ӵ�)|  |  |     |  ||
;;;
;;; ���䴰/ͽ¬���ϡ��ϸ쥬���ɡ�
;;; +���䴰��:�����ʸ������Ф��ơ�³��ʸ����θ����ɽ�����ޤ���
;;; +��ͽ¬���ϡ�:�򤼽��Ѵ����ɤߤ��Ф��ơ��Ѵ���ʸ����θ����ɽ�����ޤ���
;;; +�ֽϸ쥬���ɡ�:�䴰/ͽ¬���ϸ���ʸ������Ȥˡ�
;;;   �������Ϥ�ͽ¬�����ʸ�����Ǹ������ɤ�ɽ�����ޤ�('+'���դ���ɽ��)��
;;; * �䴰/ͽ¬���ϡ��ϸ쥬���ɤȤ���䥦����ɥ���ɽ�����ޤ���
;;; * �䴰/ͽ¬���ϵ�ǽ��Ȥ��ˤϡ�
;;;   uim-pref-gtk���Ρ����ͽ¬���ϡץ��롼�פ����꤬ɬ�פǤ���
;;;     (a)Look-SKK��ͭ���ˤ���mazegaki.dic�����μ���ե��������ꤹ�롣
;;;        (���ͽ¬������)
;;;     (b)Look��ͭ���ˤ���ñ��ե��������ꤹ�롣(�䴰��)
;;;        mazegaki.dic���ɤߤˡ������Ȥ��Ƥ����äƤ��ʤ�ñ����䴰��������硣
;;;        (��:�ֶ��פ����Ϥ��������ǡ��ۡפ��䴰�����ߤ�������
;;;         �ֶ��ۡפ�mazegaki.dic�ˤ��ɤߤȤ��Ƥ����äƤ��ʤ��Τǡ�
;;;         (a)�����Ǥ��䴰����ʤ���((a)���ɤߤ򸡺�����Τ�))
;;;         mazegaki.dic�����Ѵ����ñ���ȴ���Ф��ơ�
;;;         �䴰��ñ��ե��������������ˤϡ��ʲ��Υ��ޥ�ɤǲ�ǽ��
;;;           awk -F'[ /]' '{for(i=3;i<=NF;i++)if(length($i)>2)print $i}' \
;;;           mazegaki.dic | sort -u > mazegaki.words
;;;     (c)Sqlite3��ͭ���ˤ��롣
;;;        �䴰/ͽ¬���Ϥ����򤷤������ؽ���������硢���־�����֡�
;;;   ��ʬõ������Τǡ�(a)(b)�Υե�����ϥ����Ȥ��Ƥ���ɬ�פ�����ޤ���
;;; * �䴰/ͽ¬���Ϥγ��Ϥϰʲ��Τ����줫�Υ����ߥ�:
;;; ** �䴰: tutcode����ξ��֤�tutcode-completion-chars-min��ʸ�������ϻ�
;;; ** �䴰: tutcode����ξ��֤�<Control>.�Ǹ���
;;; ** ͽ¬����: �򤼽��Ѵ����ɤ����Ͼ��֤�
;;;              tutcode-prediction-start-char-count��ʸ�������ϻ�
;;; ** ͽ¬����: �򤼽��Ѵ����ɤ����Ͼ��֤�<Control>.�Ǹ���
;;; * �䴰����ɽ���ˤ����<Control>.���Ǹ�������о�ʸ����1�ĸ��餷�ƺ��䴰��
;;;   Ĺ������ʸ������оݤ��䴰���줿���ˡ��䴰��ľ�����Ǥ���褦�ˡ�
;;; * �嵭���䴰����ʸ����(tutcode-completion-chars-min)��
;;;   ͽ¬����ʸ����(tutcode-prediction-start-char-count)��0�����ꤹ��ȡ�
;;;   <Control>.�Ǹ����ˤΤ��䴰/ͽ¬���ϸ����ɽ�����ޤ���
;;; * �ϸ쥬����(�������Ϥ�ͽ¬�����ʸ�����Ǹ�������)��
;;;   �䴰/ͽ¬���ϸ��䤫���äƤ��ޤ���
;;; * ���۸��׾�Ǥνϸ쥬����ɽ��
;;;   �ϸ쥬���ɤ�ɽ������Ƥ���+�դ�ʸ�����б����륭�������Ϥ�����硢
;;;   2�Ǹ��ܰʹߤⲾ�۸��׾��+�դ���ɽ������Τǡ�
;;;   �����ɤ˽��äƴ��������Ϥ���ǽ�Ǥ���
;;;   �̾�ϲ��۸�����ɽ���ξ��Ǥ⡢+�դ�ʸ�����б����륭�������Ϥ�����硢
;;;   ���Ū�˲��۸��פ�ɽ������ˤϡ�
;;;   tutcode-stroke-help-with-kanji-combination-guide��'full(+�դ��ʳ���
;;;   ʸ����ɽ��)��'guide-only(+�դ���ʸ���Τ�ɽ��)�����ꤷ�Ƥ���������
;;;     ��:�ֲг��פ����Ϥ��褦�Ȥ��ơֲСפ����ϸ�ֳ��פ��Ǥ�����
;;;        ��˺�줷����硢<Control>.�������䴰���ϸ쥬���ɤ�+�դ��Ρֳ��פ�
;;;        ɽ���˽��ä�1,2,3�Ǹ������ϡ�
;;;
;;; * �����Ǹ������Ф餯̵�������䴰/ͽ¬���ϸ����ɽ������ˤϡ�
;;;   ���䥦����ɥ����ٱ�ɽ�����б����Ƥ���С��ʲ�������ǲ�ǽ�Ǥ���
;;;     tutcode-candidate-window-use-delay?��#t�����ꤷ��
;;;     tutcode-candidate-window-activate-delay-for-{completion,prediction}
;;;     ���ͤ�1[��]�ʾ�����ꡣ
;;;
;;; ����������Ѵ�����ͽ¬���ϡ�
;;;   ��������Ѵ�����򸡺����ơ����Ϥ��줿���󤬴ޤޤ����ܤ�ɽ����
;;;
;;; �ڵ������ϥ⡼�ɡ�
;;;   <Control>_�ǵ������ϥ⡼�ɤΥȥ��롣
;;;   ���ѱѿ����ϥ⡼�ɤȤ��Ƥ�Ȥ���褦�ˤ��Ƥ��ޤ���
;;;
;;; ��2���ȥ����������ϥ⡼�ɡ�
;;;   ɴ�기�סؤ��٤�Ʊ�ͤˡ�2�Ǹ��ǳƼ�ε��桦���������Ϥ���⡼�ɡ�
;;;   �����ϴ���Ū��ʸ�������ɽ���¤�Ǥ��ޤ���
;;;   (�̾�ε������ϥ⡼�ɤǤϡ���Ū��ʸ���ޤǤ��ɤ�Ĥ������
;;;   next-page�����򲿲�ⲡ��ɬ�פ����ä����ݤʤΤ�)
;;;
;;; �ڴ������������ϥ⡼�ɡ�
;;;   ���������ɤ���ꤷ��ʸ�������Ϥ���⡼�ɡ��������������ϸ她�ڡ�������
;;;   (tutcode-begin-conv-key)�򲡤��ȡ��б�����ʸ�������ꤵ��ޤ���
;;;   �ʲ���3����η����Ǥ����Ϥ���ǽ(DDSKK 14.2��Ʊ��)��
;;; + Unicode(UCS): U+�θ��16�ʿ���U+�Τ�����u�Ǥ�OK��(��:U+4E85�ޤ���u4e85)
;;;                 (��������uim-tutcode�����������ɤ�EUC-JP(EUC-JIS-2004)�ʤ�
;;;                  �ǡ�JIS X 0213��̵��ʸ��(��:�Ϥ�����U+9AD9)�������Բ�)
;;; + �����ֹ�(JIS X 0213): -�Ƕ��ڤä�����-��-���ֹ�(�̶������줾��10�ʿ�)��
;;;                         1�̤ξ�硢��-�Ͼ�ά��ǽ��(��:1-48-13�ޤ���48-13)
;;; + JIS������(ISO-2022-JP): 4���16�ʿ���(��:502d)
;;;
;;; �ڥҥ��ȥ����ϥ⡼�ɡ�
;;;   �Ƕ����������Ѵ���򤼽��Ѵ����䴰/ͽ¬���ϡ��������ϡ�
;;;   �������������Ϥǳ��ꤷ��ʸ���������Ϥ���⡼�ɡ�
;;;   tutcode-history-size��1�ʾ�����ꤹ���ͭ���ˤʤ�ޤ���
;;;
;;; �ڳ�����ä���
;;;   ľ���γ������ä��ޤ�(tutcode-undo-sequence)��
;;;   �ʲ����Ѵ��Ǥϡ��Ѵ���˳��ꤵ���ʸ������ǧ���뵡��̵����
;;;   �����Ԥ��Τǡ��տޤ��ʤ������˳��ꤵ��뤳�Ȥ�����ޤ���
;;;   ���ξ��ˡ��ǽ餫������Ϥ�ľ�������פ��뤿��ε�ǽ�Ǥ���
;;;   (�����ʸ����������뤿�ᡢuim��surrounding text API��Ȥ��ޤ�)
;;;   + ��������Ѵ�: 2ʸ���ܤ��������Ϥˤ���Ѵ������곫��(�ä˺Ƶ�Ū�ʾ��)
;;;   + ��������������
;;;   + �򤼽��Ѵ�: �������1�Ĥλ��μ�ư����
;;;   + �ɤ����ϻ��Υ������ʳ��ꡢ���������ϥ������󥹳���
;;;
;;; �ڥ���åץܡ��ɡ�
;;;  ����åץܡ������ʸ������Ф���ʲ��ε�ǽ���ɲä��ޤ�����
;;;  (����åץܡ��ɤ����ʸ��������Τ��ᡢuim��surrounding text API�����)
;;;  * ����åץܡ������ʸ������Ф��ƥإ��(�Ǥ���)��ɽ��
;;;    (tutcode-help-clipboard-sequence)
;;;  * ����åץܡ������ʸ�����ʲ���preedit��Ž���դ�(tutcode-paste-key)
;;;   + ������Ͽ��
;;;   + �򤼽��Ѵ����ɤ����ϻ�
;;;   + ��������Ѵ���("������������"�Τ褦����������������󥹤ˤ��б�)
;;;   + ����Ū����������Ѵ���
;;;   + �������������ϻ�
;;;
;;; ���������
;;; * ������ɽ�ΰ������ѹ����������ϡ��㤨��~/.uim�ǰʲ��Τ褦�˵��Ҥ��롣
;;;   (require "tutcode.scm")
;;;   (tutcode-rule-set-sequences!
;;;     '(((("s" " "))("��"))                ; �����������ѹ�
;;;       ((("a" "l" "i"))("Ľ"))            ; �ɲ�
;;;       ((("d" "l" "u"))("��" "��"))       ; �������ʤ�ޤ���
;;;       ((("d" "l" "d" "u"))("��" "��"))))
;;;
;;; * T-Code/Try-Code��Ȥ��������
;;;   uim-pref-gtk�������ꤹ�뤫��~/.uim�ǰʲ��Τ褦�����ꤷ�Ƥ���������
;;;    (define tutcode-rule-filename "/usr/local/share/uim/tcode.scm")
;;;    ;(define tutcode-rule-filename "/usr/local/share/uim/trycode.scm")
;;;    (define tutcode-mazegaki-start-sequence "fj")
;;;    (define tutcode-bushu-start-sequence "jf")
;;;    (define tutcode-latin-conv-start-sequence "47")
;;;    (define tutcode-kana-toggle-key? (make-key-predicate '()))
;;;
;;; �ڥ������ˤĤ��ơ�
;;; generic.scm��١����ˤ��ưʲ����ѹ��򤷤Ƥ��롣
;;;  * ��������������Υ��ڡ�����ͭ���ˤʤ�褦���ѹ���
;;;  * �Ҥ餬��/�������ʥ⡼�ɤ��ڤ��ؤ����ɲá�
;;;  * �򤼽��Ѵ��Ǥ�SKK�����μ����Ȥ��Τǡ�
;;;    skk.scm�Τ��ʴ����Ѵ���������ɬ�פ���ʬ������ߡ�
;;;  * ��������Ѵ���ǽ���ɲá�
;;;  * �������ϥ⡼�ɤ��ɲá�
;;;  * ���۸���ɽ����ǽ���ɲá�
;;;  * ��ư�إ��ɽ����ǽ���ɲá�
;;;  * �䴰/ͽ¬���ϡ��ϸ쥬���ɵ�ǽ���ɲá�
;;; �ڸ��䥦����ɥ����ٱ�ɽ����
;;; �ٱ�ɽ������Ū:�桼�������ϻ��˥إ�פ��䴰�ν�����λ���Ԥ����ˤ���褦�ˡ�
;;;  + ��ư�إ�פκ����˾������֤������뤿�ᡢ��ư�إ�פ�ɽ�������ޤǤδ֤�
;;;    �ʹߤ�ʸ���Υ������Ϥ򤷤Ƥ����Ϥ���ʸ����ɽ������ʤ�������н�
;;;  + ������֥������Ϥ�̵�����Τߥإ��(���۸���)���䴰/ͽ¬���ϸ���ɽ��
;;;    (�¤鷺���Ϥ��Ƥ���֤�;�פʥإ�פ�ɽ�����ʤ�)
;;; �ٱ�ɽ����ή��:
;;; candwin                        tutcode.scm
;;; [ɽ���Τߤ��ٱ䤹����]
;;;                                ����ꥹ�Ȥ������nr,display_limit��׻�
;;;                            <-- im-delay-activate-candidate-selector
;;;  ���������ꤷ���Ԥ�
;;;  ��������λ
;;;                            --> delay-activating-handler
;;;                                nr,display_limit,index���֤�
;;;                            --> get-candidate-handler (������֤�)
;;;  ����ɽ��
;;;
;;; [����ꥹ�Ȥκ������ٱ䤹����]
;;;                            <-- im-delay-activate-candidate-selector
;;;  ���������ꤷ���Ԥ�
;;;  ��������λ
;;;                            --> delay-activating-handler
;;;                                ����ꥹ�Ȥ��������
;;;                                nr,display_limit,index���֤�
;;;                            --> get-candidate-handler (������֤�)
;;;  ����ɽ��
;;;
;;; (��������λ���˥����������ˤ��im-{de,}activate-candidate-selector
;;;  ���ƤФ줿�饿���ޥ���󥻥�)

(require-extension (srfi 1 2 8 69))
(require "generic.scm")
(require "generic-predict.scm")
(require-custom "tutcode-custom.scm")
(require-custom "generic-key-custom.scm")
(require-custom "tutcode-key-custom.scm")
(require-custom "tutcode-rule-custom.scm");uim-pref��ɽ���Τ���(tcode����̵��)
(require-dynlib "skk") ;SKK�����θ򤼽񤭼���θ����Τ���libuim-skk.so�����
(require "tutcode-bushudic.scm") ;��������Ѵ�����
(require "tutcode-kigoudic.scm") ;�������ϥ⡼���Ѥε���ɽ
(require "tutcode-dialog.scm"); �򤼽��Ѵ����񤫤�κ����ǧ��������
(require "tutcode-bushu.scm")
(require "japanese.scm") ; for ja-wide or ja-make-kana-str{,-list}
(require "ustr.scm")

;;; user configs

;; widgets and actions

;; widgets
(define tutcode-widgets '(widget_tutcode_input_mode))

;; default activity for each widgets
(define default-widget_tutcode_input_mode 'action_tutcode_direct)

;; actions of widget_tutcode_input_mode
(define tutcode-input-mode-actions
  (if tutcode-use-kigou2-mode?
    '(action_tutcode_direct
      action_tutcode_hiragana
      action_tutcode_katakana
      action_tutcode_kigou
      action_tutcode_kigou2)
    '(action_tutcode_direct
      action_tutcode_hiragana
      action_tutcode_katakana
      action_tutcode_kigou)))

;;; ���Ѥ��륳����ɽ��
;;; tutcode-context-new����(tutcode-custom-load-rule!)������
(define tutcode-rule ())
;;; 2���ȥ����������ϥ⡼���ѥ�����ɽ
(define tutcode-kigou-rule ())
;;; tutcode-rule����������롢�հ�������(���������Ǹ��ꥹ�Ȥ����)��hash-table
;;; (��ư�إ���Ѥ���������Ѵ����両�����ι�®���Τ���)
(define tutcode-reverse-rule-hash-table ())
;;; tutcode-kigou-rule����������롢�հ���������hash-table��
(define tutcode-reverse-kigou-rule-hash-table ())
;;; tutcode-bushudic����������롢
;;; �հ�������(�������ʸ����������Ѥ�2ʸ�������)��hash-table��
;;; (��ư�إ���Ѥ���������Ѵ����両�����ι�®���ѡ������������������٤�)
(define tutcode-reverse-bushudic-hash-table ())
;;; stroke-help�ǡ����⥭�����Ϥ�̵������ɽ���������Ƥ�alist��
;;; ɽ���������ʤ�����~/.uim��()�����ꤹ�뤫��
;;; tutcode-show-stroke-help-window-on-no-input?��#f�����ꤹ�롣
;;; (���tutcode-rule�����Ƥʤ�ƺ���������٤�����
;;; �ǽ�Υڡ����ϸ������ƤʤΤǡ����ٺ���������Τ�Ȥ���)
(define tutcode-stroke-help-top-page-alist #f)
;;; stroke-help�ǡ����⥭�����Ϥ�̵������ɽ���������Ƥ�alist��
;;; �������ʥ⡼���ѡ�
;;; (XXX:��������ͭ�ξ��⥭��å����Ȥ��褦�ˤ���?
;;;  �⤷��������С�~/.uim�ǲ��۸���ɽ�����ƤΥ������ޥ������ưפˤʤ�)
(define tutcode-stroke-help-top-page-katakana-alist #f)

;;; ������ɽ�����ѹ�/�ɲä��뤿��Υ�����ɽ��
;;; ~/.uim��tutcode-rule-set-sequences!����Ͽ���ơ�
;;; tutcode-context-new����ȿ�Ǥ��롣
(define tutcode-rule-userconfig ())

;;; ���Ǥ������ȿ��
(if (and (symbol-bound? 'tutcode-use-table-style-candidate-window?)
         tutcode-use-table-style-candidate-window?)
  (set! candidate-window-style 'table))
(if (symbol-bound? 'tutcode-commit-candidate-by-label-key?)
  (set! tutcode-commit-candidate-by-label-key
    (if tutcode-commit-candidate-by-label-key?
      'always
      'never)))

;;; ɽ�����θ��䥦����ɥ���γƥܥ���ȥ������б�ɽ(13��8��)��
;;; ɽ�������䥦����ɥ������Ȥ��ƻ��Ѥ��롣
(define uim-candwin-prog-layout ())
;;; ɽ�������䥦����ɥ���Υ����쥤������:QWERTY(JIS)����
(define uim-candwin-prog-layout-qwerty-jis
  '("1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"  "-" "^" "\\"
    "q" "w" "e" "r" "t"  "y" "u" "i" "o" "p"  "@" "[" ""
    "a" "s" "d" "f" "g"  "h" "j" "k" "l" ";"  ":" "]" ""
    "z" "x" "c" "v" "b"  "n" "m" "," "." "/"  ""  ""  " "
    "!" "\"" "#" "$" "%" "&" "'" "(" ")" ""   "=" "~" "|"
    "Q" "W" "E" "R" "T"  "Y" "U" "I" "O" "P"  "`" "{" ""
    "A" "S" "D" "F" "G"  "H" "J" "K" "L" "+"  "*" "}" ""
    "Z" "X" "C" "V" "B"  "N" "M" "<" ">" "?"  "_" ""  ""))
;;; ɽ�������䥦����ɥ���Υ����쥤������:QWERTY(US/ASCII)����
(define uim-candwin-prog-layout-qwerty-us
  '("1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"  "-" "=" "\\"
    "q" "w" "e" "r" "t"  "y" "u" "i" "o" "p"  "[" "]" ""
    "a" "s" "d" "f" "g"  "h" "j" "k" "l" ";"  "'" "`" ""
    "z" "x" "c" "v" "b"  "n" "m" "," "." "/"  ""  ""  " "
    "!" "@" "#" "$" "%"  "^" "&" "*" "(" ")"  "_" "+" "|"
    "Q" "W" "E" "R" "T"  "Y" "U" "I" "O" "P"  "{" "}" ""
    "A" "S" "D" "F" "G"  "H" "J" "K" "L" ":"  "\"" "~" ""
    "Z" "X" "C" "V" "B"  "N" "M" "<" ">" "?"  ""  ""  ""))
;;; ɽ�������䥦����ɥ���Υ����쥤������:DVORAK����
;;; (��������֤����줵�줿��Τ�̵���褦�ʤΤǰ���)
(define uim-candwin-prog-layout-dvorak
  '("1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"  "[" "]" "\\"
    "'" "," "." "p" "y"  "f" "g" "c" "r" "l"  "/" "=" ""
    "a" "o" "e" "u" "i"  "d" "h" "t" "n" "s"  "-" "`" ""
    ";" "q" "j" "k" "x"  "b" "m" "w" "v" "z"  ""  ""  " "
    "!" "@" "#" "$" "%"  "^" "&" "*" "(" ")"  "{" "}" "|"
    "\"" "<" ">" "P" "Y" "F" "G" "C" "R" "L"  "?" "+" ""
    "A" "O" "E" "U" "I"  "D" "H" "T" "N" "S"  "_" "~" ""
    ":" "Q" "J" "K" "X"  "B" "M" "W" "V" "Z"  ""  ""  ""))
;;; ɽ�����θ��䥦����ɥ���γƥܥ���ȥ������б�ɽ�����ꡣ
;;; (~/.uim�Ϥ��θ�Ǽ¹Ԥ����Τǡ�
;;;  ~/.uim���ѹ�����ˤ�uim-candwin-prog-layout���񤭤���ɬ�פ���)
(set! uim-candwin-prog-layout
  (case tutcode-candidate-window-table-layout
    ((qwerty-jis) uim-candwin-prog-layout-qwerty-jis)
    ((qwerty-us) uim-candwin-prog-layout-qwerty-us)
    ((dvorak) uim-candwin-prog-layout-dvorak)
    (else ()))) ; default

;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; QWERTY(JIS)�����ѡ�
(define tutcode-table-heading-label-char-list-qwerty-jis
  '("a" "s" "d" "f" "g" "h" "j" "k" "l" ";"
    "q" "w" "e" "r" "t" "y" "u" "i" "o" "p"
    "z" "x" "c" "v" "b" "n" "m" "," "." "/"
    "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"))
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; QWERTY(US)�����ѡ�
(define tutcode-table-heading-label-char-list-qwerty-us
  tutcode-table-heading-label-char-list-qwerty-jis)
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; DVORAK�����ѡ�
(define tutcode-table-heading-label-char-list-dvorak
  '("a" "o" "e" "u" "i"  "d" "h" "t" "n" "s"
    "'" "," "." "p" "y"  "f" "g" "c" "r" "l"
    ";" "q" "j" "k" "x"  "b" "m" "w" "v" "z"
    "1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"))
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; (�Ǥ��䤹����꤫����˸��������)
(define tutcode-table-heading-label-char-list
  tutcode-table-heading-label-char-list-qwerty-jis)
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(uim����������)
(define tutcode-uim-heading-label-char-list
  '("1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
    "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"
    "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
    "u" "v" "w" "x" "y" "z"
    "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
    "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
    "U" "V" "W" "X" "Y" "Z"))
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��
(define tutcode-heading-label-char-list ())

;;; �������ϥ⡼�ɻ��θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; (�����ܡ��ɥ쥤�����Ȥ˽��äơ����夫�鱦���ؽ�˸��������)
(define tutcode-table-heading-label-char-list-for-kigou-mode
  (if (null? uim-candwin-prog-layout)
    (delete "" uim-candwin-prog-layout-qwerty-jis)
    (delete "" uim-candwin-prog-layout)))
;;; �������ϥ⡼�ɻ��θ��������ѥ�٥�ʸ���Υꥹ��(uim����������)
(define tutcode-uim-heading-label-char-list-for-kigou-mode
  '(" "
    "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
    "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"
    "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
    "u" "v" "w" "x" "y" "z"
    "-" "^" "\\" "@" "[" ";" ":" "]" "," "." "/"
    "!" "\"" "#" "$" "%" "&" "'" "(" ")"
    "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
    "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
    "U" "V" "W" "X" "Y" "Z"
    "=" "~" "|" "`" "{" "+" "*" "}" "<" ">" "?" "_"))
;;; �������ϥ⡼�ɻ��θ��������ѥ�٥�ʸ���Υꥹ��
;;; (���ѱѿ��⡼�ɤȤ��ƻȤ��ˤϡ�tutcode-kigoudic�ȹ�碌��ɬ�פ���)
(define tutcode-heading-label-char-list-for-kigou-mode ())

;;; �ҥ��ȥ����ϻ��θ��������ѥ�٥�ʸ���Υꥹ��
(define tutcode-heading-label-char-list-for-history ())

;;; �䴰/ͽ¬���ϻ��θ��������ѥ�٥�ʸ���Υꥹ�ȡ�
;;; (�̾��ʸ�����Ϥ˱ƶ����ʤ��褦�ˡ�1�Ǹ��ܤȤ��֤�ʤ�ʸ������ѡ�
;;; ����(�����)��ľ�����ϤǤ���褦�ˡ������Ǥϴޤ�ʤ�)
;;; QWERTY(JIS)�����ѡ�TUT-Code�ѡ�
(define tutcode-heading-label-char-list-for-prediction-qwerty
  '(                     "Y" "U" "I" "O" "P"
                         "H" "J" "K" "L"
    "Z" "X" "C" "V" "B"  "N" "M"))
;;; �䴰/ͽ¬���ϻ��θ��������ѥ�٥�ʸ���Υꥹ�ȡ�
;;; DVORAK�����ѡ�TUT-Code�ѡ�
(define tutcode-heading-label-char-list-for-prediction-dvorak
  '(                     "F" "G" "C" "R" "L"
                         "D" "H" "T" "N" "S"
        "Q" "J" "K" "X"  "B" "M" "W" "V" "Z"))
;;; �䴰/ͽ¬���ϻ��θ��������ѥ�٥�ʸ���Υꥹ�ȡ�
(define tutcode-heading-label-char-list-for-prediction
  tutcode-heading-label-char-list-for-prediction-qwerty)

;;; ��ư�إ�פǤ�ʸ�����Ǥ���ɽ���κݤ˸���ʸ����Ȥ��ƻȤ�ʸ���Υꥹ��
(define tutcode-auto-help-cand-str-list
  ;; ��1,2,3�Ǹ��򼨤�ʸ��(����1��, ����2��)
  '((("1" "2" "3") ("4" "5" "6") ("7" "8" "9")) ; 1ʸ������
    (("a" "b" "c") ("d" "e" "f") ("g" "h" "i")) ; 2ʸ������
    (("A" "B" "C") ("D" "E" "F") ("G" "H" "I"))
    (("��" "��" "��") ("��" "��" "ϻ") ("��" "Ȭ" "��"))
    (("��" "��" "��") ("��" "��" "��") ("��" "��" "��"))
    (("��" "��" "��") ("��" "��" "��") ("��" "��" "��"))))

;;; ��ư�إ�׺������־��[s]
(define tutcode-auto-help-time-limit 3)

;;; �ϸ쥬�����ѥޡ���
(define tutcode-guide-mark "+")
;;; �ϸ쥬�����ѽ�λ�ޡ���
(define tutcode-guide-end-mark "+")
;;; ���۸��פΥ��ȥ�������ǡ�
;;; ³�����������Υҥ�ȤȤ���ɽ������������դ���ޡ���
(define tutcode-hint-mark "*")
;;; 2���ȥ����������ϥ⡼�ɻ��˲��۸���ɽ����Ԥ����ɤ���������
(define tutcode-use-stroke-help-window-another? #t)

;;; ���ַ��򤼽��Ѵ����ɤ߼������ˡ��ɤߤ˴ޤ�ʤ�ʸ���Υꥹ��
(define tutcode-postfix-mazegaki-terminate-char-list
  '("\n" "\t" " " "��" "��" "��" "��" "��" "��" "��" "��" "��"))

;;; ���ַ����������Ѵ����оݼ������ˡ�(�Ҥ餬�ʤ˲ä���)�оݤˤ���ʸ���Υꥹ��
(define tutcode-postfix-katakana-char-list '("��"))

;;; ���ַ����������ϥ��������Ѵ����ɤ߼������ˡ��ɤߤ˴ޤ�ʤ�ʸ���Υꥹ�ȡ�
;;; ���ڡ�����ޤ��ñ����Ѵ���ڤˤ�������硢'(":")���ˤ��뤳�Ȥ����ꡣ
;;; ("\n" "\t"���̰�����tutcode-delete-leading-delimiter-on-postfix-kanji2seq?
;;;  ��#t�ξ��Ǥ������ʤ��褦�ˤ��뤿��)
(define tutcode-postfix-kanji2seq-delimiter-char-list '(" "))

;;; surrounding text API���Ȥ��ʤ����ˡ�ʸ������Τ����commit����ʸ����
(define tutcode-fallback-backspace-string "\b")

;;; implementations

;;; �򤼽��Ѵ�����ν����������äƤ��뤫�ɤ���
(define tutcode-dic #f)

;;; list of context
(define tutcode-context-list '())

(define tutcode-prepare-activation
  (lambda (tc)
    (let ((rkc (tutcode-context-rk-context tc)))
      (rk-flush rkc))))

(register-action 'action_tutcode_direct
		 (lambda (tc)
		   '(ja_halfwidth_alnum
		     "a"
		     "ľ������"
		     "ľ�����ϥ⡼��"))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (not (tutcode-context-on? tc))))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (tutcode-flush tc)
                     (tutcode-context-set-state! tc 'tutcode-state-off)
                     (tutcode-update-preedit tc))));flush�ǥ��ꥢ����ɽ����ȿ��

(register-action 'action_tutcode_hiragana
		 (lambda (tc)
		   '(ja_hiragana
		     "��"
		     "�Ҥ餬��"
		     "�Ҥ餬�ʥ⡼��"))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (and (tutcode-context-on? tc)
                          (not (eq? (tutcode-context-state tc)
                                    'tutcode-state-kigou))
                          (not (tutcode-context-katakana-mode? tc))
                          (not (tutcode-kigou2-mode? tc)))))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (or
                         (not (tutcode-context-on? tc)) ; �Ѵ�����֤��ѹ����ʤ�
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-context-set-state! tc 'tutcode-state-on)))
                     (if (tutcode-kigou2-mode? tc)
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-toggle-kigou2-mode tc)))
                     (tutcode-context-set-katakana-mode! tc #f)
                     (tutcode-update-preedit tc))))

(register-action 'action_tutcode_katakana
		 (lambda (tc)
		   '(ja_katakana
		     "��"
		     "��������"
		     "�������ʥ⡼��"))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (and (tutcode-context-on? tc)
                          (not (eq? (tutcode-context-state tc)
                                    'tutcode-state-kigou))
                          (tutcode-context-katakana-mode? tc)
                          (not (tutcode-kigou2-mode? tc)))))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (or
                         (not (tutcode-context-on? tc)) ; �Ѵ�����֤��ѹ����ʤ�
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-context-set-state! tc 'tutcode-state-on)))
                     (if (tutcode-kigou2-mode? tc)
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-toggle-kigou2-mode tc)))
                     (tutcode-context-set-katakana-mode! tc #t)
                     (tutcode-update-preedit tc))))

(register-action 'action_tutcode_kigou
                 (lambda (tc)
                   '(ja_fullwidth_alnum
                     "��"
                     "��������"
                     "�������ϥ⡼��"))
                 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (eq? (tutcode-context-state tc) 'tutcode-state-kigou)))
                 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (not
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (tutcode-flush tc))
                     (tutcode-begin-kigou-mode tc)
                     (tutcode-update-preedit tc))))

(register-action 'action_tutcode_kigou2
                 (lambda (tc)
                   '(ja_fullwidth_alnum
                     "��"
                     "��������2"
                     "�������ϥ⡼��2"))
                 (lambda (c)
                   (let ((tc (tutcode-find-descendant-context c)))
                     (and (tutcode-context-on? tc)
                          (not (eq? (tutcode-context-state tc)
                                    'tutcode-state-kigou))
                          (tutcode-kigou2-mode? tc))))
                 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (or
                         (not (tutcode-context-on? tc)) ; �Ѵ�����֤��ѹ����ʤ�
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-context-set-state! tc 'tutcode-state-on)))
                     (if (not (tutcode-kigou2-mode? tc))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-toggle-kigou2-mode tc)))
                     (tutcode-update-preedit tc))))

;; Update widget definitions based on action configurations. The
;; procedure is needed for on-the-fly reconfiguration involving the
;; custom API
(define tutcode-configure-widgets
  (lambda ()
    (register-widget 'widget_tutcode_input_mode
		     (activity-indicator-new tutcode-input-mode-actions)
		     (actions-new tutcode-input-mode-actions))))

(define tutcode-context-rec-spec
  (append
   context-rec-spec
   (list
     (list 'rk-context ()) ; �������ȥ�������ʸ���ؤ��Ѵ��Τ���Υ���ƥ�����
     (list 'rk-context-another ()) ;�⤦��Ĥ�rk-context(2stroke�������ϥ⡼��)
     ;;; TUT-Code���Ͼ���
     ;;; 'tutcode-state-off TUT-Code����
     ;;; 'tutcode-state-on TUT-Code����
     ;;; 'tutcode-state-yomi �򤼽��Ѵ����ɤ�������
     ;;; 'tutcode-state-code ����������������
     ;;; 'tutcode-state-converting �򤼽��Ѵ��θ���������
     ;;; 'tutcode-state-bushu �������ϡ��Ѵ���
     ;;; 'tutcode-state-interactive-bushu ����Ū��������Ѵ���
     ;;; 'tutcode-state-kigou �������ϥ⡼��
     ;;; 'tutcode-state-history �ҥ��ȥ����ϥ⡼��
     ;;; 'tutcode-state-postfix-katakana ���ַ����������Ѵ���
     ;;; 'tutcode-state-postfix-kanji2seq ���ַ����������ϥ��������Ѵ���
     ;;; 'tutcode-state-postfix-seq2kanji ���ַ����ϥ������󥹢������Ѵ���
     (list 'state 'tutcode-state-off)
     ;;; �������ʥ⡼�ɤ��ɤ���
     ;;; #t: �������ʥ⡼�ɡ�#f: �Ҥ餬�ʥ⡼�ɡ�
     (list 'katakana-mode #f)
     ;;; �򤼽��Ѵ�/��������Ѵ����оݤ�ʸ����ꥹ��(�ս�)
     ;;; (��: �򤼽��Ѵ����ɤߡ֤�����פ����Ϥ�����硢("��" "��" "��"))
     (list 'head ())
     ;;; �򤼽��Ѵ���������θ�����ֹ�
     (list 'nth 0)
     ;;; �򤼽��Ѵ��θ����
     (list 'nr-candidates 0)
     ;;; ���ַ��򤼽��Ѵ����ˡ��Ѵ��˻��Ѥ����ɤߤ�Ĺ����
     ;;; (�������im-delete-text���뤿��˻���)
     ;;; ���ַ�(��)�����ַ�(0)��selection��(��)����Ƚ��ˤ���ѡ�
     (list 'postfix-yomi-len 0)
     ;;; �򤼽��Ѵ����ϻ��˻��ꤵ�줿�ɤߤ�ʸ������
     ;;; ���ַ��ξ������ϺѤߤ��ɤߤ�ʸ������
     (list 'mazegaki-yomi-len-specified 0)
     ;;; �򤼽��Ѵ��Ѥ��ɤ����Ρ����ַ��ξ��ϼ����Ѥߤ��ɤ�
     (list 'mazegaki-yomi-all ())
     ;;; �򤼽��Ѵ����γ��Ѹ���
     ;;; (���Ѥ����ϸ����򡽤��ִ����Ƹ�������Τǡ���������᤹����˻���)
     (list 'mazegaki-suffix ())
     ;;; ���䥦����ɥ��ξ���
     ;;; 'tutcode-candidate-window-off ��ɽ��
     ;;; 'tutcode-candidate-window-converting �򤼽��Ѵ�����ɽ����
     ;;; 'tutcode-candidate-window-kigou ����ɽ����
     ;;; 'tutcode-candidate-window-stroke-help ���۸���ɽ����
     ;;; 'tutcode-candidate-window-auto-help ��ư�إ��ɽ����
     ;;; 'tutcode-candidate-window-predicting �䴰/ͽ¬���ϸ���ɽ����
     ;;; 'tutcode-candidate-window-interactive-bushu ����Ū��������Ѵ�����ɽ��
     ;;; 'tutcode-candidate-window-history �ҥ��ȥ����ϸ���ɽ����
     (list 'candidate-window 'tutcode-candidate-window-off)
     ;;; ���䥦����ɥ����ٱ�ɽ���Ԥ��椫�ɤ���
     (list 'candwin-delay-waiting #f)
     ;;; ���䥦����ɥ����ٱ�ɽ���Ԥ�������򤵤줿����Υ���ǥå����ֹ�
     (list 'candwin-delay-selected-index -1)
     ;;; ����ɽ��������ɽ���Ѥθ���vector(�����Ǥ��ƥڡ����θ���ꥹ��)
     (list 'pseudo-table-cands #f)
     ;;; ���ȥ���ɽ
     ;;; �������Ϥ��륭����ʸ�����б��Ρ�get-candidate-handler�ѷ����ǤΥꥹ��
     (list 'stroke-help ())
     ;;; ��ư�إ��
     (list 'auto-help ())
     ;;; �򤼽��Ѵ�����ؤκƵ�Ū��Ͽ�Τ���λҥ���ƥ�����
     (list 'child-context ())
     ;;; �ҥ���ƥ����Ȥμ���
     ;;; 'tutcode-child-type-editor ��Ͽ�Ѥ��Ѵ���ʸ�����Խ����ǥ���
     ;;; 'tutcode-child-type-dialog ���񤫤�κ����ǧ��������
     ;;; 'tutcode-child-type-seq2kanji �������󥹢������Ѵ���
     (list 'child-type ())
     ;;; �ƥ���ƥ�����
     (list 'parent-context ())
     ;;; ��Ͽ��ʸ�����Խ����ǥ���
     (list 'editor ())
     ;;; �����ǧ��������
     (list 'dialog ())
     ;;; �ѻ��Ѵ�(SKK abbrev)�⡼�ɤ��ɤ���
     (list 'latin-conv #f)
     ;;; commit�Ѥ�ʸ����ꥹ��(�䴰��)
     (list 'commit-strs ())
     ;;; commit-strs�Τ������䴰�˻��Ѥ��Ƥ���ʸ����
     (list 'commit-strs-used-len 0)
     ;;; commit����ʸ���������(�ҥ��ȥ�������)
     (list 'history ())
     ;;; ���ַ��Ѵ��γ����undo���뤿��Υǡ���
     (list 'undo ())
     ;;; �䴰/ͽ¬���Ϥθ��������椫�ɤ���
     ;;; 'tutcode-predicting-off �䴰/ͽ¬���Ϥθ���������Ǥʤ�
     ;;; 'tutcode-predicting-completion �䴰����������
     ;;; 'tutcode-predicting-prediction �򤼽��Ѵ�����ͽ¬���ϸ���������
     ;;; 'tutcode-predicting-bushu ��������Ѵ�����ͽ¬���ϸ���������
     ;;; 'tutcode-predicting-interactive-bushu ����Ū��������Ѵ���
     (list 'predicting 'tutcode-predicting-off)
     ;;; �䴰/ͽ¬�����ѥ���ƥ�����
     (list 'prediction-ctx ())
     ;;; �䴰/ͽ¬���ϸ�����ɤߤΥꥹ��
     (list 'prediction-word ())
     ;;; �䴰/ͽ¬���ϸ���θ���Υꥹ��
     (list 'prediction-candidates ())
     ;;; �䴰/ͽ¬���ϸ����appendix�Υꥹ��
     (list 'prediction-appendix ())
     ;;; �䴰/ͽ¬���ϸ����
     (list 'prediction-nr 0)
     ;;; �䴰/ͽ¬���ϸ���θ������򤵤�Ƥ��륤��ǥå���(�ϸ쥬���ɹ���)
     (list 'prediction-index 0)
     ;;; �䴰/ͽ¬���ϸ����(�ϸ쥬����ʬ�ޤ�)
     (list 'prediction-nr-all 0)
     ;;; �ڡ������Ȥ��䴰/ͽ¬���Ϥθ���ɽ����(�ϸ쥬����ʬ�Ͻ���)
     (list 'prediction-nr-in-page tutcode-nr-candidate-max-for-prediction)
     ;;; �ڡ������Ȥ��䴰/ͽ¬���Ϥθ���ɽ����(�ϸ쥬����ʬ��ޤ�)
     (list 'prediction-page-limit
      (+ tutcode-nr-candidate-max-for-prediction
         tutcode-nr-candidate-max-for-guide))
     ;;; ��������Ѵ���ͽ¬����
     (list 'prediction-bushu ())
     ;;; ��������Ѵ���ͽ¬����θ��ߤ�ɽ���ڡ����κǽ�Υ���ǥå����ֹ�
     (list 'prediction-bushu-page-start 0)
     ;;; �ϸ쥬���ɡ��䴰/ͽ¬���ϻ���ɽ���ѡ�
     ;;; ͽ¬����뼡�����ϴ�������1�Ǹ������ϴ������б��Υꥹ�ȡ�
     ;;; ��: (("," "��") ("u" "��" "��"))
     (list 'guide ())
     ;;; �ϸ쥬���ɺ������ǡ��������۸���(stroke-help)�ؤΥ�����ɽ���ѡ�
     ;;; ʸ���ȥ��ȥ����Υꥹ��(rk-lib-find-partial-seqs�ѷ���)��
     ;;; ��: (((("," "r"))("��")) ((("u" "c"))("��")) ((("u" "v"))("��")))
     (list 'guide-chars ())
     )))
(define-record 'tutcode-context tutcode-context-rec-spec)
(define tutcode-context-new-internal tutcode-context-new)
(define tutcode-context-katakana-mode? tutcode-context-katakana-mode)
(define (tutcode-context-on? pc)
  (not (eq? (tutcode-context-state pc) 'tutcode-state-off)))
(define (tutcode-kigou2-mode? pc)
  (and tutcode-use-kigou2-mode?
       (eq? (rk-context-rule (tutcode-context-rk-context pc))
            tutcode-kigou-rule)))

;;; TUT-Code�Υ���ƥ����Ȥ򿷤����������롣
;;; @return ������������ƥ�����
(define (tutcode-context-new id im)
  (im-set-delay-activating-handler! im tutcode-delay-activating-handler)
  (if (not tutcode-dic)
    (if (not (symbol-bound? 'skk-lib-dic-open))
      (begin
        (if (symbol-bound? 'uim-notify-info)
          (uim-notify-info
            (N_ "libuim-skk.so is not available. Mazegaki conversion is disabled")))
        (set! tutcode-use-recursive-learning? #f)
        (set! tutcode-enable-mazegaki-learning? #f))
      (begin
        (set! tutcode-dic (skk-lib-dic-open tutcode-dic-filename #f "localhost" 0 'unspecified))
        (if tutcode-use-recursive-learning?
          (require "tutcode-editor.scm"))
        (tutcode-read-personal-dictionary))))
  (let ((tc (tutcode-context-new-internal id im)))
    (tutcode-context-set-widgets! tc tutcode-widgets)
    (if (null? tutcode-rule)
      (begin
        (tutcode-custom-load-rule! tutcode-rule-filename)
        (if tutcode-use-dvorak?
          (begin
            (set! tutcode-rule (tutcode-rule-qwerty-to-dvorak tutcode-rule))
            (set! tutcode-heading-label-char-list-for-prediction
              tutcode-heading-label-char-list-for-prediction-dvorak)))
        ;; tutcode-mazegaki/bushu-start-sequence�ϡ�
        ;; tutcode-use-dvorak?������ΤȤ���Dvorak�Υ������󥹤Ȥߤʤ���ȿ�ǡ�
        ;; �Ĥޤꡢrule��qwerty-to-dvorak�Ѵ����ȿ�Ǥ��롣
        (tutcode-custom-set-mazegaki/bushu-start-sequence!)
        (tutcode-rule-commit-sequences! tutcode-rule-userconfig)))
    ;; ɽ�������䥦����ɥ�������
    (if (null? tutcode-heading-label-char-list)
      (if (or (eq? candidate-window-style 'table)
              tutcode-use-pseudo-table-style?)
        (set! tutcode-heading-label-char-list
          (case tutcode-candidate-window-table-layout
            ((qwerty-jis) tutcode-table-heading-label-char-list-qwerty-jis)
            ((qwerty-us) tutcode-table-heading-label-char-list-qwerty-us)
            ((dvorak) tutcode-table-heading-label-char-list-dvorak)
            (else tutcode-table-heading-label-char-list)))
        (set! tutcode-heading-label-char-list
          tutcode-uim-heading-label-char-list)))
    (if (null? tutcode-heading-label-char-list-for-history)
      (set! tutcode-heading-label-char-list-for-history
        tutcode-heading-label-char-list))
    (if (null? tutcode-heading-label-char-list-for-kigou-mode)
      (if (or (eq? candidate-window-style 'table)
              tutcode-use-pseudo-table-style?)
        (begin
          (set! tutcode-heading-label-char-list-for-kigou-mode
            tutcode-table-heading-label-char-list-for-kigou-mode)
          ;; �������ϥ⡼�ɤ����ѱѿ��⡼�ɤȤ��ƻȤ����ᡢ
          ;; tutcode-heading-label-char-list-for-kigou-mode�����Ѥˤ���
          ;; tutcode-kigoudic����Ƭ�������
          (set! tutcode-kigoudic
            (append
              (map (lambda (lst) (list (ja-wide lst)))
                tutcode-heading-label-char-list-for-kigou-mode)
              (list-tail tutcode-kigoudic
                (length tutcode-heading-label-char-list-for-kigou-mode)))))
        (set! tutcode-heading-label-char-list-for-kigou-mode
          tutcode-uim-heading-label-char-list-for-kigou-mode)))
    (tutcode-context-set-rk-context! tc (rk-context-new tutcode-rule #t #f))
    (if tutcode-use-kigou2-mode?
      (begin
        (if (null? tutcode-kigou-rule)
          (begin
            (require "tutcode-kigou-rule.scm") ;2stroke�������ϥ⡼���ѥ�����ɽ
            (tutcode-kigou-rule-translate
              tutcode-candidate-window-table-layout)))
        (tutcode-context-set-rk-context-another!
          tc (rk-context-new tutcode-kigou-rule #t #f))))
    (if tutcode-use-recursive-learning?
      (tutcode-context-set-editor! tc (tutcode-editor-new tc)))
    (tutcode-context-set-dialog! tc (tutcode-dialog-new tc))
    (if (or tutcode-use-completion? tutcode-use-prediction?)
      (begin
        (tutcode-context-set-prediction-ctx! tc (predict-make-meta-search))
        (predict-meta-open (tutcode-context-prediction-ctx tc) "tutcode")
        (predict-meta-set-external-charset! (tutcode-context-prediction-ctx tc) "EUC-JP")))
    tc))

;;; �Ҥ餬��/�������ʥ⡼�ɤ��ڤ��ؤ���Ԥ���
;;; �����ξ��֤��Ҥ餬�ʥ⡼�ɤξ��ϥ������ʥ⡼�ɤ��ڤ��ؤ��롣
;;; �����ξ��֤��������ʥ⡼�ɤξ��ϤҤ餬�ʥ⡼�ɤ��ڤ��ؤ��롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-context-kana-toggle pc)
  (let ((s (tutcode-context-katakana-mode? pc)))
    (tutcode-context-set-katakana-mode! pc (not s))))

;;; ���ä��Υ���ƥ����Ȥ�������롣
(define (tutcode-find-root-context pc)
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (null? ppc)
      pc
      (tutcode-find-root-context ppc))))

;;; ����Υ���ƥ�����(�򤼽��Ѵ��κƵ�Ū��Ͽ�ΰ��ֿ����Ȥ���
;;; =�����Խ���Υ���ƥ�����)��������롣
(define (tutcode-find-descendant-context pc)
  (let ((cpc (tutcode-context-child-context pc)))
    (if (null? cpc)
      pc
      (tutcode-find-descendant-context cpc))))

(define (tutcode-predict pc str)
  (predict-meta-search
   (tutcode-context-prediction-ctx pc)
   str))
;;; �䴰/ͽ¬���ϸ���򸡺�
;;; @param str ����ʸ����
;;; @param completion? �䴰�ξ���#t
;;; @return ��ʣ�����������Ƥ��ɤߤΥꥹ��(�ϸ쥬������)
(define (tutcode-lib-set-prediction-src-string pc str completion?)
  (let* ((ret      (tutcode-predict pc str))
         (word     (predict-meta-word? ret))
         (cands    (predict-meta-candidates? ret))
         (appendix (predict-meta-appendix? ret))
         (word/cand/appendix (map list word cands appendix))
         (uniq-word/cand/appendix 
          ;; ��ʣ��������
          (delete-duplicates word/cand/appendix
            (lambda (x y)
              (let ((xcand (list-ref x 1))
                    (ycand (list-ref y 1)))
                (string=? xcand ycand)))))
         (strlen (string-length str))
         (filtered-word/cand/appendix
          (if completion?
            (filter
              ;; �䴰����str�ǻϤޤäƤ��ʤ���������(str��commit�ѤʤΤ�)
              (lambda (elem)
                (let ((cand (list-ref elem 1)))
                  (and
                    (> (string-length cand) strlen)
                    (string=? str (substring cand 0 strlen)))))
              uniq-word/cand/appendix)
            uniq-word/cand/appendix))
         (filtered-word
          (map (lambda (x) (list-ref x 0)) filtered-word/cand/appendix))
         (filtered-cands
          (map (lambda (x) (list-ref x 1)) filtered-word/cand/appendix))
         (filtered-appendix
          (map (lambda (x) (list-ref x 2)) filtered-word/cand/appendix)))
    (tutcode-context-set-prediction-word! pc filtered-word)
    (tutcode-context-set-prediction-candidates! pc
      (if completion?
        (map
          (lambda (cand)
            ;; �䴰������Ƭ��str����:
            ;; str�ϳ����ʸ����ʤΤǡ�ʸ���ν�ʣ���򤱤뤿�ᡣ
            (if (string=? str (substring cand 0 strlen))
              (substring cand strlen (string-length cand))
              cand))
          filtered-cands)
        filtered-cands))
    (tutcode-context-set-prediction-appendix! pc filtered-appendix)
    (tutcode-context-set-prediction-nr! pc (length filtered-cands))
    word))

;;; ��������Ѵ�����ͽ¬���ϸ��������
;;; @param start-index �����ֹ�
(define (tutcode-lib-set-bushu-prediction pc start-index)
  ;; �����ֹ椫��Ϥޤ�1�ڡ����֤�θ����������Ф��ƻ��ѡ�
  ;; ���ƻ��Ѥ���ȡ��ϸ쥬���ɤΥ�٥�ʸ����Ĺ���ʤäƲ����������ꤹ����
  ;; ������ɥ��˼��ޤ�ʤ��ʤ��礬����Τ�(�����200�ʾ�ξ��ʤ�)��
  ;; (�ϸ쥬���ɤ�ɽ����θ��������������ˡ�⤢�뤬��
  ;; ���ξ�硢�ϸ쥬���ɤο������ڡ������Ȥ��Ѥ�äƤ��ޤ����ᡢ
  ;; �����θ��䥦����ɥ�(�ڡ������Ȥ�ɽ����������Ѥ��ʤ����Ȥ�����)
  ;; �Ǥ�ɽ�������꤬ȯ��)
  (let* ((ret (tutcode-context-prediction-bushu pc))
         (all-len (length ret))
         (start
          (cond
            ((>= start-index all-len)
              (tutcode-context-prediction-bushu-page-start pc))
            ((< start-index 0)
              0)
            (else
              start-index)))
         (end (+ start tutcode-nr-candidate-max-for-prediction))
         (cnt
          (if (< end all-len)
            tutcode-nr-candidate-max-for-prediction
            (- all-len start)))
         (page-word/cand (take (drop ret start) cnt))
         (page-word (map (lambda (elem) (car elem)) page-word/cand))
         (page-cands (map (lambda (elem) (cadr elem)) page-word/cand))
         (len (length page-cands))
         (appendix (make-list len "")))
    (tutcode-context-set-prediction-bushu-page-start! pc start)
    (tutcode-context-set-prediction-word! pc page-word)
    (tutcode-context-set-prediction-candidates! pc page-cands)
    (tutcode-context-set-prediction-appendix! pc appendix)
    (tutcode-context-set-prediction-nr! pc len)))

(define (tutcode-lib-get-nr-predictions pc)
  (tutcode-context-prediction-nr pc))
(define (tutcode-lib-get-nth-word pc nth)
  (let ((word (tutcode-context-prediction-word pc)))
    (list-ref word nth)))
(define (tutcode-lib-get-nth-prediction pc nth)
  (let ((cands (tutcode-context-prediction-candidates pc)))
    (list-ref cands nth)))
(define (tutcode-lib-get-nth-appendix pc nth)
  (let ((appendix (tutcode-context-prediction-appendix pc)))
    (list-ref appendix nth)))
(define (tutcode-lib-commit-nth-prediction pc nth completion?)
  (let ((cand (tutcode-lib-get-nth-prediction pc nth)))
    (predict-meta-commit
      (tutcode-context-prediction-ctx pc)
      (tutcode-lib-get-nth-word pc nth)
      (if completion?
        ;; �䴰���ϡ�cands����ϸ����դ��Ƥ���
        ;; ��Ƭ��commit-strs�������Ƥ���Τǡ�����
        (string-append
          (string-list-concat
            (take (tutcode-context-commit-strs pc)
                  (tutcode-context-commit-strs-used-len pc)))
          cand)
        cand)
      (tutcode-lib-get-nth-appendix pc nth))))

;;; �ϸ쥬����ɽ���Ѹ���ꥹ�Ȥ��䴰/ͽ¬���ϸ��䤫���������
;;; @param str �䴰/ͽ¬���ϸ���θ������˻��Ѥ���ʸ����=���Ϻ�ʸ����
;;; @param completion? �䴰����#t
;;; @param all-yomi ͽ¬���ϸ��両����̤˴ޤޤ�����Ƥ��ɤ�
(define (tutcode-guide-set-candidates pc str completion? all-yomi)
  (let* ((cands (tutcode-context-prediction-candidates pc))
         (rule (rk-context-rule (tutcode-context-rk-context pc)))
         (word all-yomi)
         (strlen (string-length str))
         (filtered-cands
          (if (not completion?)
            (filter
              ;; ͽ¬���ϻ���str�ǻϤޤäƤ��ʤ���������äƤ�Τǽ���
              (lambda (cand)
                (and
                  (> (string-length cand) strlen)
                  (string=? str (substring cand 0 strlen))))
              cands)
            cands))
         ;; �ɤ�������ϡ��ɤ�(word)�⸫�Ƽ�������ǽ���Τ�������򥬥���
         ;; ��:"����"�����Ϥ��������ǡ�look������"������"�Ȥ����ɤߤ��Ȥˡ�
         ;;    "��"�򥬥���
         (filtered-words
          (if completion?
            ()
            (filter
              (lambda (cand)
                (let ((candlen (string-length cand)))
                  (and
                    (> candlen strlen)
                    ;; str�θ�ˡ����Ѥ����򼨤�"��"�����Ĥ�ʤ�����Ͻ���
                    (not (string=?  "��" (substring cand strlen candlen))))))
              word)))
         (trim-str
          (lambda (lst)
            (if (not completion?)
              (map
                (lambda (cand)
                  ;; ͽ¬���ϻ������ϺѤ�str��ޤޤ�Ƥ���Τǡ�
                  ;; ��������ʸ���򥬥���ɽ��
                  (substring cand strlen (string-length cand)))
                lst)
              lst)))
         (trim-cands (trim-str filtered-cands))
         (trim-words (trim-str filtered-words))
         (candchars ; ͽ¬�����ϸ��1ʸ���ܤδ����Υꥹ��
          (delete-duplicates
            (map (lambda (cand) (last (string-to-list cand)))
              (append trim-cands trim-words))))
         (cand-stroke
          (map
            (lambda (elem)
              (list (list (tutcode-reverse-find-seq elem rule)) (list elem)))
            candchars))
         (filtered-cand-stroke
          (filter
            (lambda (elem)
              (pair? (caar elem))) ; ������ɽ��̵�������Ͻ���
            cand-stroke))
         (label-cands-alist
          (tutcode-guide-update-alist () filtered-cand-stroke)))
    (tutcode-context-set-guide! pc label-cands-alist)
    (tutcode-context-set-guide-chars! pc filtered-cand-stroke)))

;;; �ϸ쥬����ɽ���Ѹ���ꥹ�Ȥ��������ͽ¬���ϸ��䤫���������
;;; @param str �������ͽ¬���ϸ���θ������˻��Ѥ�������=���ϺѴ���
(define (tutcode-guide-set-candidates-for-bushu pc)
  (let* ((word (tutcode-context-prediction-word pc))
         (rule (rk-context-rule (tutcode-context-rk-context pc)))
         (cand-stroke
          (map
            (lambda (elem)
              (list (list (tutcode-reverse-find-seq elem rule)) (list elem)))
            word))
         (filtered-cand-stroke
          (filter
            (lambda (elem)
              (pair? (caar elem))) ; ������ɽ��̵�������Ͻ���
            cand-stroke))
         (label-cands-alist
          (tutcode-guide-update-alist () filtered-cand-stroke)))
    (tutcode-context-set-guide! pc label-cands-alist)
    (tutcode-context-set-guide-chars! pc filtered-cand-stroke)))

;;; �ϸ쥬���ɤ�ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦�˥�٥�ʸ���ȴ����Υꥹ�ȡ�
;;; ��: (("," "��") ("u" "��" "��"))
;;; @param label-cands-alist ����alist
;;; @param kanji-list �����ȥ��ȥ����Υꥹ��
;;; ��: (((("," "r"))("��")) ((("u" "c"))("��")) ((("u" "v"))("��")))
;;; @return ������νϸ쥬������alist
(define (tutcode-guide-update-alist label-cands-alist kanji-list)
  (if (null? kanji-list)
    label-cands-alist
    (let*
      ((kanji-stroke (car kanji-list))
       (kanji (caadr kanji-stroke))
       (stroke (caar kanji-stroke)))
      (tutcode-guide-update-alist
        (tutcode-auto-help-update-stroke-alist-with-key label-cands-alist
          kanji (car stroke))
        (cdr kanji-list)))))

;;; �򤼽��Ѵ��ѸĿͼ�����ɤ߹��ࡣ
(define (tutcode-read-personal-dictionary)
  (if (not (setugid?))
      (skk-lib-read-personal-dictionary tutcode-dic tutcode-personal-dic-filename)))

;;; �򤼽��Ѵ��ѸĿͼ����񤭹��ࡣ
;;; @param force? tutcode-enable-mazegaki-learning?��#f�Ǥ�񤭹��फ�ɤ���
(define (tutcode-save-personal-dictionary force?)
  (if (and
        (or force? tutcode-enable-mazegaki-learning?)
        (not (setugid?)))
      (skk-lib-save-personal-dictionary tutcode-dic tutcode-personal-dic-filename)))

;;; �������ȥ�������ʸ���ؤ��Ѵ��Τ����rk-push-key!��ƤӽФ���
;;; ����ͤ�#f�Ǥʤ���С������(�ꥹ��)��car���֤���
;;; ���������������ʥ⡼�ɤξ�������ͥꥹ�Ȥ�cadr���֤���
;;; (rk-push-key!�ϥ��ȥ�������ξ���#f���֤�)
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ������ʸ����
(define (tutcode-push-key! pc key)
  (let ((res (rk-push-key! (tutcode-context-rk-context pc) key)))
    (and res
      (begin
        (tutcode-context-set-guide-chars! pc ())
        (if
          (and
            (not (null? (cdr res)))
            (tutcode-context-katakana-mode? pc))
          (cadr res)
          (car res))))))

;;; �Ѵ�����֤򥯥ꥢ���롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-flush pc)
  (let ((cpc (tutcode-context-child-context pc)))
    (rk-flush (tutcode-context-rk-context pc))
    (if tutcode-use-recursive-learning?
      (tutcode-editor-flush (tutcode-context-editor pc)))
    (tutcode-dialog-flush (tutcode-context-dialog pc))
    (if (tutcode-context-on? pc) ; ���ջ��˸ƤФ줿���ϥ���ˤ���������
      (tutcode-context-set-state! pc 'tutcode-state-on)) ; �Ѵ����֤򥯥ꥢ����
    (tutcode-context-set-head! pc ())
    (tutcode-context-set-nr-candidates! pc 0)
    (tutcode-context-set-postfix-yomi-len! pc 0)
    (tutcode-context-set-mazegaki-yomi-len-specified! pc 0)
    (tutcode-context-set-mazegaki-yomi-all! pc ())
    (tutcode-context-set-mazegaki-suffix! pc ())
    (tutcode-reset-candidate-window pc)
    (tutcode-context-set-latin-conv! pc #f)
    (tutcode-context-set-guide-chars! pc ())
    (tutcode-context-set-child-context! pc ())
    (tutcode-context-set-child-type! pc ())
    (if (not (null? cpc))
      (tutcode-flush cpc))))

;;; �򤼽��Ѵ����n���ܤθ�����֤���
;;; @param pc ����ƥ����ȥꥹ��
;;; @param n �оݤθ����ֹ�
(define (tutcode-get-nth-candidate pc n)
  (let* ((head (tutcode-context-head pc))
         (cand (skk-lib-get-nth-candidate
                tutcode-dic
                n
                (cons (string-list-concat head) "")
                ""
                #f)))
    cand))

;;; �������ϥ⡼�ɻ���n���ܤθ�����֤���
;;; @param n �оݤθ����ֹ�
(define (tutcode-get-nth-candidate-for-kigou-mode pc n)
 (car (nth n tutcode-kigoudic)))

;;; �ҥ��ȥ����ϥ⡼�ɻ���n���ܤθ�����֤���
;;; @param n �оݤθ����ֹ�
(define (tutcode-get-nth-candidate-for-history pc n)
  (list-ref (tutcode-context-history pc) n))

;;; �򤼽��Ѵ���θ���������θ�����֤���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-get-current-candidate pc)
  (tutcode-get-nth-candidate pc (tutcode-context-nth pc)))

;;; �������ϥ⡼�ɻ��θ���������θ�����֤���
(define (tutcode-get-current-candidate-for-kigou-mode pc)
  (tutcode-get-nth-candidate-for-kigou-mode pc (tutcode-context-nth pc)))

;;; �ҥ��ȥ����ϥ⡼�ɻ��θ���������θ�����֤���
(define (tutcode-get-current-candidate-for-history pc)
  (tutcode-get-nth-candidate-for-history pc (tutcode-context-nth pc)))

;;; �򤼽��Ѵ��ǳ��ꤷ��ʸ������֤���
;;; @param pc ����ƥ����ȥꥹ��
;;; @return ���ꤷ��ʸ����
(define (tutcode-prepare-commit-string pc)
  (let ((res (tutcode-get-current-candidate pc))
        (suffix (tutcode-context-mazegaki-suffix pc))
        (nth (tutcode-context-nth pc)))
    ;; ���Ĥ�����Υ�٥륭��������θ������ꤹ��Ȥ������Ǥ���褦�ˡ�
    ;; tutcode-enable-mazegaki-learning?��#f�ξ��ϸ�����¤ӽ���Ѥ��ʤ���
    ;; (��:�֤����פ��Ѵ��ˤ����ơ����d�����ǡֲ��ס�e�����ǡֲ��פ����)
    (if (and tutcode-enable-mazegaki-learning?
             (> nth tutcode-mazegaki-fixed-priority-count))
      (let ((head-and-okuri-head
              (cons (string-list-concat (tutcode-context-head pc)) "")))
        ;; skk-lib-commit-candidate��Ƥ֤ȳؽ����Ԥ�졢����礬�ѹ������
        (skk-lib-commit-candidate tutcode-dic head-and-okuri-head "" nth #f)
        ;; ��Ƭ���Ĥθ�������Τ��ᡢ���ԤθƽФ���Ƭ�ˤʤä�����򲡤�������
        (do
          ((i tutcode-mazegaki-fixed-priority-count (- i 1)))
          ((<= i 0))
          (skk-lib-commit-candidate tutcode-dic head-and-okuri-head ""
            tutcode-mazegaki-fixed-priority-count #f))
        (tutcode-save-personal-dictionary #f)))
    (tutcode-flush pc)
    (if (null? suffix)
      res
      (string-append res (string-list-concat suffix)))))

;;; �������ϥ⡼�ɻ��˳��ꤷ��ʸ������֤���
(define (tutcode-prepare-commit-string-for-kigou-mode pc)
  (tutcode-get-current-candidate-for-kigou-mode pc))

;;; �ҥ��ȥ����ϥ⡼�ɻ��˳��ꤷ��ʸ������֤���
(define (tutcode-prepare-commit-string-for-history pc)
  (tutcode-get-current-candidate-for-history pc))

;;; im-commit-raw��ƤӽФ���
;;; ���������ҥ���ƥ����Ȥξ��ϡ�editor��dialog�����ϥ������Ϥ���
(define (tutcode-commit-raw pc key key-state)
  (tutcode-context-set-undo! pc ())
  (if (or tutcode-use-completion? tutcode-enable-fallback-surrounding-text?)
    (tutcode-append-commit-string pc (im-get-raw-key-str key key-state)))
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (case (tutcode-context-child-type ppc)
        ((tutcode-child-type-editor)
          (tutcode-editor-commit-raw (tutcode-context-editor ppc) key key-state))
        ((tutcode-child-type-dialog)
          (tutcode-dialog-commit-raw (tutcode-context-dialog ppc) key key-state))
        ((tutcode-child-type-seq2kanji)
          (tutcode-seq2kanji-commit-raw-from-child ppc key key-state)))
      (im-commit-raw pc))))

;;; im-commit��ƤӽФ���
;;; ���������ҥ���ƥ����Ȥξ��ϡ�editor��dialog�����ϥ������Ϥ���
;;; @param str ���ߥåȤ���ʸ����
;;; @param opts ���ץ���������
;;;  opt-skip-append-commit-strs? commit-strs�ؤ��ɲä�
;;;  �����åפ��뤫�ɤ�����̤�������#f��
;;;  opt-skip-append-history? history�ؤ��ɲä�
;;;  �����åפ��뤫�ɤ�����̤�������#f��
(define (tutcode-commit pc str . opts)
  (tutcode-context-set-undo! pc ())
  (let-optionals* opts ((opt-skip-append-commit-strs? #f)
                        (opt-skip-append-history? #f))
    (if (and
          (or tutcode-use-completion? tutcode-enable-fallback-surrounding-text?)
          (not opt-skip-append-commit-strs?))
      (tutcode-append-commit-string pc str))
    (if (and (> tutcode-history-size 0)
             (not opt-skip-append-history?))
      (tutcode-append-history pc str)))
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (case (tutcode-context-child-type ppc)
        ((tutcode-child-type-editor)
          (tutcode-editor-commit (tutcode-context-editor ppc) str))
        ((tutcode-child-type-dialog)
          (tutcode-dialog-commit (tutcode-context-dialog ppc) str))
        ((tutcode-child-type-seq2kanji)
          (tutcode-seq2kanji-commit-from-child ppc str)))
      (im-commit pc str))))

;;; im-commit��ƤӽФ��ȤȤ�ˡ���ư�إ��ɽ���Υ����å���Ԥ�
(define (tutcode-commit-with-auto-help pc)
  (let* ((head (tutcode-context-head pc))
         (yomi-len (tutcode-context-postfix-yomi-len pc))
         (yomi (and (not (zero? yomi-len))
                    (take (tutcode-context-mazegaki-yomi-all pc)
                          (abs yomi-len))))
         (suffix (tutcode-context-mazegaki-suffix pc))
         (state (tutcode-context-state pc))
         ;; ����1�ĤǼ�ư���ꤵ�줿�������տޤ�����ΤǤʤ��ä�����undo������
         ;; (�ɤ����Ͼ��֤�Ƹ�������������֤ǤϤʤ���������θ����ֹ������)
         (undo-data (and (eq? state 'tutcode-state-converting)
                         (list head (tutcode-context-latin-conv pc))))
         (res (tutcode-prepare-commit-string pc))) ; flush�ˤ��head�������ꥢ
    (cond
      ((= yomi-len 0)
        (tutcode-commit pc res)
        (if undo-data
          (tutcode-undo-prepare pc state res undo-data)))
      ((> yomi-len 0)
        (tutcode-postfix-commit pc res yomi))
      (else
        (tutcode-selection-commit pc res yomi)))
    (tutcode-check-auto-help-window-begin pc
      (drop (string-to-list res) (length suffix))
      (append suffix head))))

;;; �򤼽��Ѵ��θ���������ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
;;; @param ch ���Ϥ��줿��٥�ʸ��
;;; @return ���ꤷ�����#t
(define (tutcode-commit-by-label-key pc ch)
  ;; ���߸��䥦����ɥ���ɽ������Ƥ��ʤ���٥�ʸ�������Ϥ�����硢
  ;; ���߰ʹߤθ�����ˤ��������ϥ�٥�ʸ�����б�����������ꤹ�롣
  ;; (�ؽ���ǽ�򥪥դˤ��Ƹ�����¤ӽ�����ˤ��ƻ��Ѥ�����ˡ�
  ;; next-page-key�򲡤�����򸺤餷��
  ;; �ʤ�٤����ʤ���������Ū�θ�������٤�褦�ˤ��뤿��)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (idx
          (tutcode-get-idx-by-label-key ch nth tutcode-nr-candidate-max
            tutcode-nr-candidate-max tutcode-heading-label-char-list)))
    (if (and (>= idx 0)
             (< idx nr))
      (begin
        (tutcode-context-set-nth! pc idx)
        (tutcode-commit-with-auto-help pc)
        #t)
      (eq? tutcode-commit-candidate-by-label-key 'always))))

;;; ����������ˡ����ꤵ�줿��٥�ʸ�����б���������ֹ��׻�����
;;; @param ch ���Ϥ��줿��٥�ʸ��
;;; @param nth �������򤵤�Ƥ��������ֹ�
;;; @param page-limit �������򥦥���ɥ��Ǥγƥڡ�����θ�������
;;;                   (�䴰�ξ��:�䴰����+�ϸ쥬����)
;;; @param nr-in-page �������򥦥���ɥ��Ǥγƥڡ�����θ����
;;;                   (�䴰�ξ��:�䴰����Τ�)
;;; @param heading-label-char-list ��٥�ʸ��������
;;; @return �����ֹ�
(define (tutcode-get-idx-by-label-key ch nth page-limit nr-in-page
        heading-label-char-list)
  (let*
    ((cur-page (if (= page-limit 0)
                  0
                  (quotient nth page-limit)))
     ;; ���߸��䥦����ɥ���ɽ����θ���ꥹ�Ȥ���Ƭ�θ����ֹ�
     (cur-offset (* cur-page nr-in-page))
     (labellen (length heading-label-char-list))
     (cur-labels
       (list-tail heading-label-char-list (remainder cur-offset labellen)))
     (target-labels (member ch cur-labels))
     (offset (if target-labels
               (- (length cur-labels) (length target-labels))
               (+ (length cur-labels)
                  (- labellen
                     (length
                       (member ch heading-label-char-list))))))
     (idx (+ cur-offset offset)))
    idx))

;;; �������ϥ⡼�ɻ��ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
;;; @return ���ꤷ�����#t
(define (tutcode-commit-by-label-key-for-kigou-mode pc ch)
  ;; �򤼽��Ѵ����Ȱۤʤꡢ���ߤ�����θ������ꤹ���礢��
  ;; (���ѱѿ����ϥ⡼�ɤȤ��ƻȤ���褦�ˤ��뤿��)��
  ;; (�������ϥ⡼�ɻ��ϡ����ٳ��ꤷ�������Ϣ³�������ϤǤ���褦�ˡ�
  ;; ������ľ���θ�������򤷤Ƥ��뤬��
  ;; ���ΤȤ��򤼽��Ѵ�����Ʊ�ͤθ��������Ԥ��ȡ�
  ;; ��٥�ʸ���ꥹ�Ȥ�2���ܤ��б�����������ꤷ�Ƥ��ޤ���礬����
  ;; (��:th���Ǥä���硢���ѱѿ����ϤȤ��Ƥϣ���ˤʤä��ߤ������������ˤʤ�)
  ;; ���ᡢ�򤼽��Ѵ��Ȥϰۤʤ������������Ԥ�)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (labellen (length tutcode-heading-label-char-list-for-kigou-mode))
         (cur-base (quotient nth labellen))
         (offset
           (- labellen
              (length
                (member ch tutcode-heading-label-char-list-for-kigou-mode))))
         (idx (+ (* cur-base labellen) offset)))
    (if (and (>= idx 0)
             (< idx nr))
      (begin
        (tutcode-context-set-nth! pc idx)
        (tutcode-commit pc
          (tutcode-prepare-commit-string-for-kigou-mode pc))
        #t)
      (eq? tutcode-commit-candidate-by-label-key 'always))))

;;; �ҥ��ȥ����Ϥθ���������ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
;;; @param ch ���Ϥ��줿��٥�ʸ��
;;; @return ���ꤷ�����#t
(define (tutcode-commit-by-label-key-for-history pc ch)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (idx
          (tutcode-get-idx-by-label-key ch nth
            tutcode-nr-candidate-max-for-history
            tutcode-nr-candidate-max-for-history
            tutcode-heading-label-char-list-for-history)))
    (if (and (>= idx 0)
             (< idx nr))
      (begin
        (tutcode-context-set-nth! pc idx)
        (let ((str (tutcode-prepare-commit-string-for-history pc)))
          (tutcode-commit pc str)
          (tutcode-flush pc)
          (tutcode-check-auto-help-window-begin pc (string-to-list str) ()))
        #t)
      (eq? tutcode-commit-candidate-by-label-key 'always))))

;;; �䴰/ͽ¬���ϸ���ɽ�����ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
;;; @param ch ���Ϥ��줿��٥�ʸ��
;;; @param mode tutcode-context-predicting����
;;; @return ���ꤷ�����#t
(define (tutcode-commit-by-label-key-for-prediction pc ch mode)
  (let*
    ((nth (tutcode-context-prediction-index pc))
     (page-limit (tutcode-context-prediction-page-limit pc))
     (nr-in-page (tutcode-context-prediction-nr-in-page pc))
     (idx
      (tutcode-get-idx-by-label-key ch nth page-limit nr-in-page
        tutcode-heading-label-char-list-for-prediction))
     (nr (tutcode-lib-get-nr-predictions pc))
     ;; XXX:�ϸ쥬���ɤΥڡ�����������¿����硢
     ;;     �䴰����ϥ롼�פ���2���ܰʹߤβ�ǽ������(ɽ����candwin�Ǥʤ����)
     (i (if (zero? nr) -1 (remainder idx nr))))
    (if (>= i 0)
      (begin
        (case mode
          ((tutcode-predicting-bushu)
            (tutcode-do-commit-prediction-for-bushu pc i))
          ((tutcode-predicting-interactive-bushu)
            (tutcode-do-commit-prediction-for-interactive-bushu pc i))
          ((tutcode-predicting-completion)
            (tutcode-do-commit-prediction pc i #t))
          (else
            (tutcode-do-commit-prediction pc i #f)))
        #t)
      (eq? tutcode-commit-candidate-by-label-key 'always))))

(define (tutcode-get-prediction-string pc idx)
  (tutcode-lib-get-nth-prediction pc idx))

(define (tutcode-learn-prediction-string pc idx completion?)
  (tutcode-lib-commit-nth-prediction pc idx completion?))

;;; �䴰/ͽ¬���ϸ������ꤹ��
;;; @param completion? �䴰���ɤ���
(define (tutcode-do-commit-prediction pc idx completion?)
  (let ((str (tutcode-get-prediction-string pc idx)))
    (tutcode-learn-prediction-string pc idx completion?)
    (tutcode-reset-candidate-window pc)
    (tutcode-commit pc str)
    (tutcode-flush pc)
    (tutcode-check-auto-help-window-begin pc (string-to-list str) ())))

;;; ��������Ѵ�����ͽ¬���ϸ������ꤹ��
(define (tutcode-do-commit-prediction-for-bushu pc idx)
  (let ((str (tutcode-get-prediction-string pc idx)))
    (tutcode-reset-candidate-window pc)
    (tutcode-bushu-commit pc str)))

;;; ����Ū��������Ѵ����θ������ꤹ��
(define (tutcode-do-commit-prediction-for-interactive-bushu pc idx)
  (let ((str (tutcode-get-prediction-string pc idx)))
    (tutcode-reset-candidate-window pc)
    (tutcode-commit pc str)
    (tutcode-flush pc)
    (tutcode-check-auto-help-window-begin pc (string-to-list str) ())))

;;; �򤼽��Ѵ����񤫤顢�������򤵤�Ƥ������������롣
(define (tutcode-purge-candidate pc)
  (let ((res (skk-lib-purge-candidate
               tutcode-dic
               (cons (string-list-concat (tutcode-context-head pc)) "")
               ""
               (tutcode-context-nth pc)
               #f)))
    (if res
      (tutcode-save-personal-dictionary #t))
    (tutcode-reset-candidate-window pc)
    (tutcode-flush pc)
    res))

;;; �򤼽��Ѵ����ɤ�/��������Ѵ�������(ʸ����ꥹ��head)��ʸ������ɲä��롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param str �ɲä���ʸ����
(define (tutcode-append-string pc str)
  (if (and str (string? str))
    (tutcode-context-set-head! pc
      (cons str
        (tutcode-context-head pc)))))

;;; commit�Ѥ�ʸ����ꥹ��commit-strs��ʸ������ɲä��롣
;;; @param str �ɲä���ʸ����
(define (tutcode-append-commit-string pc str)
  (if (and str (string? str))
    (let* ((strlist (string-to-list str)) ; str��ʣ��ʸ���ξ�礢��
           (commit-strs (tutcode-context-commit-strs pc))
           (new-strs (append strlist commit-strs)))
      (tutcode-context-set-commit-strs! pc
        (if (> (length new-strs) tutcode-completion-chars-max)
          (take new-strs tutcode-completion-chars-max)
          new-strs)))))

;;; commitʸ��������ꥹ��history��ʸ������ɲä��롣
;;; @param str �ɲä���ʸ����
(define (tutcode-append-history pc str)
  (let* ((history (tutcode-context-history pc))
         (new-history (cons str (delete str history))))
    (tutcode-context-set-history! pc
      (if (> (length new-history) tutcode-history-size)
        (take new-history tutcode-history-size)
        new-history))))

;;; �򤼽��Ѵ��򳫻Ϥ���
;;; @param yomi �Ѵ��оݤ��ɤ�(ʸ����εս�ꥹ��)
;;; @param suffix ���Ѥ������Ѵ���Ԥ����γ��Ѹ���(ʸ����εս�ꥹ��)
;;; @param autocommit? ���䤬1�Ĥξ��˼�ưŪ�˳��ꤹ�뤫�ɤ���
;;; @param recursive-learning? ���䤬̵�����˺Ƶ���Ͽ�⡼�ɤ����뤫�ɤ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-conversion pc yomi suffix autocommit?
          recursive-learning?)
  (let*
    ((yomi-str (string-list-concat yomi))
     (res (and (symbol-bound? 'skk-lib-get-entry)
               (skk-lib-get-entry tutcode-dic yomi-str "" "" #f)
               (skk-lib-get-nr-candidates tutcode-dic yomi-str "" "" #f))))
    (if res
      (begin
        (tutcode-context-set-head! pc yomi)
        (tutcode-context-set-mazegaki-suffix! pc suffix)
        (tutcode-context-set-nth! pc 0)
        (tutcode-context-set-nr-candidates! pc res)
        (tutcode-context-set-state! pc 'tutcode-state-converting)
        (if (and autocommit? (= res 1))
          ;; ���䤬1�Ĥ����ʤ����ϼ�ưŪ�˳��ꤹ�롣
          ;; (������Ͽ��tutcode-register-candidate-key�򲡤�������Ū�˳��Ϥ���)
          (tutcode-commit-with-auto-help pc)
          (begin
            (tutcode-check-candidate-window-begin pc)
            (if (eq? (tutcode-context-candidate-window pc)
                     'tutcode-candidate-window-converting)
              (tutcode-select-candidate pc 0))))
        #t)
      ;; ����̵��
      (begin
        (if recursive-learning?
          (begin
            (tutcode-context-set-head! pc yomi)
            (tutcode-context-set-mazegaki-suffix! pc suffix)
            (tutcode-context-set-state! pc 'tutcode-state-converting)
            (tutcode-setup-child-context pc 'tutcode-child-type-editor)))
          ;(tutcode-flush pc) ; flush��������Ϥ���ʸ���󤬾ä��Ƥ��ä���
        #f))))

;;; ���ַ��򤼽��Ѵ��򳫻Ϥ���(���Ѥ����ˤ��б�)
;;; @param inflection? ���Ѥ����θ�����Ԥ����ɤ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-conversion-with-inflection pc inflection?)
  (let*
    ((yomi (tutcode-context-head pc))
     (yomi-len (length yomi)))
    (tutcode-context-set-postfix-yomi-len! pc 0)
    (tutcode-context-set-mazegaki-yomi-len-specified! pc yomi-len)
    (tutcode-context-set-mazegaki-yomi-all! pc yomi)
    (if (or (not inflection?)
            (not tutcode-mazegaki-enable-inflection?)
            (tutcode-mazegaki-inflection? yomi)) ; ����Ū��"��"�դ������Ϥ��줿
      (tutcode-begin-conversion pc yomi () #t tutcode-use-recursive-learning?)
      (or
        (tutcode-begin-conversion pc yomi () #f #f)
        ;; ���Ѥ����Ȥ��ƺƸ���
          (or
            (tutcode-mazegaki-inflection-relimit-right pc yomi-len yomi-len #f)
            ;; ���Ѥ��ʤ���Ȥ��ƺƵ��ؽ�
            (and tutcode-use-recursive-learning?
              (begin
                (tutcode-begin-conversion pc yomi () #t
                  tutcode-use-recursive-learning?))))))))

;;; ���Ѥ��������ַ��򤼽��Ѵ��򳫻Ϥ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-mazegaki-inflection-conversion pc)
  (let*
    ((yomi (tutcode-context-head pc))
     (yomi-len (length yomi)))
    (tutcode-context-set-postfix-yomi-len! pc 0)
    (tutcode-context-set-mazegaki-yomi-len-specified! pc yomi-len)
    (tutcode-context-set-mazegaki-yomi-all! pc yomi)
    (if (tutcode-mazegaki-inflection? yomi) ; ����Ū��"��"�դ������Ϥ��줿
      (tutcode-begin-conversion pc yomi () #t tutcode-use-recursive-learning?)
      (tutcode-mazegaki-inflection-relimit-right pc yomi-len yomi-len #f))))

;;; ���Ϥ��줿���������ɤ��б������������ꤹ��
;;; @param str-list ���������ɡ����Ϥ��줿ʸ����Υꥹ��(�ս�)
(define (tutcode-begin-kanji-code-input pc str-list)
  (let ((kanji (ja-kanji-code-input str-list)))
    (if (and kanji (> (string-length kanji) 0))
      (begin
        (tutcode-commit pc kanji)
        (tutcode-flush pc)
        (tutcode-undo-prepare pc 'tutcode-state-code kanji str-list)
        (tutcode-check-auto-help-window-begin pc (list kanji) ())))))

;;; �ҥ���ƥ����Ȥ�������롣
;;; @param type 'tutcode-child-type-editor��'tutcode-child-type-dialog
(define (tutcode-setup-child-context pc type)
  (let ((cpc (tutcode-context-new (tutcode-context-uc pc)
              (tutcode-context-im pc))))
    (tutcode-context-set-child-context! pc cpc)
    (tutcode-context-set-child-type! pc type)
    (tutcode-context-set-parent-context! cpc pc)
    (if (eq? type 'tutcode-child-type-dialog)
      (tutcode-context-set-state! cpc 'tutcode-state-off)
      (tutcode-context-set-state! cpc 'tutcode-state-on))
    cpc))

;;; �������ϥ⡼�ɤ򳫻Ϥ��롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-begin-kigou-mode pc)
  (tutcode-context-set-nth! pc 0)
  (tutcode-context-set-nr-candidates! pc (length tutcode-kigoudic))
  (tutcode-context-set-state! pc 'tutcode-state-kigou)
  (tutcode-check-candidate-window-begin pc)
  (if (eq? (tutcode-context-candidate-window pc)
           'tutcode-candidate-window-kigou)
    (tutcode-select-candidate pc 0)))

;;; �ҥ��ȥ����Ϥθ���ɽ���򳫻Ϥ���
(define (tutcode-begin-history pc)
  (if (and (> tutcode-history-size 0)
           (pair? (tutcode-context-history pc)))
    (begin
      (tutcode-context-set-nth! pc 0)
      (tutcode-context-set-nr-candidates! pc
        (length (tutcode-context-history pc)))
      (tutcode-context-set-state! pc 'tutcode-state-history)
      (tutcode-check-candidate-window-begin pc)
      (if (eq? (tutcode-context-candidate-window pc)
               'tutcode-candidate-window-history)
        (tutcode-select-candidate pc 0)))))

;;; 2���ȥ����������ϥ⡼��(tutcode-kigou-rule)��tutcode-rule���ڤ��ؤ���Ԥ�
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-toggle-kigou2-mode pc)
  (if tutcode-use-kigou2-mode?
    (let ((tmp-rkc (tutcode-context-rk-context pc))
          (tmp-stroke-help? tutcode-use-stroke-help-window?))
      (tutcode-context-set-rk-context! pc
        (tutcode-context-rk-context-another pc))
      (tutcode-context-set-rk-context-another! pc tmp-rkc)
      (set! tutcode-use-stroke-help-window?
        tutcode-use-stroke-help-window-another?)
      (set! tutcode-use-stroke-help-window-another? tmp-stroke-help?)
      (tutcode-context-set-guide-chars! pc ()))))

;;; �򤼽��Ѵ����������ϥ⡼�ɡ��ҥ��ȥ����ϥ⡼�ɻ���
;;; ���䥦����ɥ���ɽ���򳫻Ϥ���
(define (tutcode-check-candidate-window-begin pc)
  (if (and (eq? (tutcode-context-candidate-window pc)
                'tutcode-candidate-window-off)
           tutcode-use-candidate-window?
           (>= (tutcode-context-nth pc) (- tutcode-candidate-op-count 1)))
    (let ((state (tutcode-context-state pc)))
      (tutcode-activate-candidate-window pc
        (case state
          ((tutcode-state-kigou) 'tutcode-candidate-window-kigou)
          ((tutcode-state-history) 'tutcode-candidate-window-history)
          (else 'tutcode-candidate-window-converting))
        tutcode-candidate-window-activate-delay-for-mazegaki
        (tutcode-context-nr-candidates pc)
        (case state
          ((tutcode-state-kigou) tutcode-nr-candidate-max-for-kigou-mode)
          ((tutcode-state-history) tutcode-nr-candidate-max-for-history)
          (else tutcode-nr-candidate-max))))))

;;; ���䥦����ɥ���ɽ������
;;; @param type ���䥦����ɥ�������
;;; @param delay ���䥦����ɥ�ɽ���ޤǤ��Ԥ�����[s]
;;; @param nr �������delay��˷׻��������-1
;;; @param display-limit �ڡ���������
(define (tutcode-activate-candidate-window pc type delay nr display-limit)
  (tutcode-context-set-candidate-window! pc type)
  (tutcode-context-set-candwin-delay-selected-index! pc -1)
  (if (tutcode-candidate-window-enable-delay? pc delay)
    (begin
      (tutcode-context-set-candwin-delay-waiting! pc #t)
      (im-delay-activate-candidate-selector pc delay))
    (begin
      (tutcode-context-set-candwin-delay-waiting! pc #f)
      (if (and tutcode-use-pseudo-table-style?
               (>= nr 0))
        (let ((pnr-pdl (tutcode-pseudo-table-style-setup pc nr display-limit)))
          (im-activate-candidate-selector pc (car pnr-pdl) (cadr pnr-pdl)))
        (im-activate-candidate-selector pc nr display-limit)))))

;;; ���䥦����ɥ����ٱ�ɽ����Ԥ����ɤ������֤�
;;; @param delay �ٱ���֡�0�ξ����ٱ�ɽ���Ϥ��ʤ���
(define (tutcode-candidate-window-enable-delay? pc delay)
  (and tutcode-candidate-window-use-delay?
       (im-delay-activate-candidate-selector-supported? pc)
       (> delay 0)))

;;; ����ɽ��������ɽ���Ѥκǽ�Υڡ����θ���ꥹ�Ȥ��������
;;; pseudo-table-cands��set����
;;; @param nr �����
;;; @param display-limit �ڡ���������
;;; @return '(nr display-limit) ����ɽ�����θ���ꥹ�Ȥθ�����ȥڡ���������
(define (tutcode-pseudo-table-style-setup pc nr display-limit)
  (if (= nr 0)
    '(0 0)
    (let* ((pcands (tutcode-pseudo-table-style-make-page pc 0 display-limit nr))
           (pdl (length pcands))
           (nr-page (+ (quotient nr display-limit)
                       (if (= 0 (remainder nr display-limit)) 0 1)))
           (pnr (* nr-page pdl))
           (pcands-all (make-vector nr-page #f)))
      (vector-set! pcands-all 0 pcands)
      (tutcode-context-set-pseudo-table-cands! pc pcands-all)
      (list pnr pdl))))

;;; ����ɽ��������ɽ���Ѥο��ڡ����θ���ꥹ�Ȥ���������֤�
(define (tutcode-pseudo-table-style-make-new-page pc)
  (let*
    ((dl-nr-nth (tutcode-candwin-limit-nr-nth pc))
     (dl (list-ref dl-nr-nth 0))
     (nr (list-ref dl-nr-nth 1))
     (nth (list-ref dl-nr-nth 2))
     (page (quotient nth dl))
     (start-index (* page dl))
     (end-index (+ start-index dl)))
    (tutcode-pseudo-table-style-make-page pc start-index end-index nr)))

;;; ���䥦����ɥ���ɽ����������θ���ξ�����֤�
;;; @return (<�ڡ���������(display-limit)> <�������> <������θ����ֹ�>)
(define (tutcode-candwin-limit-nr-nth pc)
  (cond
    ((eq? (tutcode-context-state pc) 'tutcode-state-kigou)
      (list tutcode-nr-candidate-max-for-kigou-mode
            (tutcode-context-nr-candidates pc)
            (tutcode-context-nth pc)))
    ((eq? (tutcode-context-state pc) 'tutcode-state-history)
      (list tutcode-nr-candidate-max-for-history
            (tutcode-context-nr-candidates pc)
            (tutcode-context-nth pc)))
    ((eq? (tutcode-context-candidate-window pc)
          'tutcode-candidate-window-predicting)
      (list (tutcode-context-prediction-page-limit pc)
            (tutcode-context-prediction-nr-all pc)
            (tutcode-context-prediction-index pc)))
    ((eq? (tutcode-context-candidate-window pc)
          'tutcode-candidate-window-stroke-help)
      (list tutcode-nr-candidate-max-for-kigou-mode
            (length (tutcode-context-stroke-help pc))
            0))
    ((eq? (tutcode-context-candidate-window pc)
          'tutcode-candidate-window-auto-help)
      (list tutcode-nr-candidate-max-for-kigou-mode
            (length (tutcode-context-auto-help pc))
            0))
    ((eq? (tutcode-context-state pc) 'tutcode-state-interactive-bushu)
      (list (tutcode-context-prediction-page-limit pc)
            (tutcode-context-prediction-nr-all pc)
            (tutcode-context-prediction-index pc)))
    ((eq? (tutcode-context-candidate-window pc)
          'tutcode-candidate-window-converting)
      (list tutcode-nr-candidate-max
            (tutcode-context-nr-candidates pc)
            (tutcode-context-nth pc)))
    (else
      (list tutcode-nr-candidate-max 0 0))))

;;; ����ɽ��������ɽ���Ѥλ��ꤷ�������ֹ�Υڡ����θ���ꥹ�Ȥ���������֤�
;;; @param start-index �����ֹ�
;;; @param end-index ��λ�ֹ�
(define (tutcode-pseudo-table-style-make-page pc start-index end-index nr)
  (let ((cands
          (let loop
            ((idx start-index)
             (cands ()))
            (if (or (>= idx end-index) (>= idx nr))
              (reverse cands)
              (loop
                (+ idx 1)
                (cons (tutcode-get-candidate-handler-internal pc idx 0)
                      cands))))))
    ;; �ǽ�Υڡ����ʳ��ϡ���Ⱦʬ�֥�å������Ǥ��ά���ʤ�
    ;; (��������Ϻǽ�Υڡ����θ�������Ȥ˷׻�����Τǡ�
    ;; �ǽ�Υڡ����ǲ�Ⱦʬ�֥�å�ͭ��ʤΤˡ��Ǹ�Υڡ����Ǿ�ά�����ȡ�
    ;; ���䤬­��ʤ��ʤä�get-candidate���˥��顼�ˤʤ�)
    (tutcode-table-in-vertical-candwin cands (= start-index 0))))

;;; ����ꥹ�Ⱦ�θ����ֹ�򡢵���ɽ������θ����ֹ���Ѵ�
(define (tutcode-pseudo-table-style-candwin-index pc idx)
  (let* ((vec (tutcode-context-pseudo-table-cands pc))
         (display-limit (length (vector-ref vec 0)))
         (page-limit (list-ref (tutcode-candwin-limit-nr-nth pc) 0))
         (page (quotient idx page-limit)))
    (* page display-limit))) ; XXX:candwin�Υڡ���ñ�̤Τ��б�

;;; ����ɽ������θ����ֹ�򡢸���ꥹ�Ⱦ�θ����ֹ���Ѵ�
(define (tutcode-pseudo-table-style-scm-index pc idx)
  (let* ((vec (tutcode-context-pseudo-table-cands pc))
         (display-limit (length (vector-ref vec 0)))
         (page-limit (list-ref (tutcode-candwin-limit-nr-nth pc) 0))
         (page (quotient idx display-limit)))
    (* page page-limit))) ; XXX:candwin�Υڡ���ñ�̤Τ��б�

;;; ���䥦����ɥ���Ǹ�������򤹤�
;;; @param idx ���򤹤����Υ���ǥå����ֹ�
(define (tutcode-select-candidate pc idx)
  (if (tutcode-context-candwin-delay-waiting pc)
    ;; �ٱ�ɽ���Ԥ����candwin��̤�����Τ���im-select-candidate�����SEGV��
    ;; (XXX (uim api-doc�˹�碌��)candwin¦���н褷�������������⤷��ʤ�����
    ;;      shift-page�Ȥκ��߻��η׻������ݤʤΤǡ��Ȥꤢ����scm¦�ǡ�)
    (tutcode-context-set-candwin-delay-selected-index! pc idx)
    (tutcode-pseudo-table-select-candidate pc idx)))

;;; ���䥦����ɥ���Ǹ�������򤹤�(����ɽ��������ɽ���б�)
;;; @param idx ���򤹤����Υ���ǥå����ֹ�
(define (tutcode-pseudo-table-select-candidate pc idx)
  (if tutcode-use-pseudo-table-style?
    (im-select-candidate pc (tutcode-pseudo-table-style-candwin-index pc idx))
    (im-select-candidate pc idx)))

;;; ���۸��פ�ɽ���������ꥹ�Ȥ��ä��֤�
;;; @return ����ꥹ��(get-candidate-handler�ѷ���)
(define (tutcode-stroke-help-make pc)
  (let*
    ((rkc (tutcode-context-rk-context pc))
     (seq (rk-context-seq rkc))
     (seqlen (length seq))
     (seq-rev (reverse seq))
     (guide-seqs
      (and
        (pair? seq)
        (pair? (tutcode-context-guide-chars pc))
        (rk-lib-find-partial-seqs seq-rev (tutcode-context-guide-chars pc))))
     (guide-alist (tutcode-stroke-help-guide-update-alist () seqlen
                    (if (pair? guide-seqs) guide-seqs ())))
     ;; ��:(("v" "��+") ("a" "��+") ("r" "��+"))
     (guide-candcombined
      (map
        (lambda (elem)
          (list (car elem) (string-list-concat (cdr elem))))
        guide-alist))
     ;; stroke-help. ��:(("k" "��") ("i" "��") ("g" "*£"))
     (label-cand-alist
      (if (or tutcode-use-stroke-help-window?
              (and
                (pair? guide-seqs)
                (eq? tutcode-stroke-help-with-kanji-combination-guide 'full)))
        (let*
          ((rule (rk-context-rule rkc))
           (ret (rk-lib-find-partial-seqs seq-rev rule))
           (katakana? (tutcode-context-katakana-mode? pc))
           (label-cand-alist
            (if (null? seq) ; tutcode-rule�����ʤ�ƺ������٤��Τǥ���å���
              (cond
                ((not tutcode-show-stroke-help-window-on-no-input?)
                  ())
                ((tutcode-kigou2-mode? pc)
                  tutcode-kigou-rule-stroke-help-top-page-alist)
                (katakana?
                  (if (not tutcode-stroke-help-top-page-katakana-alist)
                    (set! tutcode-stroke-help-top-page-katakana-alist
                      (tutcode-stroke-help-update-alist
                        () seqlen katakana? ret)))
                  tutcode-stroke-help-top-page-katakana-alist)
                (else
                  (if (not tutcode-stroke-help-top-page-alist)
                    (set! tutcode-stroke-help-top-page-alist
                      (tutcode-stroke-help-update-alist
                        () seqlen katakana? ret)))
                  tutcode-stroke-help-top-page-alist))
              (tutcode-stroke-help-update-alist () seqlen katakana? ret))))
          ;; ɽ���������ʸ����򡢽ϸ쥬����(+)�դ�ʸ������֤�������
          (for-each
            (lambda (elem)
              (let*
                ((label (car elem))
                 (label-cand (assoc label label-cand-alist)))
                (if label-cand
                  (set-cdr! label-cand (cdr elem)))))
            guide-candcombined)
          label-cand-alist)
        (if (eq? tutcode-stroke-help-with-kanji-combination-guide 'guide-only)
          guide-candcombined
          ()))))
    (if (null? label-cand-alist)
      ()
      (map
        (lambda (elem)
          (list (cadr elem) (car elem) ""))
        (reverse label-cand-alist)))))

;;; ���۸��פ�ɽ���򳫻Ϥ���
(define (tutcode-check-stroke-help-window-begin pc)
  (if (eq? (tutcode-context-candidate-window pc) 'tutcode-candidate-window-off)
    (if (tutcode-candidate-window-enable-delay? pc
          tutcode-candidate-window-activate-delay-for-stroke-help)
      ;; XXX:����ɽ�����ʤ����ˤϥ����ޤ�ư���ʤ��褦�ˤ������Ȥ���
      (tutcode-activate-candidate-window pc
        'tutcode-candidate-window-stroke-help
        tutcode-candidate-window-activate-delay-for-stroke-help
        -1 -1)
      (let ((stroke-help (tutcode-stroke-help-make pc)))
        (if (pair? stroke-help)
          (begin
            (tutcode-context-set-stroke-help! pc stroke-help)
            (tutcode-activate-candidate-window pc
              'tutcode-candidate-window-stroke-help
              0
              (length stroke-help)
              tutcode-nr-candidate-max-for-kigou-mode)))))))

;;; �̾�θ��䥦����ɥ��ˡ�ɽ�����Ǹ����ɽ�����뤿��ˡ�
;;; ɽ������1��ʬ��Ϣ�뤷�������Ѵ����롣
;;; (ɽ�������䥦����ɥ�̤�б��ǡ��Ĥ˸�����¤٤�candwin�ѡ�
;;;  uim-el��(setq uim-candidate-display-inline t)�ξ����)
;;; @param cands ("ɽ��ʸ����" "��٥�ʸ����" "���")�Υꥹ��
;;; @param omit-empty-block? ɽ�β�Ⱦʬ(���եȥ����ΰ�)�����ξ��˾�ά���뤫
;;; @return �Ѵ���Υꥹ�ȡ�
;;;  ��:(("*��|*��|*��|*��|*��||*��|*��|*��|*��|*��||" "q" "") ...)
(define (tutcode-table-in-vertical-candwin cands omit-empty-block?)
  (let*
    ((layout (if (null? uim-candwin-prog-layout)
                uim-candwin-prog-layout-qwerty-jis
                uim-candwin-prog-layout))
     (vecsize (length layout))
     (vec (make-vector vecsize #f)))
    (for-each
      (lambda (elem)
        (let
          ((k (list-index (lambda (e) (string=? e (cadr elem))) layout)))
          (if k
            (vector-set! vec k (car elem)))))
      cands)
    (let*
      ;; ɽ�β�Ⱦʬ(���եȥ����ΰ�)�����ξ��Ͼ�Ⱦʬ�����Ȥ�
      ((vecmax
        (if (not omit-empty-block?)
          vecsize
          (let loop ((k (* 13 4)))
            (if (>= k vecsize)
              (* 13 4)
              (if (string? (vector-ref vec k))
                vecsize
                (loop (+ k 1)))))))
       ;; ����κ�������Ĵ�٤�
       (width-list0
        (let colloop
          ((col 12)
           (width-list ()))
          (if (negative? col)
            width-list
            (colloop
              (- col 1)
              (cons
                (let rowloop
                  ((k col)
                   (maxwidth -1))
                  (if (>= k vecmax)
                    maxwidth
                    (let*
                      ((elem (vector-ref vec k))
                       (width (if (string? elem) (string-length elem) -1)))
                      (rowloop
                        (+ k 13)
                        (if (> width maxwidth)
                          width
                          maxwidth)))))
                width-list)))))
       ;; ɽ�α�ü�֥�å������ξ���ɽ�����ʤ�
       (colmax
        (if (any (lambda (x) (> x -1)) (take-right width-list0 3)) 13 10))
       (width-list (map (lambda (x) (if (< x 2) 2 x)) width-list0))
       ;; ��٥�ϡ��ƹԤǡ��ǽ����ȤΤ������б������Τ����
       (labels
        (let rowloop
          ((row 0)
           (labels ()))
          (if (>= (* row 13) vecmax)
            (reverse labels)
            (rowloop
              (+ row 1)
              (cons
                (let colloop
                  ((col 0))
                  (let ((k (+ (* row 13) col)))
                    (cond
                      ((>= col colmax)
                        (list-ref layout (* row 13)))
                      ((string? (vector-ref vec k))
                        (list-ref layout k))
                      (else
                        (colloop (+ col 1))))))
                labels))))))
      ;; �ƹ���������Ϣ�뤷�Ƹ���ʸ�������
      (let rowloop
        ((table (take! (vector->list vec) vecmax))
         (k 0)
         (res ()))
        (if (null? table)
          (reverse res)
          (let*
            ((line (take table 13))
             (line-sep
              (cdr
                (let colloop
                  ((col (- colmax 1))
                   (line-sep (if (= colmax 10) '("||") ())))
                  (if (negative? col)
                    line-sep
                    (colloop
                      (- col 1)
                      (append
                        (let*
                          ((elem (list-ref line col))
                           (elemlen (if (string? elem) (string-length elem) 0))
                           (width (list-ref width-list col))
                           (strlist
                            (if (zero? elemlen)
                              (make-list width " ")
                              ;; ��������֤���
                              (letrec
                                ((padleft
                                  (lambda (pad strlist)
                                    (if (<= pad 0)
                                      strlist
                                      (padright
                                        (- pad 1)
                                        (cons " " strlist)))))
                                 (padright
                                  (lambda (pad strlist)
                                    (if (<= pad 0)
                                      strlist
                                      (padleft
                                        (- pad 1)
                                        (append strlist (list " ")))))))
                                (padleft (- width elemlen) (list elem))))))
                          (cons
                            (if (or (= col 5) (= col 10))
                              "||" ; �֥�å����ڤ����Ω������
                              "|")
                            strlist))
                        line-sep))))))
             (cand (apply string-append line-sep))
             (candlabel (list cand (list-ref labels (quotient k 13)) "")))
            (rowloop
              (drop table 13)
              (+ k 13)
              (cons candlabel res))))))))

;;; ���۸��פ�ɽ����Ԥ����ɤ������������Ū���ڤ��ؤ���(�ȥ���)��
;;; (���ɽ��������ܤ����ʤΤǡ��Ǥ������¤ä��Ȥ�����ɽ����������)
(define (tutcode-toggle-stroke-help pc)
  (if tutcode-use-stroke-help-window?
    (begin
      (set! tutcode-use-stroke-help-window? #f)
      (tutcode-reset-candidate-window pc))
    (set! tutcode-use-stroke-help-window? #t)))

;;; ���۸���ɽ���ѥǡ�������
;;; @param label-cand-alist ɽ���ѥǡ�����
;;;  ��:(("k" "��") ("i" "��") ("g" "*£"))
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param katakana? �������ʥ⡼�ɤ��ɤ�����
;;; @param rule-list rk-rule��
;;; @return ��������label-cand-alist
(define (tutcode-stroke-help-update-alist
         label-cand-alist seqlen katakana? rule-list)
  (if (null? rule-list)
    label-cand-alist
    (tutcode-stroke-help-update-alist
      (tutcode-stroke-help-update-alist-with-rule
        label-cand-alist seqlen katakana? (car rule-list))
      seqlen katakana? (cdr rule-list))))

;;; ���۸���ɽ���ѥǡ�������:��Ĥ�rule��ȿ�ǡ�
;;; @param label-cand-alist ɽ���ѥǡ�����
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param katakana? �������ʥ⡼�ɤ��ɤ�����
;;; @param rule rk-rule��ΰ�Ĥ�rule��
;;; @return ��������label-cand-alist
(define (tutcode-stroke-help-update-alist-with-rule
         label-cand-alist seqlen katakana? rule)
  (let* ((label (list-ref (caar rule) seqlen))
         (label-cand (assoc label label-cand-alist)))
    ;; ���˳����Ƥ��Ƥ��鲿�⤷�ʤ���rule��Ǻǽ�˽и�����ʸ�������
    (if label-cand
      label-cand-alist
      (let*
        ((candlist (cadr rule))
         ;; ������������?
         (has-next? (> (length (caar rule)) (+ seqlen 1)))
         (cand
          (or
            (and (not (null? (cdr candlist)))
                 katakana?
                 (cadr candlist))
            (car candlist)))
         (candstr
          (cond
            ((string? cand)
              cand)
            ((symbol? cand)
              (case cand
                ((tutcode-mazegaki-start) "��")
                ((tutcode-latin-conv-start) "/")
                ((tutcode-kanji-code-input-start) "��")
                ((tutcode-history-start) "��")
                ((tutcode-bushu-start) "��")
                ((tutcode-interactive-bushu-start) "��")
                ((tutcode-postfix-bushu-start) "��")
                ((tutcode-selection-mazegaki-start) "��s")
                ((tutcode-selection-mazegaki-inflection-start) "��s")
                ((tutcode-postfix-mazegaki-start) "��")
                ((tutcode-postfix-mazegaki-1-start) "��1")
                ((tutcode-postfix-mazegaki-2-start) "��2")
                ((tutcode-postfix-mazegaki-3-start) "��3")
                ((tutcode-postfix-mazegaki-4-start) "��4")
                ((tutcode-postfix-mazegaki-5-start) "��5")
                ((tutcode-postfix-mazegaki-6-start) "��6")
                ((tutcode-postfix-mazegaki-7-start) "��7")
                ((tutcode-postfix-mazegaki-8-start) "��8")
                ((tutcode-postfix-mazegaki-9-start) "��9")
                ((tutcode-postfix-mazegaki-inflection-start) "��")
                ((tutcode-postfix-mazegaki-inflection-1-start) "��1")
                ((tutcode-postfix-mazegaki-inflection-2-start) "��2")
                ((tutcode-postfix-mazegaki-inflection-3-start) "��3")
                ((tutcode-postfix-mazegaki-inflection-4-start) "��4")
                ((tutcode-postfix-mazegaki-inflection-5-start) "��5")
                ((tutcode-postfix-mazegaki-inflection-6-start) "��6")
                ((tutcode-postfix-mazegaki-inflection-7-start) "��7")
                ((tutcode-postfix-mazegaki-inflection-8-start) "��8")
                ((tutcode-postfix-mazegaki-inflection-9-start) "��9")
                ((tutcode-selection-katakana-start) "��s")
                ((tutcode-postfix-katakana-start) "��")
                ((tutcode-postfix-katakana-0-start) "��0")
                ((tutcode-postfix-katakana-1-start) "��1")
                ((tutcode-postfix-katakana-2-start) "��2")
                ((tutcode-postfix-katakana-3-start) "��3")
                ((tutcode-postfix-katakana-4-start) "��4")
                ((tutcode-postfix-katakana-5-start) "��5")
                ((tutcode-postfix-katakana-6-start) "��6")
                ((tutcode-postfix-katakana-7-start) "��7")
                ((tutcode-postfix-katakana-8-start) "��8")
                ((tutcode-postfix-katakana-9-start) "��9")
                ((tutcode-postfix-katakana-exclude-1) "��1")
                ((tutcode-postfix-katakana-exclude-2) "��2")
                ((tutcode-postfix-katakana-exclude-3) "��3")
                ((tutcode-postfix-katakana-exclude-4) "��4")
                ((tutcode-postfix-katakana-exclude-5) "��5")
                ((tutcode-postfix-katakana-exclude-6) "��6")
                ((tutcode-postfix-katakana-shrink-1) "��1")
                ((tutcode-postfix-katakana-shrink-2) "��2")
                ((tutcode-postfix-katakana-shrink-3) "��3")
                ((tutcode-postfix-katakana-shrink-4) "��4")
                ((tutcode-postfix-katakana-shrink-5) "��5")
                ((tutcode-postfix-katakana-shrink-6) "��6")
                ((tutcode-selection-kanji2seq-start) "/s")
                ((tutcode-postfix-kanji2seq-start) "/@")
                ((tutcode-postfix-kanji2seq-1-start) "/1")
                ((tutcode-postfix-kanji2seq-2-start) "/2")
                ((tutcode-postfix-kanji2seq-3-start) "/3")
                ((tutcode-postfix-kanji2seq-4-start) "/4")
                ((tutcode-postfix-kanji2seq-5-start) "/5")
                ((tutcode-postfix-kanji2seq-6-start) "/6")
                ((tutcode-postfix-kanji2seq-7-start) "/7")
                ((tutcode-postfix-kanji2seq-8-start) "/8")
                ((tutcode-postfix-kanji2seq-9-start) "/9")
                ((tutcode-selection-seq2kanji-start) "��s")
                ((tutcode-clipboard-seq2kanji-start) "��c")
                ((tutcode-postfix-seq2kanji-start) "��@")
                ((tutcode-postfix-seq2kanji-1-start) "��1")
                ((tutcode-postfix-seq2kanji-2-start) "��2")
                ((tutcode-postfix-seq2kanji-3-start) "��3")
                ((tutcode-postfix-seq2kanji-4-start) "��4")
                ((tutcode-postfix-seq2kanji-5-start) "��5")
                ((tutcode-postfix-seq2kanji-6-start) "��6")
                ((tutcode-postfix-seq2kanji-7-start) "��7")
                ((tutcode-postfix-seq2kanji-8-start) "��8")
                ((tutcode-postfix-seq2kanji-9-start) "��9")
                ((tutcode-auto-help-redisplay) "��")
                ((tutcode-help) "��")
                ((tutcode-help-clipboard) "?c")
                ((tutcode-undo) "��")
                (else cand)))
            ((procedure? cand)
              "��")))
         (cand-hint
          (or
            ;; ������������ξ���hint-mark(*)�դ�
            (and has-next? (string-append tutcode-hint-mark candstr))
            candstr)))
        (cons (list label cand-hint) label-cand-alist)))))

;;; ���۸��׾�νϸ쥬���ɤ�ɽ���˻Ȥ�alist�˴������ɲä��롣
;;; @param kanji-stroke �ɲä�������ȥ��ȥ����Υꥹ�ȡ�
;;; ��: ((("," "r"))("��"))
(define (tutcode-stroke-help-guide-add-kanji pc kanji-stroke)
  (let ((chars (tutcode-context-guide-chars pc)))
    (if (not (member kanji-stroke chars))
      (tutcode-context-set-guide-chars! pc (cons kanji-stroke chars)))))

;;; ���۸��׾�νϸ쥬���ɤ�ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦�˥�٥�ʸ����ɽ����ʸ����Υꥹ��(�ս�)��
;;; ��: (("v" "+" "��") ("a" "+" "��") ("r" "+" "��"))
;;; @param label-cands-alist ����alist
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param rule-list rk-rule��
;;; @return ������νϸ쥬������alist
(define (tutcode-stroke-help-guide-update-alist
         label-cands-alist seqlen rule-list)
  (if (null? rule-list)
    label-cands-alist
    (tutcode-stroke-help-guide-update-alist
      (tutcode-stroke-help-guide-update-alist-with-rule
        label-cands-alist seqlen (car rule-list))
      seqlen (cdr rule-list))))

;;; ���۸��׾�νϸ쥬����:�оݤ�1ʸ���򡢽ϸ쥬������alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param rule rk-rule��ΰ�Ĥ�rule��
;;; @return ������νϸ쥬����alist
(define (tutcode-stroke-help-guide-update-alist-with-rule
         label-cands-alist seqlen rule)
  (let* ((label (list-ref (caar rule) seqlen))
         (label-cand (assoc label label-cands-alist))
         (has-next? (> (length (caar rule)) (+ seqlen 1))) ; ������������?
         (cand (car (cadr rule))))
    (if label-cand
      (begin
        ;; ���˳����Ƥ��Ƥ�����
        (set-cdr! label-cand (cons cand (cdr label-cand)))
        label-cands-alist)
      (cons
        (if has-next?
          (list label cand tutcode-guide-mark)
          (list label tutcode-guide-end-mark cand))
        label-cands-alist))))

;;; ��ư�إ��ɽ���Τ���θ���ꥹ�Ȥ�������롣
;;; ɽ�����θ��䥦����ɥ��ξ��ϡ��ʲ��Τ褦��ɽ�����롣
;;; 1����1�Ǹ���2����2�Ǹ����ַȡ�
;;;  ��������        ��������
;;;  ��������        ����3 ��
;;;  ��������1(��)   ��������
;;;  ������2         ��������
;;; �򤼽��Ѵ���ʣ����ʸ���ַ��ӡפ��Ѵ��������ϡ��ʲ��Τ褦��ɽ�����롣
;;;  ������    ��        ��������
;;;  ����a(��) ��        ����3 ��
;;;  ������    ��1(��)b  ����c ��
;;;  ������    2         ��������
;;; ���ꤷ��ʸ����ľ�����ϤǤ��ʤ���硢ñ�����������Ѵ������ϤǤ���С�
;;; �ʲ��Τ褦����������Ѵ���ˡ��ɽ�����롣��ͫݵ��
;;;    ������������������������������������������������������������
;;;    ��  ��  ��  ��  ��  ��  ��            ��  ��  ��      ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��  ��  ��b ��  ��            ��  ��  ��f     ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��3 ��  ��  ��  ��  ��            ��  ��  ��1(ͫ) ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��d ��  ��e ��  ��2a(ݵ���Ӵ�)��  ��  ��      ��  ��
;;;    ������������������������������������������������������������
;;;
;;; tutcode-auto-help-with-real-keys?��#t�ξ��(�̾�θ��䥦����ɥ���)�ϡ�
;;; �ʲ��Τ褦��ɽ�����롣
;;;   ͫ lns
;;;   ݵ ���Ӵ� nt cbo
;;;
;;; @param strlist ���ꤷ��ʸ����Υꥹ��(�ս�)
;;; @param yomilist �Ѵ������ɤߤ�ʸ����Υꥹ��(�ս�)
;;; @return ����ꥹ��(get-candidate-handler�ѷ���)
(define (tutcode-auto-help-make pc strlist yomilist)
  (let*
    ((helpstrlist (lset-difference string=? (reverse strlist) yomilist))
     (label-cands-alist
      (if (not tutcode-auto-help-with-real-keys?)
        ;; ɽ�����ξ�����:(("y" "2" "1") ("t" "3"))
        (tutcode-auto-help-update-stroke-alist
          pc () tutcode-auto-help-cand-str-list helpstrlist)
        ;; �̾�ξ�����:(("��" "t" "y" "y"))
        (reverse
          (tutcode-auto-help-update-stroke-alist-normal pc () helpstrlist)))))
    (if (null? label-cands-alist)
      ()
      (map
        (lambda (elem)
          (list (string-list-concat (cdr elem)) (car elem) ""))
        label-cands-alist))))

;;; ��������Ѵ����򤼽��Ѵ��ǳ��ꤷ��ʸ�����Ǥ�����ɽ�����롣
;;; @param strlist ���ꤷ��ʸ����Υꥹ��(�ս�)
;;; @param yomilist �Ѵ������ɤߤ�ʸ����Υꥹ��(�ս�)
;;; @param opt-immediate? �ٱ�̵���Ǥ�����ɽ�����뤫�ɤ���(���ץ����)
(define (tutcode-check-auto-help-window-begin pc strlist yomilist . opt-immediate?)
  (if (and (eq? (tutcode-context-candidate-window pc)
                'tutcode-candidate-window-off)
           tutcode-use-auto-help-window?)
    (let ((immediate? (:optional opt-immediate? #f)))
      (tutcode-context-set-guide-chars! pc ())
      (if (and (not immediate?)
               (tutcode-candidate-window-enable-delay? pc
                tutcode-candidate-window-activate-delay-for-auto-help))
        (begin
          (tutcode-context-set-auto-help! pc (list 'delaytmp strlist yomilist))
          (tutcode-activate-candidate-window pc
            'tutcode-candidate-window-auto-help
            tutcode-candidate-window-activate-delay-for-auto-help
            -1 -1))
        (let ((auto-help (tutcode-auto-help-make pc strlist yomilist)))
          (if (pair? auto-help)
            (begin
              (tutcode-context-set-auto-help! pc auto-help)
              (tutcode-activate-candidate-window pc
                'tutcode-candidate-window-auto-help
                0
                (length auto-help)
                tutcode-nr-candidate-max-for-kigou-mode))))))))

;;; ����������֤�ľ���ˤ���ʸ�����Ǥ�����ɽ�����롣
;;; (surrounding text API��Ȥäƥ���������֤�ľ���ˤ���ʸ�������)
(define (tutcode-help pc)
  (let ((former-seq (tutcode-postfix-acquire-text pc 1)))
    (if (positive? (length former-seq))
      (tutcode-check-auto-help-window-begin pc former-seq () #t))))

;;; ����åץܡ������ʸ�����Ǥ�����ɽ�����롣
;;; (surrounding text API��Ȥäƥ���åץܡ��ɤ���ʸ�������)
(define (tutcode-help-clipboard pc)
  (let*
    ((len (length tutcode-auto-help-cand-str-list))
     (latter-seq (tutcode-clipboard-acquire-text-wo-nl pc len)))
    (if (pair? latter-seq)
      (tutcode-check-auto-help-window-begin pc latter-seq () #t))))

;;; clipboard���Ф������ϥ������󥹢������Ѵ��򳫻Ϥ���
(define (tutcode-begin-clipboard-seq2kanji-conversion pc)
  (let ((lst (tutcode-clipboard-acquire-text pc 'full)))
    (if (pair? lst)
      (let ((str (string-list-concat (tutcode-sequence->kanji-list pc lst))))
        (tutcode-commit pc str)
        (tutcode-undo-prepare pc 'tutcode-state-off str ())))))

;;; ����åץܡ��ɤ���ʸ�������Ԥ�����Ƽ�������
;;; @param len ��������ʸ����
;;; @return ��������ʸ����Υꥹ��(�ս�)
(define (tutcode-clipboard-acquire-text-wo-nl pc len)
  (let ((latter-seq (tutcode-clipboard-acquire-text pc len)))
    (and (pair? latter-seq)
         (delete "\n" latter-seq))))

;;; surrounding text API��Ȥäƥ���åץܡ��ɤ���ʸ�������
;;; @param len ��������ʸ����
;;; @return ��������ʸ����Υꥹ��(�ս�)�������Ǥ��ʤ�����#f
(define (tutcode-clipboard-acquire-text pc len)
  (and-let*
    ((ustr (im-acquire-text pc 'clipboard 'beginning 0 len))
     (latter (ustr-latter-seq ustr))
     (latter-seq (and (pair? latter) (string-to-list (car latter)))))
    (and (not (null? latter-seq))
         latter-seq)))

;;; ��ư�إ�פ�ɽ����ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦���Ǹ��򼨤���٥�ʸ���ȡ����������ɽ������ʸ����Υꥹ��
;;;  ��:(("y" "2" "1") ("t" "3")) ; ("y" "y" "t")�Ȥ������ȥ�����ɽ����
;;;  ��������    ��������
;;;  ��������3 12��������
;;;  ��������    ��������
;;;  ��������    ��������
;;; @param label-cands-alist ����alist
;;; @param kanji-list �إ��ɽ���оݤǤ��롢���ꤵ�줿����
;;; @param cand-list �إ��ɽ���˻Ȥ������Ǹ��򼨤�ʸ���Υꥹ��
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist pc label-cands-alist
         cand-list kanji-list)
  (if (or (null? cand-list) (null? kanji-list))
    label-cands-alist
    (tutcode-auto-help-update-stroke-alist
      pc
      (tutcode-auto-help-update-stroke-alist-with-kanji
        pc label-cands-alist (car cand-list) (car kanji-list))
      (cdr cand-list) (cdr kanji-list))))

;;; ��ư�إ�פ��̾����ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦��ʸ���ȡ�ʸ�������Ϥ��뤿��Υ����Υꥹ��(�ս�)
;;;  ��:(("��" "t" "y" "y"))
;;; @param label-cands-alist ����alist
;;; @param kanji-list �إ��ɽ���оݤǤ��롢���ꤵ�줿����
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-normal pc label-cands-alist
         kanji-list)
  (if (null? kanji-list)
    label-cands-alist
    (tutcode-auto-help-update-stroke-alist-normal
      pc
      (tutcode-auto-help-update-stroke-alist-normal-with-kanji
        pc label-cands-alist (car kanji-list))
      (cdr kanji-list))))

;;; ��ư�إ��:�оݤ�1ʸ�������Ϥ��륹�ȥ�����إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param cand-list �إ��ɽ���˻Ȥ������Ǹ��򼨤�ʸ���Υꥹ��
;;; @param kanji �إ��ɽ���о�ʸ��
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-with-kanji pc label-cands-alist
         cand-list kanji)
  (let*
    ((stime (time))
     (rule (rk-context-rule (tutcode-context-rk-context pc)))
     (stroke (tutcode-reverse-find-seq kanji rule)))
    (if stroke
      (begin
        (tutcode-stroke-help-guide-add-kanji
          pc (list (list stroke) (list kanji)))
        (tutcode-auto-help-update-stroke-alist-with-stroke
          label-cands-alist
          (cons (string-append (caar cand-list) "(" kanji ")") (cdar cand-list))
          stroke))
      (let ((decomposed (tutcode-auto-help-bushu-decompose kanji rule stime)))
        ;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
        (if (not decomposed)
          label-cands-alist
          (let*
            ((bushu-strs (tutcode-auto-help-bushu-composition-strs decomposed))
             (helpstrlist (append (list "(" kanji "��") bushu-strs '(")")))
             (helpstr (apply string-append helpstrlist))
             (alist
              (letrec
                ((update-stroke
                  (lambda (lst alist cand-list)
                    (if (or (null? lst) (null? cand-list))
                      (list alist cand-list)
                      (let
                        ((res
                          (if (tutcode-rule-element? (car lst))
                            (list
                              (tutcode-auto-help-update-stroke-alist-with-stroke
                                alist (car cand-list) (caar (car lst)))
                              (cdr cand-list))
                            (update-stroke (car lst) alist cand-list))))
                        (update-stroke (cdr lst) (car res) (cadr res)))))))
                (update-stroke decomposed label-cands-alist
                  (cons
                    (cons
                      (string-append (caar cand-list) helpstr)
                      (cdar cand-list))
                    (cdr cand-list))))))
            (tutcode-auto-help-bushu-composition-add-guide pc decomposed)
            (car alist)))))))

;;; tutcode-rule�����Ǥη���((("," "o"))("��"))���ɤ������֤�
(define (tutcode-rule-element? x)
  (and
    (pair? x)
    (pair? (car x))
    (pair? (caar x))
    (pair? (cdr x))
    (pair? (cadr x))
    (every string? (caar x))
    (every string? (cadr x))))

;;; ��ư�إ��:tutcode-auto-help-bushu-decompose�Ǹ���������
;;; ���������ˡ�ǻȤ�����򡢥������о�ʸ�����ɲä��롣
;;; @param decomposed tutcode-auto-help-bushu-decompose���
(define (tutcode-auto-help-bushu-composition-add-guide pc decomposed)
  (if (not (null? decomposed))
    (begin
      (if (tutcode-rule-element? (car decomposed))
        (tutcode-stroke-help-guide-add-kanji pc (car decomposed))
        (tutcode-auto-help-bushu-composition-add-guide pc (car decomposed)))
      (tutcode-auto-help-bushu-composition-add-guide pc (cdr decomposed)))))

;;; ��ư�إ��:tutcode-auto-help-bushu-decompose�Ǹ���������
;;; ���ȥ�����ޤ����������ˡ���顢
;;; ����ʸ����Τߤ�ȴ���Ф������������ˡ����
;;; @param decomposed tutcode-auto-help-bushu-decompose���
;;; @return ����������������ˡʸ����ꥹ��
(define (tutcode-auto-help-bushu-composition-strs decomposed)
  (tutcode-auto-help-bushu-composition-traverse decomposed ()
    (lambda (ele) (list (caadr ele))) "��" ""))

;;; ��ư�إ��:tutcode-auto-help-bushu-decompose�θ�����̤Υĥ꡼��¤���顢
;;; ������ȴ���Ф����ե�åȤʥꥹ�Ȥ���
;;; @param decomposed tutcode-auto-help-bushu-decompose���
;;; @param lst ������Υꥹ��
;;; @param picker decomposed������(tutcode-rule-element)����
;;;   �о����Ǥ�ȴ���Ф�����δؿ�
;;; @param branch-str �ޤ狼��򼨤�����˷�̥ꥹ�Ȥ��ɲä���ʸ����
;;; @param delim-str ������ζ��ڤ�򼨤�����˷�̥ꥹ�Ȥ��ɲä���ʸ����
;;; @return ������Υꥹ��
(define (tutcode-auto-help-bushu-composition-traverse decomposed lst picker
          branch-str delim-str)
  (if (null? decomposed)
    lst
    (let
      ((add
        (if (tutcode-rule-element? (car decomposed))
          (cons delim-str (picker (car decomposed)))
          (tutcode-auto-help-bushu-composition-traverse (car decomposed)
            (list branch-str) picker branch-str delim-str))))
      (tutcode-auto-help-bushu-composition-traverse (cdr decomposed)
        (append lst add) picker branch-str delim-str))))

;;; ��ư�إ��:�оݤ�1ʸ�������Ϥ��륹�ȥ�����إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param kanji �إ��ɽ���о�ʸ��
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-normal-with-kanji
          pc label-cands-alist kanji)
  (let*
    ((stime (time))
     (rule (rk-context-rule (tutcode-context-rk-context pc)))
     (stroke (tutcode-reverse-find-seq kanji rule)))
    (if stroke
      (begin
        (tutcode-stroke-help-guide-add-kanji
          pc (list (list stroke) (list kanji)))
        (tutcode-auto-help-update-stroke-alist-normal-with-stroke
          label-cands-alist
          (cons (string-append kanji " ") stroke)
          kanji))
      (let ((decomposed (tutcode-auto-help-bushu-decompose kanji rule stime)))
        ;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
        (if (not decomposed)
          label-cands-alist
          (let*
            ((bushu-strs (tutcode-auto-help-bushu-composition-strs decomposed))
             (helpstrlist (append (list kanji "��") bushu-strs))
             (helpstr (apply string-append helpstrlist))
             (bushu-stroke
              (tutcode-auto-help-bushu-composition-traverse decomposed ()
                caar "" " ")))
            (tutcode-auto-help-bushu-composition-add-guide pc decomposed)
            (tutcode-auto-help-update-stroke-alist-normal-with-stroke
              label-cands-alist
              (cons helpstr bushu-stroke)
              kanji)))))))

;;; ��ư�إ��:�оݤΥ��ȥ���(�����Υꥹ��)��إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param cand-list �إ��ɽ���˻Ȥ������Ǹ��򼨤�ʸ���Υꥹ��
;;; @param stroke �оݥ��ȥ���
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-with-stroke label-cands-alist
         cand-list stroke)
  (if (or (null? cand-list) (null? stroke))
    label-cands-alist
    (tutcode-auto-help-update-stroke-alist-with-stroke
      (tutcode-auto-help-update-stroke-alist-with-key
        label-cands-alist
        (if (pair? cand-list) (car cand-list) "")
        (car stroke))
      (cdr cand-list) (cdr stroke))))

;;; ��ư�إ��:�оݤΥ��ȥ���(�����Υꥹ��)��إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param stroke �оݥ��ȥ���
;;; @param label ���ꤵ�줿����
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-normal-with-stroke
          label-cands-alist stroke label)
  (let ((label-cand (assoc label label-cands-alist)))
    (if (not label-cand)
      (cons (cons label (reverse stroke)) label-cands-alist))))

;;; ��ư�إ��:�оݤΥ�����إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param cand �إ��ɽ���˻Ȥ����оݥ����򼨤�ʸ��
;;; @param key �оݥ���
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-with-key label-cands-alist
         cand key)
  (let*
    ((label key)
     (label-cand (assoc label label-cands-alist)))
    (if label-cand
      (begin
        (set-cdr! label-cand (cons cand (cdr label-cand)))
        label-cands-alist)
      (cons (list label cand) label-cands-alist))))

;;; ��ư�إ��:ľ��μ�ư�إ�פ��ɽ������
(define (tutcode-auto-help-redisplay pc)
  (let ((help (tutcode-context-auto-help pc)))
    (if (and help
             (> (length help) 0)
             (not (eq? (car help) 'delaytmp)))
      (tutcode-activate-candidate-window pc
        'tutcode-candidate-window-auto-help
        0
        (length help)
        tutcode-nr-candidate-max-for-kigou-mode))))

;;; ��ư�إ��:ľ���Υإ�פǸ��䥦����ɥ���ɽ���������Ƥ����ס�commit����
;;; (���������������(��:"������������")�򥳥ԡ������������)
(define (tutcode-auto-help-dump state pc)
  (if (eq? state 'tutcode-state-on)
    (let ((help (tutcode-context-auto-help pc)))
      (if (and help
               (> (length help) 0)
               (not (eq? (car help) 'delaytmp)))
        (let ((linecands
                (append-map
                  (lambda (elem)
                    (list (car elem) "\n"))
                  (tutcode-table-in-vertical-candwin help #t))))
          (tutcode-commit pc (apply string-append linecands) #t #t))))))

;;; preeditɽ���򹹿����롣
(define (tutcode-do-update-preedit pc)
  (let ((stat (tutcode-context-state pc))
        (cpc (tutcode-context-child-context pc))
        (cursor-shown? #f))
    (case stat
      ((tutcode-state-yomi)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-code)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-converting)
        (im-pushback-preedit pc preedit-none "��")
        (if (null? cpc)
          (begin
            (im-pushback-preedit pc preedit-none
              (tutcode-get-current-candidate pc))
            (let ((suffix (tutcode-context-mazegaki-suffix pc))) ; ���Ѹ���
              (if (pair? suffix)
                (begin
                  (im-pushback-preedit pc preedit-cursor "")
                  (set! cursor-shown? #t)
                  (im-pushback-preedit pc preedit-none
                    (string-list-concat suffix))))))
          ;; child context's preedit
          (let ((h (string-list-concat (tutcode-context-head pc)))
                (editor (tutcode-context-editor pc))
                (dialog (tutcode-context-dialog pc)))
            (if (string? h)
              (im-pushback-preedit pc preedit-none h))
            (im-pushback-preedit pc preedit-none "��")
            (im-pushback-preedit pc preedit-none
              (case (tutcode-context-child-type pc)
                ((tutcode-child-type-editor)
                  (tutcode-editor-get-left-string editor))
                ((tutcode-child-type-dialog)
                  (tutcode-dialog-get-left-string dialog))))
            (tutcode-do-update-preedit cpc)
            (set! cursor-shown? #t)
            (im-pushback-preedit pc preedit-none
              (case (tutcode-context-child-type pc)
                ((tutcode-child-type-editor)
                  (tutcode-editor-get-right-string editor))
                ((tutcode-child-type-dialog)
                  (tutcode-dialog-get-right-string dialog))))
            (im-pushback-preedit pc preedit-none "��"))))
      ;; ��������Ѵ��Υޡ�������ʸ����Ȥ���head��Ǵ���(�Ƶ�Ū��������Τ���)
      ((tutcode-state-bushu)
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-interactive-bushu)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h)))
        (if tutcode-show-pending-rk?
          (im-pushback-preedit pc preedit-underline
            (rk-pending (tutcode-context-rk-context pc))))
        (im-pushback-preedit pc preedit-cursor "")
        (set! cursor-shown? #t)
        (if (> (tutcode-lib-get-nr-predictions pc) 0)
          (begin
            (im-pushback-preedit pc preedit-underline "=>")
            (im-pushback-preedit pc preedit-underline
              (tutcode-get-prediction-string pc
                (tutcode-context-prediction-index pc)))))) ; �ϸ쥬����̵��
      ((tutcode-state-kigou)
        ;; ���䥦����ɥ���ɽ�����Ǥ��������Ǥ���褦��preeditɽ��
        (im-pushback-preedit pc preedit-reverse
          (tutcode-get-current-candidate-for-kigou-mode pc)))
      ((tutcode-state-history)
        (im-pushback-preedit pc preedit-none "��")
        (im-pushback-preedit pc preedit-none
          (tutcode-get-current-candidate-for-history pc)))
      ((tutcode-state-postfix-katakana)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-postfix-kanji2seq)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-postfix-seq2kanji)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (string-list-concat (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h)))))
    (if (not cursor-shown?)
      (begin
        (if (and tutcode-show-pending-rk?
                 (memq stat '(tutcode-state-on tutcode-state-yomi
                              tutcode-state-bushu)))
          (im-pushback-preedit pc preedit-underline
            (rk-pending (tutcode-context-rk-context pc))))
        (im-pushback-preedit pc preedit-cursor "")))))

;;; preeditɽ���򹹿����롣
(define (tutcode-update-preedit pc)
  (im-clear-preedit pc)
  (tutcode-do-update-preedit (tutcode-find-root-context pc))
  (im-update-preedit pc))

;; called from tutcode-editor
;;; tutcode-editor¦�Ǥ��Խ���λ���˸ƤФ�롣
;;; @param str ���ǥ���¦�ǳ��ꤵ�줿ʸ����
(define (tutcode-commit-editor-context pc str)
  (let* ((yomi-len (tutcode-context-postfix-yomi-len pc))
         (suffix (tutcode-context-mazegaki-suffix pc))
         (commit-str (if (null? suffix)
                         str
                         (string-append str (string-list-concat suffix)))))
    (tutcode-context-set-child-context! pc ())
    (tutcode-context-set-child-type! pc ())
    (cond
      ((= yomi-len 0)
        (tutcode-flush pc)
        (tutcode-commit pc commit-str))
      ((> yomi-len 0)
        (let ((yomi (take (tutcode-context-mazegaki-yomi-all pc) yomi-len)))
          (tutcode-postfix-commit pc commit-str yomi)
          (tutcode-flush pc)))
      (else
        (tutcode-selection-commit pc commit-str
          (tutcode-context-mazegaki-yomi-all pc))
        (tutcode-flush pc)))
    (tutcode-update-preedit pc)))

;;; �䴰����򸡺����Ƹ��䥦����ɥ���ɽ������
;;; @param force-check? ɬ��������Ԥ����ɤ�����
;;;  #f�ξ���ʸ������������̤���ξ��ϸ������ʤ���
;;; @param num commit-strs���鸡���оݤˤ���ʸ������0�ξ������ơ�
(define (tutcode-check-completion pc force-check? num)
  (tutcode-context-set-commit-strs-used-len! pc 0)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((commit-strs-all (tutcode-context-commit-strs pc))
           (commit-strs
            (if (> num 0)
              (take commit-strs-all num)
              commit-strs-all))
           (len (length commit-strs)))
      (if
        (or (>= len tutcode-completion-chars-min)
            (and force-check?
                 (> len 0)))
        (let ((delay
                (if force-check?
                  0
                  tutcode-candidate-window-activate-delay-for-completion)))
          (if (tutcode-candidate-window-enable-delay? pc delay)
            (tutcode-activate-candidate-window pc
              'tutcode-candidate-window-predicting delay -1 -1)
            (if (tutcode-check-completion-make pc force-check? num)
              (tutcode-activate-candidate-window pc
                'tutcode-candidate-window-predicting
                0
                (tutcode-context-prediction-nr-all pc)
                (tutcode-context-prediction-page-limit pc)))))))))

;;; �䴰����򸡺����Ƹ���ꥹ�Ȥ��������
;;; @param force-check? ɬ��������Ԥ����ɤ�����
;;;  #f�ξ���ʸ������������̤���ξ��ϸ������ʤ���
;;; @param num commit-strs���鸡���оݤˤ���ʸ������0�ξ������ơ�
;;; @return #t:ɽ��������䤢��, #f:ɽ���������ʤ�
(define (tutcode-check-completion-make pc force-check? num)
  (tutcode-context-set-commit-strs-used-len! pc 0)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((commit-strs-all (tutcode-context-commit-strs pc))
           (commit-strs
            (if (> num 0)
              (take commit-strs-all num)
              commit-strs-all))
           (len (length commit-strs)))
      (if
        (or (>= len tutcode-completion-chars-min)
            (and force-check?
                 (> len 0)))
        (let ((str (string-list-concat commit-strs)))
          (tutcode-lib-set-prediction-src-string pc str #t)
          (let ((nr (tutcode-lib-get-nr-predictions pc)))
            (if (and nr (> nr 0))
              (let*
                ((nr-guide
                  (if tutcode-use-kanji-combination-guide?
                    (begin
                      (tutcode-guide-set-candidates pc str #t ())
                      (length (tutcode-context-guide pc)))
                    0))
                 (res (tutcode-prediction-calc-window-param nr nr-guide))
                 (nr-all (list-ref res 0)) ; �������(�䴰����+�ϸ쥬����)
                 (page-limit (list-ref res 1)) ; �ڡ���������(�䴰+�ϸ�)
                 (nr-in-page (list-ref res 2))) ; �ڡ���������(�䴰����Τ�)
                (if (> page-limit 0)
                  (begin
                    (tutcode-context-set-commit-strs-used-len! pc len)
                    (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
                    (tutcode-context-set-prediction-page-limit! pc page-limit)
                    (tutcode-context-set-prediction-nr-all! pc nr-all)
                    (tutcode-context-set-prediction-index! pc 0)
                    (tutcode-context-set-predicting! pc
                      'tutcode-predicting-completion)))
                #t)
              ;; �䴰���䤬���Ĥ���ʤ���硢1ʸ����ä�ʸ�����ȤäƺƸ���
              ;; (ľ��tutcode-context-set-commit-strs!��ʸ������ȡ�
              ;;  �ְ�ä�ʸ�������Ϥ���Backspace�Ǿä����Ȥ��ˡ�
              ;;  �������Ϥ���ʸ���󤬺���Ƥ��뤿�ᡢ���Ԥ����䴰�ˤʤ�ʤ�
              ;;  ���줢�ꡣ®��Ū�ˤϡ�ľ�ܺ������®������)
              (if (> len 1)
                (tutcode-check-completion-make pc force-check? (- len 1))
                #f))))
        #f))
    #f))

;;; �򤼽��Ѵ����ͽ¬���ϸ���򸡺����Ƹ��䥦����ɥ���ɽ������
;;; @param force-check? ɬ��������Ԥ����ɤ�����
;;;  #f�ξ���ʸ������������̤���ξ��ϸ������ʤ���
(define (tutcode-check-prediction pc force-check?)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((head (tutcode-context-head pc))
           (preedit-len (length head)))
      (if
        (or (>= preedit-len tutcode-prediction-start-char-count)
            force-check?)
        (let ((delay
              (if force-check?
                0
                tutcode-candidate-window-activate-delay-for-prediction)))
          (if (tutcode-candidate-window-enable-delay? pc delay)
            (tutcode-activate-candidate-window pc
              'tutcode-candidate-window-predicting delay -1 -1)
            (if (tutcode-check-prediction-make pc force-check?)
              (tutcode-activate-candidate-window pc
                'tutcode-candidate-window-predicting
                0
                (tutcode-context-prediction-nr-all pc)
                (tutcode-context-prediction-page-limit pc)))))))))

;;; ͽ¬���ϸ���򸡺����Ƹ���ꥹ�Ȥ���
;;; @param force-check? ɬ��������Ԥ����ɤ�����
;;;  #f�ξ���ʸ������������̤���ξ��ϸ������ʤ���
;;; @return #t:ɽ��������䤢��, #f:ɽ���������ʤ�
(define (tutcode-check-prediction-make pc force-check?)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((head (tutcode-context-head pc))
           (preedit-len (length head)))
      (if
        (or (>= preedit-len tutcode-prediction-start-char-count)
            force-check?)
        (let*
          ((preconv-str (string-list-concat head))
           (all-yomi (tutcode-lib-set-prediction-src-string pc preconv-str #f))
           (nr (tutcode-lib-get-nr-predictions pc)))
          (if (and nr (> nr 0))
            (let*
              ((nr-guide
                (if tutcode-use-kanji-combination-guide?
                  (begin
                    (tutcode-guide-set-candidates pc preconv-str #f all-yomi)
                    (length (tutcode-context-guide pc)))
                  0))
               (res (tutcode-prediction-calc-window-param nr nr-guide))
               (nr-all (list-ref res 0)) ; �������(ͽ¬����+�ϸ쥬����)
               (page-limit (list-ref res 1)) ; �ڡ���������(ͽ¬+�ϸ�)
               (nr-in-page (list-ref res 2))) ; �ڡ���������(ͽ¬����Τ�)
              (if (> page-limit 0)
                (begin
                  (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
                  (tutcode-context-set-prediction-page-limit! pc page-limit)
                  (tutcode-context-set-prediction-nr-all! pc nr-all)
                  (tutcode-context-set-prediction-index! pc 0)
                  (tutcode-context-set-predicting! pc
                    'tutcode-predicting-prediction)
                  #t)
                #f))
            #f))
        #f))
    #f))

;;; ��������Ѵ����ͽ¬���ϸ���򸡺����Ƹ��䥦����ɥ���(�ٱ�)ɽ������
;;; @param char ���Ϥ��줿����1
(define (tutcode-check-bushu-prediction pc char)
  (if (tutcode-candidate-window-enable-delay? pc
        tutcode-candidate-window-activate-delay-for-bushu-prediction)
    (begin
      (tutcode-context-set-prediction-bushu! pc char) ; �ٱ�ƽл��Ѥ˰���ݻ�
      (tutcode-activate-candidate-window pc
        'tutcode-candidate-window-predicting
        tutcode-candidate-window-activate-delay-for-bushu-prediction
        -1 -1))
    (tutcode-check-bushu-prediction-make pc char #t)))

;;; ��������Ѵ����ͽ¬���ϸ���򸡺����Ƹ���ꥹ�Ȥ��������
;;; @param char ���Ϥ��줿����1
;;; @param show-candwin? ����ꥹ�Ȥκ�������䥦����ɥ���ɽ����Ԥ����ɤ���
;;; @return #t:ɽ��������䤢��, #f:ɽ���������ʤ�
(define (tutcode-check-bushu-prediction-make pc char show-candwin?)
  (let ((res
          (case tutcode-bushu-conversion-algorithm
            ((tc-2.3.1-22.6)
              (tutcode-bushu-predict-tc23 char))
            (else ; 'tc-2.1+ml1925
              (tutcode-bushu-predict-tc21 char)))))
    (tutcode-context-set-prediction-bushu! pc res)
    (tutcode-context-set-prediction-bushu-page-start! pc 0)
    (tutcode-bushu-prediction-make-page pc 0 show-candwin?)))

;;; ��������Ѵ����ͽ¬���ϸ���򸡺����Ƹ���ꥹ�Ȥ��������
;;; @param char ���Ϥ��줿����1
;;; @return (<����2> <����ʸ��>)�Υꥹ��
(define (tutcode-bushu-predict-tc21 char)
  (let* ((res (tutcode-bushu-predict char tutcode-bushudic))
         (alt (assoc char tutcode-bushudic-altchar))
         (altres
          (if alt
            (tutcode-bushu-predict (cadr alt) tutcode-bushudic)
            ()))
         (resall (append res altres)))
    resall))

;;; ��������Ѵ����ͽ¬���ϸ���򸡺����Ƹ���ꥹ�Ȥ��������
;;; @param char ���Ϥ��줿����1
;;; @return (<����2> <����ʸ��>)�Υꥹ��
(define (tutcode-bushu-predict-tc23 char)
  (let ((gosei (tutcode-bushu-compose-tc23 (list char) #f)))
    (map
      (lambda (elem)
        (list #f elem))
      gosei)))

;;; ��������Ѵ���ͽ¬���ϸ���Τ�����
;;; ���ꤵ�줿�ֹ椫��Ϥޤ�1�ڡ����֤�θ���ꥹ�Ȥ�������롣
;;; @param start-index �����ֹ�
;;; @param show-candwin? ����ꥹ�Ȥκ�������䥦����ɥ���ɽ����Ԥ����ɤ�����
;;;  #f�ξ��ϡ�����ꥹ�Ȥκ����Τ߹Ԥ�(delay-activating-handler��)
;;; @return #t:ɽ��������䤢��, #f:ɽ���������ʤ�
(define (tutcode-bushu-prediction-make-page pc start-index show-candwin?)
  (tutcode-lib-set-bushu-prediction pc start-index)
  (let ((nr (tutcode-lib-get-nr-predictions pc)))
    (if (and nr (> nr 0))
      (let*
        ((nr-guide
          (if tutcode-use-kanji-combination-guide?
            (begin
              (tutcode-guide-set-candidates-for-bushu pc)
              (length (tutcode-context-guide pc)))
            0))
         (res (tutcode-prediction-calc-window-param nr nr-guide))
         (nr-all (list-ref res 0)) ; �������(ͽ¬����+�ϸ쥬����)
         (page-limit (list-ref res 1)) ; �ڡ���������(ͽ¬+�ϸ�)
         (nr-in-page (list-ref res 2))) ; �ڡ���������(ͽ¬����Τ�)
        (if (> page-limit 0)
          (begin
            (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
            (tutcode-context-set-prediction-page-limit! pc page-limit)
            (tutcode-context-set-prediction-nr-all! pc nr-all)
            (tutcode-context-set-prediction-index! pc 0)
            (tutcode-context-set-predicting! pc 'tutcode-predicting-bushu)
            (if show-candwin?
              (tutcode-activate-candidate-window pc
                'tutcode-candidate-window-predicting
                0 nr-all page-limit))
            #t)
          #f))
      #f)))

;;; �䴰����Ƚϸ쥬����ɽ���Τ����candwin�ѥѥ�᡼����׻�����
;;; @param nr �䴰�����
;;; @param nr-guide �ϸ쥬���ɸ����
;;; @return (<�������> <�ڡ������Ȥθ�������> <�ڡ������Ȥ��䴰��������>)
(define (tutcode-prediction-calc-window-param nr nr-guide)
  (cond
    ;; 1�ڡ����˼��ޤ���
    ((and (<= nr-guide tutcode-nr-candidate-max-for-guide)
          (<= nr tutcode-nr-candidate-max-for-prediction))
      (list (+ nr-guide nr) (+ nr-guide nr) nr))
    ;; �䴰���䤬1�ڡ����˼��ޤ�ʤ����
    ((and (<= nr-guide tutcode-nr-candidate-max-for-guide)
          (> nr tutcode-nr-candidate-max-for-prediction))
      (if (= 0 tutcode-nr-candidate-max-for-prediction)
        (list nr-guide nr-guide 0) ; �䴰�����ɽ�����ʤ�
        (let*
          ((nr-page
            ;; �ڡ����������ϰ���ˤ��ʤ������ݤʤΤǡ�
            ;; �ƥڡ�����Ʊ���ϸ쥬���ɤ�ɽ����
            ;; ��������;��Υڡ����ˤ�ɽ�����ʤ���
            ;; (�ƥڡ�����Ǥ�index��nr-candidate-max-for-prediction̤����
            ;;  ������䴰/ͽ¬���ϸ��䡢�ʾ�θ����ϸ쥬���ɤȤ��ư����Τ�
            ;;  ����������ʤ��䴰����������ʤ�;��Υڡ����Ǥ�ɽ������������)
            (quotient nr tutcode-nr-candidate-max-for-prediction))
           (page-limit (+ nr-guide tutcode-nr-candidate-max-for-prediction))
           (nr-all (+ nr (* nr-guide nr-page))))
          (list nr-all page-limit tutcode-nr-candidate-max-for-prediction))))
    ;; �ϸ쥬���ɤ�1�ڡ����˼��ޤ�ʤ����
    ((and (> nr-guide tutcode-nr-candidate-max-for-guide)
          (<= nr tutcode-nr-candidate-max-for-prediction))
      (if (= 0 tutcode-nr-candidate-max-for-guide)
        (list nr nr nr) ; �ϸ쥬���ɤ�ɽ�����ʤ�
        (let*
          ((nr-page
            (+ 
              (quotient nr-guide tutcode-nr-candidate-max-for-guide)
              (if (= 0 (remainder nr-guide tutcode-nr-candidate-max-for-guide))
                0
                1)))
           (page-limit (+ nr tutcode-nr-candidate-max-for-guide))
           (nr-all (+ nr-guide (* nr nr-page))))
          (list nr-all page-limit nr))))
    ;; �䴰����Ƚϸ쥬����ξ���Ȥ�1�ڡ����˼��ޤ�ʤ����
    (else
      (cond
        ;; �ϸ쥬���ɤΤ�ɽ��
        ((= 0 tutcode-nr-candidate-max-for-prediction)
          (list nr-guide tutcode-nr-candidate-max-for-guide 0))
        ;; �䴰����Τ�ɽ��
        ((= 0 tutcode-nr-candidate-max-for-guide)
          (list nr tutcode-nr-candidate-max-for-prediction
            tutcode-nr-candidate-max-for-prediction))
        (else
          (let*
            ((nr-page-prediction
              (quotient nr tutcode-nr-candidate-max-for-prediction))
             (nr-page-guide
              (+
                (quotient nr-guide tutcode-nr-candidate-max-for-guide)
                (if (= 0 (remainder nr-guide tutcode-nr-candidate-max-for-guide))
                  0
                  1)))
             (nr-page (max nr-page-prediction nr-page-guide))
             (page-limit (+ tutcode-nr-candidate-max-for-guide
              tutcode-nr-candidate-max-for-prediction))
             (nr-all 
              (if (> nr-page-prediction nr-page-guide)
                (+ nr (* nr-page tutcode-nr-candidate-max-for-guide))
                (+ nr-guide (* nr-page tutcode-nr-candidate-max-for-prediction)))))
            (list nr-all page-limit tutcode-nr-candidate-max-for-prediction)))))))

;;; TUT-Code���Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-on c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     ;; reset-candidate-window�ǥꥻ�åȤ����Τ���¸���Ƥ���
     (completing?
      (eq? (tutcode-context-predicting pc) 'tutcode-predicting-completion))
     (rk-commit-flush
      (lambda ()
        (if (and tutcode-keep-illegal-sequence?
                 (pair? (rk-context-seq rkc)))
          (tutcode-commit pc (rk-pending rkc) #f #t))
        (rk-flush rkc)))
     ;; �䴰����ɽ���Υڡ�����ư���ϡ�reset-candidate-window����������
     (prediction-keys-handled?
      (if completing?
        (cond
          ((tutcode-next-page-key? key key-state)
            (tutcode-change-prediction-page pc #t)
            #t)
          ((tutcode-prev-page-key? key key-state)
            (tutcode-change-prediction-page pc #f)
            #t)
          (else
            #f))
        #f)))
    (if (not prediction-keys-handled?)
      (begin
        (tutcode-reset-candidate-window pc)
        (cond
          ((and
            (tutcode-vi-escape-key? key key-state)
            tutcode-use-with-vi?)
           (rk-commit-flush)
           (tutcode-context-set-commit-strs! pc ())
           (tutcode-context-set-state! pc 'tutcode-state-off)
           (tutcode-commit-raw pc key key-state)) ; ESC�����򥢥ץ�ˤ��Ϥ�
          ((tutcode-off-key? key key-state)
           (rk-commit-flush)
           (tutcode-context-set-commit-strs! pc ())
           (tutcode-context-set-state! pc 'tutcode-state-off))
          ((tutcode-on-key? key key-state) ; off-key��on-key���̥����ξ��
           ;; ����on�Ǥ�off�Ǥ⡢on-key��on�ˤ����������ʤΤ�commit-raw�����
           (rk-commit-flush))
          ((tutcode-kigou-toggle-key? key key-state)
           (rk-commit-flush)
           (tutcode-begin-kigou-mode pc))
          ((tutcode-kigou2-toggle-key? key key-state)
           (rk-commit-flush)
           (tutcode-toggle-kigou2-mode pc))
          ((and (tutcode-kana-toggle-key? key key-state)
                (not (tutcode-kigou2-mode? pc)))
           (rk-commit-flush)
           (tutcode-context-kana-toggle pc))
          ((tutcode-backspace-key? key key-state)
           (if (> (length (rk-context-seq rkc)) 0)
             (rk-flush rkc)
             (begin
               (tutcode-commit-raw pc key key-state)
               (if (and (or tutcode-use-completion?
                            tutcode-enable-fallback-surrounding-text?)
                        (pair? (tutcode-context-commit-strs pc)))
                 (tutcode-context-set-commit-strs! pc
                     (cdr (tutcode-context-commit-strs pc))))
               (if (and tutcode-use-completion?
                        completing?
                        (> tutcode-completion-chars-min 0))
                 (tutcode-check-completion pc #f 0)))))
          ((tutcode-stroke-help-toggle-key? key key-state)
           (tutcode-toggle-stroke-help pc))
          ((and tutcode-use-completion?
                (tutcode-begin-completion-key? key key-state))
           (rk-commit-flush)
           (if completing?
             ;; �䴰���begin-completin-key�������줿���о�ʸ����1���餷�ƺ��䴰
             ;; (�տޤ��ʤ�ʸ������䴰���줿���ˡ��䴰��ľ�����Ǥ���褦��)
             ;; �оݤ�1ʸ��̤���ˤʤ�����䴰������ɥ����Ĥ���(��ɽ�����ʤ�)
             (let ((len (tutcode-context-commit-strs-used-len pc)))
               (if (> len 1)
                 (tutcode-check-completion pc #t (- len 1))))
             (tutcode-check-completion pc #t 0)))
          ((and (tutcode-paste-key? key key-state)
                (pair? (tutcode-context-parent-context pc)))
            (let ((latter-seq (tutcode-clipboard-acquire-text-wo-nl pc 'full)))
              (if (pair? latter-seq)
                (tutcode-commit pc (string-list-concat latter-seq)))))
          ((or
            (symbol? key)
            (and
              (modifier-key-mask key-state)
              (not (shift-key-mask key-state))))
           (rk-commit-flush)
           (tutcode-commit-raw pc key key-state))
          ;; �䴰�����ѥ�٥륭��?
          ((and completing?
                (tutcode-heading-label-char-for-prediction? key)
                (tutcode-commit-by-label-key-for-prediction pc
                  (charcode->string key) 'tutcode-predicting-completion)))
          ;; �������ʤ������������󥹤����ƼΤƤ�(tc2�˹�碌��ư��)��
          ;; (rk-push-key!����ȡ�����ޤǤΥ������󥹤ϼΤƤ��뤬��
          ;; �ְ�ä������ϻĤäƤ��ޤ��Τǡ�rk-push-key!�ϻȤ��ʤ�)
          ((not (rk-expect-key? rkc (charcode->string key)))
           (if (> (length (rk-context-seq rkc)) 0)
             (begin
               (cond
                 ((tutcode-verbose-stroke-key? key key-state)
                   (tutcode-commit pc (rk-pending rkc) #f #t))
                 (tutcode-keep-illegal-sequence?
                   (tutcode-commit pc (rk-pending rkc) #f #t)
                   (tutcode-commit-raw pc key key-state)))
               (rk-flush rkc))
             ;; ñ�ȤΥ�������(TUT-Code���ϤǤʤ���)
             (tutcode-commit-raw pc key key-state)))
          (else
           (let ((res (tutcode-push-key! pc (charcode->string key))))
            (cond
              ((string? res)
                (tutcode-commit pc res #f (not (tutcode-kigou2-mode? pc)))
                (if (and tutcode-use-completion?
                         (> tutcode-completion-chars-min 0))
                  (tutcode-check-completion pc #f 0)))
              ((symbol? res)
                (case res
                  ((tutcode-mazegaki-start)
                    (tutcode-context-set-latin-conv! pc #f)
                    (tutcode-context-set-postfix-yomi-len! pc 0)
                    (tutcode-context-set-state! pc 'tutcode-state-yomi))
                  ((tutcode-latin-conv-start)
                    (tutcode-context-set-latin-conv! pc #t)
                    (tutcode-context-set-postfix-yomi-len! pc 0)
                    (tutcode-context-set-state! pc 'tutcode-state-yomi))
                  ((tutcode-kanji-code-input-start)
                    (tutcode-context-set-state! pc 'tutcode-state-code))
                  ((tutcode-bushu-start)
                    (tutcode-context-set-undo! pc ());�Ƶ�Ū��������Ѵ���undo��
                    (tutcode-context-set-state! pc 'tutcode-state-bushu)
                    (tutcode-append-string pc "��"))
                  ((tutcode-interactive-bushu-start)
                    (tutcode-context-set-prediction-nr! pc 0)
                    (tutcode-context-set-state! pc
                      'tutcode-state-interactive-bushu))
                  ((tutcode-history-start)
                    (tutcode-begin-history pc))
                  ((tutcode-undo)
                    (tutcode-undo pc))
                  ((tutcode-help)
                    (tutcode-help pc))
                  ((tutcode-help-clipboard)
                    (tutcode-help-clipboard pc))
                  ((tutcode-auto-help-redisplay)
                    (tutcode-auto-help-redisplay pc))
                  ((tutcode-postfix-bushu-start)
                    (tutcode-begin-postfix-bushu-conversion pc))
                  ((tutcode-postfix-mazegaki-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc #f #f #f))
                  ((tutcode-postfix-mazegaki-1-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 1 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-2-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 2 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-3-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 3 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-4-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 4 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-5-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 5 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-6-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 6 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-7-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 7 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-8-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 8 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-9-start)
                    (tutcode-begin-postfix-mazegaki-conversion pc 9 #t
                      tutcode-use-recursive-learning?))
                  ((tutcode-postfix-mazegaki-inflection-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc #f))
                  ((tutcode-postfix-mazegaki-inflection-1-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 1))
                  ((tutcode-postfix-mazegaki-inflection-2-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 2))
                  ((tutcode-postfix-mazegaki-inflection-3-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 3))
                  ((tutcode-postfix-mazegaki-inflection-4-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 4))
                  ((tutcode-postfix-mazegaki-inflection-5-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 5))
                  ((tutcode-postfix-mazegaki-inflection-6-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 6))
                  ((tutcode-postfix-mazegaki-inflection-7-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 7))
                  ((tutcode-postfix-mazegaki-inflection-8-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 8))
                  ((tutcode-postfix-mazegaki-inflection-9-start)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc 9))
                  ((tutcode-postfix-katakana-start)
                    (tutcode-begin-postfix-katakana-conversion pc #f))
                  ((tutcode-postfix-katakana-0-start)
                    (tutcode-begin-postfix-katakana-conversion pc 0))
                  ((tutcode-postfix-katakana-1-start)
                    (tutcode-begin-postfix-katakana-conversion pc 1))
                  ((tutcode-postfix-katakana-2-start)
                    (tutcode-begin-postfix-katakana-conversion pc 2))
                  ((tutcode-postfix-katakana-3-start)
                    (tutcode-begin-postfix-katakana-conversion pc 3))
                  ((tutcode-postfix-katakana-4-start)
                    (tutcode-begin-postfix-katakana-conversion pc 4))
                  ((tutcode-postfix-katakana-5-start)
                    (tutcode-begin-postfix-katakana-conversion pc 5))
                  ((tutcode-postfix-katakana-6-start)
                    (tutcode-begin-postfix-katakana-conversion pc 6))
                  ((tutcode-postfix-katakana-7-start)
                    (tutcode-begin-postfix-katakana-conversion pc 7))
                  ((tutcode-postfix-katakana-8-start)
                    (tutcode-begin-postfix-katakana-conversion pc 8))
                  ((tutcode-postfix-katakana-9-start)
                    (tutcode-begin-postfix-katakana-conversion pc 9))
                  ((tutcode-postfix-katakana-exclude-1)
                    (tutcode-begin-postfix-katakana-conversion pc -1))
                  ((tutcode-postfix-katakana-exclude-2)
                    (tutcode-begin-postfix-katakana-conversion pc -2))
                  ((tutcode-postfix-katakana-exclude-3)
                    (tutcode-begin-postfix-katakana-conversion pc -3))
                  ((tutcode-postfix-katakana-exclude-4)
                    (tutcode-begin-postfix-katakana-conversion pc -4))
                  ((tutcode-postfix-katakana-exclude-5)
                    (tutcode-begin-postfix-katakana-conversion pc -5))
                  ((tutcode-postfix-katakana-exclude-6)
                    (tutcode-begin-postfix-katakana-conversion pc -6))
                  ((tutcode-postfix-katakana-shrink-1)
                    (tutcode-postfix-katakana-shrink pc 1))
                  ((tutcode-postfix-katakana-shrink-2)
                    (tutcode-postfix-katakana-shrink pc 2))
                  ((tutcode-postfix-katakana-shrink-3)
                    (tutcode-postfix-katakana-shrink pc 3))
                  ((tutcode-postfix-katakana-shrink-4)
                    (tutcode-postfix-katakana-shrink pc 4))
                  ((tutcode-postfix-katakana-shrink-5)
                    (tutcode-postfix-katakana-shrink pc 5))
                  ((tutcode-postfix-katakana-shrink-6)
                    (tutcode-postfix-katakana-shrink pc 6))
                  ((tutcode-postfix-kanji2seq-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc #f))
                  ((tutcode-postfix-kanji2seq-1-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 1))
                  ((tutcode-postfix-kanji2seq-2-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 2))
                  ((tutcode-postfix-kanji2seq-3-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 3))
                  ((tutcode-postfix-kanji2seq-4-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 4))
                  ((tutcode-postfix-kanji2seq-5-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 5))
                  ((tutcode-postfix-kanji2seq-6-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 6))
                  ((tutcode-postfix-kanji2seq-7-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 7))
                  ((tutcode-postfix-kanji2seq-8-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 8))
                  ((tutcode-postfix-kanji2seq-9-start)
                    (tutcode-begin-postfix-kanji2seq-conversion pc 9))
                  ((tutcode-postfix-seq2kanji-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc #f))
                  ((tutcode-postfix-seq2kanji-1-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 1))
                  ((tutcode-postfix-seq2kanji-2-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 2))
                  ((tutcode-postfix-seq2kanji-3-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 3))
                  ((tutcode-postfix-seq2kanji-4-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 4))
                  ((tutcode-postfix-seq2kanji-5-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 5))
                  ((tutcode-postfix-seq2kanji-6-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 6))
                  ((tutcode-postfix-seq2kanji-7-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 7))
                  ((tutcode-postfix-seq2kanji-8-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 8))
                  ((tutcode-postfix-seq2kanji-9-start)
                    (tutcode-begin-postfix-seq2kanji-conversion pc 9))
                  ((tutcode-selection-mazegaki-start)
                    (tutcode-begin-selection-mazegaki-conversion pc))
                  ((tutcode-selection-mazegaki-inflection-start)
                    (tutcode-begin-selection-mazegaki-inflection-conversion pc))
                  ((tutcode-selection-katakana-start)
                    (tutcode-begin-selection-katakana-conversion pc))
                  ((tutcode-selection-kanji2seq-start)
                    (tutcode-begin-selection-kanji2seq-conversion pc))
                  ((tutcode-selection-seq2kanji-start)
                    (tutcode-begin-selection-seq2kanji-conversion pc))
                  ((tutcode-clipboard-seq2kanji-start)
                    (tutcode-begin-clipboard-seq2kanji-conversion pc))))
              ((procedure? res)
                (res 'tutcode-state-on pc))))))))))

;;; ���ַ���������Ѵ���Ԥ�
(define (tutcode-begin-postfix-bushu-conversion pc)
  (and-let*
    ((former-seq (tutcode-postfix-acquire-text pc 2))
     (res (and (>= (length former-seq) 2)
               (tutcode-bushu-convert (cadr former-seq) (car former-seq)))))
    (tutcode-postfix-commit pc res former-seq)
    (tutcode-check-auto-help-window-begin pc (list res) ())))

;;; ���ַ�/���ַ��Ѵ��γ����undo����
(define (tutcode-undo pc)
  (let ((undo (tutcode-context-undo pc)))
    (if (pair? undo)
      (let ((state (list-ref undo 0))
            (commit-len (list-ref undo 1))
            (data (list-ref undo 2)))
        (tutcode-postfix-delete-text pc commit-len)
        (case state
          ((tutcode-state-off) ; ���ַ��Ѵ�
            (tutcode-commit pc (string-list-concat data) #f #t))
          ((tutcode-state-converting)
            (tutcode-context-set-head! pc (list-ref data 0))
            (tutcode-context-set-latin-conv! pc (list-ref data 1))
            (tutcode-context-set-state! pc 'tutcode-state-yomi))
          ((tutcode-state-bushu)
            (tutcode-context-set-head! pc data)
            (tutcode-context-set-state! pc 'tutcode-state-bushu))
          ((tutcode-state-yomi)
            (tutcode-context-set-head! pc data)
            (tutcode-context-set-state! pc 'tutcode-state-yomi))
          ((tutcode-state-code)
            (tutcode-context-set-head! pc data)
            (tutcode-context-set-state! pc 'tutcode-state-code))
          )))))

;;; ���ַ�/���ַ��Ѵ��γ����undo���뤿��ν���
;;; @param state �Ѵ��μ���('tutcode-state-converting)
;;; @param commit-str ����ʸ����
;;; @param data �������ξ��֤�Ƹ�����Τ�ɬ�פʾ���
(define (tutcode-undo-prepare pc state commit-str data)
  (let ((commit-len (length (string-to-list commit-str))))
    ;; XXX: ¿��undo��̤�б�
    (tutcode-context-set-undo! pc (list state commit-len data))))

;;; ���ַ��Ѵ�����ꤹ��
;;; @param str ���ꤹ��ʸ����
;;; @param yomi-list �Ѵ�����ʸ����(�ɤ�/����)�Υꥹ��(�ս�)
(define (tutcode-postfix-commit pc str yomi-list)
  ;; Firefox�Ǻ�����֤������Τ���򤹤뤿��preedit��clear���Ƥ���delete-text
  (im-clear-preedit pc)
  (im-update-preedit pc)
  (tutcode-postfix-delete-text pc (length yomi-list))
  (tutcode-commit pc str)
  (tutcode-undo-prepare pc 'tutcode-state-off str yomi-list))

;;; ���ַ��򤼽��Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;; @param autocommit? ���䤬1�Ĥξ��˼�ưŪ�˳��ꤹ�뤫�ɤ���
;;;  (yomi-len��#f�Ǥʤ�����ͭ��)
;;; @param recursive-learning? ���䤬̵�����˺Ƶ���Ͽ�⡼�ɤ����뤫�ɤ���
;;;  (yomi-len��#f�Ǥʤ�����ͭ��)
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-postfix-mazegaki-conversion pc yomi-len autocommit?
          recursive-learning?)
  (tutcode-context-set-mazegaki-yomi-len-specified! pc (or yomi-len 0))
  (let*
    ((former-seq (tutcode-postfix-mazegaki-acquire-yomi pc yomi-len))
     (former-len (length former-seq)))
    (if yomi-len
      (and
        (>= former-len yomi-len)
        (let ((yomi (take former-seq yomi-len)))
          (tutcode-context-set-postfix-yomi-len! pc yomi-len)
          (if (> yomi-len (length (tutcode-context-mazegaki-yomi-all pc)))
            (tutcode-context-set-mazegaki-yomi-all! pc yomi))
          (tutcode-begin-conversion pc yomi () autocommit? recursive-learning?)))
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ����ɤߤ�̤�ʤ����Ѵ�
      (and
        (> former-len 0)
        (begin
          (tutcode-context-set-postfix-yomi-len! pc former-len)
          (tutcode-context-set-mazegaki-yomi-all! pc former-seq)
          (tutcode-mazegaki-relimit-right pc former-seq #f))))))

;;; �ɤߤ�̤�ʤ���򤼽��Ѵ���Ԥ���
;;; ���Ѥ��ʤ���Ȥ��Ƹ������Ƥ���䤬���Ĥ���ʤ����ϡ�
;;; ���Ѥ����Ȥ��Ƹ������ߤ롣
;;; @param yomi �Ѵ��оݤ��ɤ�(ʸ����εս�ꥹ��)
;;; @param relimit-first? (�ǽ�μ��񸡺�����)����ɤߤ�̤��
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-mazegaki-relimit-right pc yomi relimit-first?)
  (or
    (and
      (not relimit-first?)
      (tutcode-begin-conversion pc yomi () #f #f))
    ;; ���䤬���Ĥ���ʤ��ä�
    (or
      (and
        (> (length yomi) 1)
        (> (tutcode-context-postfix-yomi-len pc) 0) ;���ַ��ξ��ϲ��⤷�ʤ�
        (begin ; �ɤߤ�1ʸ�����餷�ƺƸ���
          (tutcode-context-set-postfix-yomi-len! pc (- (length yomi) 1))
          (tutcode-mazegaki-relimit-right pc (drop-right yomi 1) #f)))
      (and tutcode-mazegaki-enable-inflection? ; ���Ѥ����θ����˰ܹ�
        (not (tutcode-mazegaki-inflection? yomi)) ; ����Ū�������Ͻ�ʣ�����ʤ�
        (let*
          ((len-specified (tutcode-context-mazegaki-yomi-len-specified pc))
           (len
            (if (> len-specified 0)
              len-specified
              (length (tutcode-context-mazegaki-yomi-all pc)))))
          (tutcode-mazegaki-inflection-relimit-right pc len len #f))))))

;;; �ɤߤ򿭤Ф��ʤ�����ַ��򤼽��Ѵ���Ԥ���
;;; @param yomi-len ���������ɤߤ�Ĺ��
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-postfix-mazegaki-relimit-left pc yomi-len)
  (and
    (<= yomi-len tutcode-mazegaki-yomi-max)
    (let*
      ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
       (yomi-all-len (length yomi-all)))
      (if (<= yomi-len yomi-all-len)
        (let ((yomi (take yomi-all yomi-len)))
          (tutcode-context-set-postfix-yomi-len! pc yomi-len)
          (or
            (tutcode-begin-conversion pc yomi () #f #f)
            (tutcode-postfix-mazegaki-relimit-left pc (+ yomi-len 1))))
        ;; �����Ѥ��ɤߤ�­��ʤ��ʤä���硢��¤�yomi-maxĹ���ɤߤ����
        (and
          (< yomi-all-len tutcode-mazegaki-yomi-max)
          (let ((former-seq (tutcode-postfix-mazegaki-acquire-yomi pc
                             tutcode-mazegaki-yomi-max)))
            (and
              (> (length former-seq) yomi-all-len)
              (begin
                (tutcode-context-set-mazegaki-yomi-all! pc former-seq)
                (tutcode-postfix-mazegaki-relimit-left pc yomi-len)))))))))

;;; ���ꤵ�줿�ɤߤ������Ѥ���줫�ɤ������֤�
;;; @param head �оݤ��ɤ�
;;; @return #t:���Ѥ����ξ�硣#f:����ʳ��ξ�硣
(define (tutcode-mazegaki-inflection? head)
  (and
    (pair? head)
    (string=? "��" (car head))))

;;; ���Ѥ����Ȥ��Ƹ��ַ��򤼽��Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-postfix-mazegaki-inflection-conversion pc yomi-len)
  (tutcode-context-set-mazegaki-yomi-len-specified! pc (or yomi-len 0))
  (let*
    ((former-seq (tutcode-postfix-mazegaki-acquire-yomi pc yomi-len))
     (former-len (length former-seq)))
    (if yomi-len
      (and
        (>= former-len yomi-len)
        (let ((yomi (take former-seq yomi-len)))
          (tutcode-context-set-postfix-yomi-len! pc yomi-len)
          (tutcode-context-set-mazegaki-yomi-all! pc yomi)
          (if (tutcode-mazegaki-inflection? yomi)
            ;; ����Ū��"��"�դ������Ϥ��줿��硢���Ѥ��ʤ���Ȥ��Ƹ�������
            ;; (���Ѥ����Ȥ��Ƽ�갷�����ϡ�"��"�ΰ��֤�Ĵ�����ʤ���
            ;;  ����������ˤʤ뤬������Ū�˻��ꤵ��Ƥ�����ϰ���Ĵ������)
            (tutcode-begin-conversion pc yomi () #t
              tutcode-use-recursive-learning?)
            (tutcode-mazegaki-inflection-relimit-right pc
              yomi-len yomi-len #f))))
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ����ɤ�/�촴��̤�ʤ����Ѵ�
      (and
        (> former-len 0)
        ;; �촴��Ĺ����Τ�ͥ�褷���Ѵ�
        (begin
          (tutcode-context-set-postfix-yomi-len! pc former-len)
          (tutcode-context-set-mazegaki-yomi-all! pc former-seq)
          (if (tutcode-mazegaki-inflection? former-seq) ; ����Ū"��"
            (tutcode-mazegaki-relimit-right pc former-seq #f)
            (tutcode-mazegaki-inflection-relimit-right pc
              former-len former-len #f)))))))

;;; ���Ѥ����θ򤼽��Ѵ��Τ��ᡢ
;;; �ɤ�/�촴��̤�ʤ��顢�촴����Ĺ�Ȥʤ��ɤߤ򸫤Ĥ����Ѵ���Ԥ���
;;; @param yomi-cur-len yomi-all�Τ����Ǹ����Ѵ��оݤȤʤäƤ����ɤߤ�Ĺ��
;;; @param len �����оݤȤ���촴��Ĺ��
;;; @param relimit-first? (�ǽ�μ��񸡺�����)����ɤߤ�̤�뤫�ɤ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-mazegaki-inflection-relimit-right pc yomi-cur-len len
          relimit-first?)
  (and
    (> len 0)
    (let*
      ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
       (len-specified (tutcode-context-mazegaki-yomi-len-specified pc)))
      (or
        ;; �촴��Ĺ��(len=length head)���ݻ������ޤޡ��ɤߤ�̤�ʤ��鸡��
        (let loop
          ((yomi-cur (take yomi-all yomi-cur-len))
           (skip-search? relimit-first?))
          (let* ((yomi-len (length yomi-cur))
                 (suffix-len (- yomi-len len)))
            (and
              (>= suffix-len 0)
              (or
                (and
                  (not skip-search?)
                  (<= suffix-len tutcode-mazegaki-suffix-max)
                  (receive (suffix head) (split-at yomi-cur suffix-len)
                    (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
                      (tutcode-context-set-postfix-yomi-len! pc yomi-len))
                    (tutcode-begin-conversion pc (cons "��" head) suffix #f #f)))
                (and
                  (= len-specified 0)
                  ;; �ɤߤ�1ʸ���̤�Ƹ���
                  (loop (drop-right yomi-cur 1) #f))))))
        ;; �촴��1ʸ���̤�Ƹ���
        (tutcode-mazegaki-inflection-relimit-right pc
          (if (> len-specified 0)
            len-specified
            (length yomi-all))
          (- len 1) #f)))))

;;; ���Ѥ����θ򤼽��Ѵ��Τ��ᡢ
;;; �ɤ�/�촴�򿭤Ф��ʤ��顢�촴����Ĺ�Ȥʤ��ɤߤ򸫤Ĥ����Ѵ���Ԥ���
;;; @param yomi-cur-len yomi-all�Τ����Ǹ����Ѵ��оݤȤʤäƤ����ɤߤ�Ĺ��
;;; @param len �����оݤȤ���촴��Ĺ��
;;; @param relimit-first? (�ǽ�μ��񸡺�����)����ɤߤ򿭤Ф�
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-mazegaki-inflection-relimit-left pc yomi-cur-len len
          relimit-first?)
  (let*
    ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (yomi-all-len (length yomi-all))
     (len-specified (tutcode-context-mazegaki-yomi-len-specified pc)))
    (or
      (and
        (<= len yomi-all-len)
        (or
          (let loop
            ((yomi-len yomi-cur-len)
             (skip-search? relimit-first?))
            ;; �촴��Ĺ��(len=length head)���ݻ������ޤ��ɤߤ򿭤Ф��ʤ��鸡��
            (and
              (<= len yomi-len yomi-all-len)
              (or
                (and
                  (not skip-search?)
                  (<= (- yomi-len len) tutcode-mazegaki-suffix-max)
                  (receive (suffix head)
                           (split-at (take yomi-all yomi-len) (- yomi-len len))
                    (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
                      (tutcode-context-set-postfix-yomi-len! pc yomi-len))
                    (tutcode-begin-conversion pc
                      (cons "��" head) suffix #f #f)))
                ;; �ɤߤ�1ʸ�����Ф��Ƹ���
                (and
                  (= len-specified 0)
                  (loop (+ yomi-len 1) #f)))))
          ;; �촴��1ʸ�����Ф��Ƹ���
          (tutcode-mazegaki-inflection-relimit-left pc
            (if (> len-specified 0)
              yomi-cur-len
              (+ len 1)) ; ��Ĺ��θ촴����Ƥ��ɤߤκ�ûĹ
            (+ len 1) #f)))
      ;; ����˿��Ф����ϡ����Ѥ��ʤ���θ����˰ܹ�
      (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
        (let ((len-new (if (> len-specified 0) len-specified 1)))
          (tutcode-postfix-mazegaki-relimit-left pc len-new))
        ;; ���ַ�
        (tutcode-begin-conversion pc yomi-all () #f #f)))))

;;; �򤼽��Ѵ����relimit-right�������ϻ��ν�����Ԥ�:
;;; �ɤ�/�촴��̤�ƺƸ���
(define (tutcode-mazegaki-proc-relimit-right pc)
  (tutcode-reset-candidate-window pc)
  (let*
    ((head (tutcode-context-head pc))
     (head-len (length head))
     (postfix-yomi-len (tutcode-context-postfix-yomi-len pc))
     (yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (inflection?
      (and (tutcode-mazegaki-inflection? head)
           (not (tutcode-mazegaki-inflection? yomi-all)))) ; ����Ū"��"
     (found?
      (if (not inflection?)
        (tutcode-mazegaki-relimit-right pc head #t)
        (tutcode-mazegaki-inflection-relimit-right pc
          (+ (- head-len 1)
             (length (tutcode-context-mazegaki-suffix pc)))
          (- head-len 1) #t)))) ; (car head)��"��"
    (if (not found?) ; ����̵�����ɤ�/�촴��̤��Τ����
      (tutcode-context-set-postfix-yomi-len! pc postfix-yomi-len))))

;;; �򤼽��Ѵ����relimit-left�������ϻ��ν�����Ԥ�:
;;; �ɤ�/�촴�򿭤Ф��ƺƸ���
(define (tutcode-mazegaki-proc-relimit-left pc)
  (tutcode-reset-candidate-window pc)
  (let*
    ((head (tutcode-context-head pc))
     (head-len (length head))
     (postfix-yomi-len (tutcode-context-postfix-yomi-len pc))
     (yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (inflection?
      (and (tutcode-mazegaki-inflection? head)
           (not (tutcode-mazegaki-inflection? yomi-all)))) ; ����Ū"��"
     (found?
      (if (not inflection?)
        (and (> postfix-yomi-len 0) ; ���ַ��ξ����ɤߤ򿭤Ф�
             (tutcode-postfix-mazegaki-relimit-left pc (+ head-len 1)))
        (tutcode-mazegaki-inflection-relimit-left pc
          (+ (- head-len 1)
             (length (tutcode-context-mazegaki-suffix pc)))
          (- head-len 1) #t)))) ; (car head)��"��"
    (if (not found?) ; ����̵�����ɤ�/�촴�򿭤Ф��Τ����
      (tutcode-context-set-postfix-yomi-len! pc postfix-yomi-len))))

;;; ASCIIʸ�����ɤ������֤�
;;; @param str ʸ����
(define (tutcode-ascii? str)
  (let ((ch (string->ichar str)))
    (and ch (<= ch 127))))

;;; ���ַ��򤼽��Ѵ��Ѥ��ɤߤ��������
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;; @return ���������ɤ�(ʸ����εս�ꥹ��)
(define (tutcode-postfix-mazegaki-acquire-yomi pc yomi-len)
  (let ((former-seq (tutcode-postfix-acquire-text pc
                     (or yomi-len tutcode-mazegaki-yomi-max))))
    (if yomi-len
      ;; XXX:�ɤߤ�ʸ���������ꤵ��Ƥ������"��"����ޤ�롣relimit-left
      ;;     ��ͳ�ξ���桼��������Ū�˻��ꤷ����ΤȤߤʤ���Ʊ�ͤ˴ޤ�롣
      former-seq
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ��������Ǥ���ʸ�������(���yomi-max)��
      (let ((last-ascii? (and (pair? former-seq)
                              (tutcode-ascii? (car former-seq)))))
        (take-while
          (lambda (elem)
            (and
              ;; ���ܸ�ʸ����ASCIIʸ���ζ��ܤ�����С������ޤǤ��������
              (eq? (tutcode-ascii? elem) last-ascii?)
              ;; "��"��"��"������ʸ�����ɤߤ˴ޤ�ʤ���
              (not (member elem tutcode-postfix-mazegaki-terminate-char-list))))
          former-seq)))))

;;; �����ʸ������������
;;; @param len ��������ʸ����
;;; @return ��������ʸ����Υꥹ��(�ս�)
(define (tutcode-postfix-acquire-text pc len)
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (case (tutcode-context-child-type ppc)
        ((tutcode-child-type-dialog)
          ())
        ((tutcode-child-type-editor)
          (let*
            ((ec (tutcode-context-editor ppc))
             (left-string (tutcode-editor-left-string ec)))
            (if (> (length left-string) len)
              (take left-string len)
              left-string)))
        ((tutcode-child-type-seq2kanji)
          (let ((head (tutcode-context-head ppc)))
            (if (> (length head) len)
              (take head len)
              head))))
      (let*
        ((ustr (im-acquire-text pc 'primary 'cursor len 0))
         (former (and ustr (ustr-former-seq ustr)))
         (former-seq (and (pair? former) (string-to-list (car former)))))
        (if ustr
          (or former-seq ())
          ;; im-acquire-text̤�б��Ķ��ξ�硢�����γ����ʸ����Хåե������
          (if tutcode-enable-fallback-surrounding-text?
            (let ((commit-strs (tutcode-context-commit-strs pc)))
              (if (> (length commit-strs) len)
                (take commit-strs len)
                commit-strs))
            ()))))))

;;; �����ʸ�����������
;;; @param len �������ʸ����
(define (tutcode-postfix-delete-text pc len)
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (case (tutcode-context-child-type ppc)
        ((tutcode-child-type-editor)
          (let*
            ((ec (tutcode-context-editor ppc))
             (left-string (tutcode-editor-left-string ec)))
            (tutcode-editor-set-left-string! ec
              (if (> (length left-string) len)
                (drop left-string len)
                ()))))
        ((tutcode-child-type-seq2kanji)
          (let ((head (tutcode-context-head ppc)))
            (tutcode-context-set-head! ppc
              (if (> (length head) len)
                (drop head len)
                ())))))
      (or
        (im-delete-text pc 'primary 'cursor len 0)
        ;; im-delete-text̤�б��Ķ��ξ�硢"\b"�����롣
        ;; XXX:"\b"��ǧ������ʸ���������륢�ץ�Ǥʤ���ư��ʤ�
        ;; (tutcode-commit-raw�����Ϻѥ����򤽤Τޤޥ��ץ���Ϥ����Ȥ���ꤹ��
        ;;  ��ΤʤΤǡ��ʲ��Τ褦��backspace�����Ǹ��������ˤϻȤ��ʤ�
        ;;  (tutcode-commit-raw pc 'backspace 0))
        (and tutcode-enable-fallback-surrounding-text?
          (begin
            (let ((commit-strs (tutcode-context-commit-strs pc)))
              (tutcode-context-set-commit-strs! pc
                (if (> (length commit-strs) len)
                  (drop commit-strs len)
                  ())))
            (if (> (string-length tutcode-fallback-backspace-string) 0)
              (tutcode-commit pc
                (apply string-append
                  (make-list len tutcode-fallback-backspace-string))
                #t #t))))))))

;;; selection���Ф��Ƹ򤼽��Ѵ��򳫻Ϥ���
(define (tutcode-begin-selection-mazegaki-conversion pc)
  (let ((sel (tutcode-selection-acquire-text-wo-nl pc)))
    (if (pair? sel)
      (let ((sel-len (length sel)))
        (tutcode-context-set-mazegaki-yomi-len-specified! pc sel-len)
        (tutcode-context-set-postfix-yomi-len! pc (- sel-len)) ; ��:selection
        (tutcode-context-set-mazegaki-yomi-all! pc sel)
        (tutcode-begin-conversion pc sel () #t
          tutcode-use-recursive-learning?)))))

;;; selection���Ф��Ƴ��Ѥ����Ȥ��Ƹ򤼽��Ѵ��򳫻Ϥ���
(define (tutcode-begin-selection-mazegaki-inflection-conversion pc)
  (let ((sel (tutcode-selection-acquire-text-wo-nl pc)))
    (if (pair? sel)
      (let ((sel-len (length sel)))
        (tutcode-context-set-mazegaki-yomi-len-specified! pc sel-len)
        (tutcode-context-set-postfix-yomi-len! pc (- sel-len)) ; ��:selection
        (tutcode-context-set-mazegaki-yomi-all! pc sel)
        (if (tutcode-mazegaki-inflection? sel)
          (tutcode-begin-conversion pc sel () #t
            tutcode-use-recursive-learning?)
          (tutcode-mazegaki-inflection-relimit-right pc
            sel-len sel-len #f))))))

;;; selection���Ф��ƥ��������Ѵ��򳫻Ϥ���
(define (tutcode-begin-selection-katakana-conversion pc)
  (let ((sel (tutcode-selection-acquire-text pc)))
    (if (pair? sel)
      (let* ((katakana (tutcode-katakana-convert sel
                        (not (tutcode-context-katakana-mode? pc))))
             (str (string-list-concat katakana)))
        (tutcode-selection-commit pc str sel)
        (if (= (length katakana) 1) ; 1ʸ���ξ�硢��ư�إ��ɽ��(tc2��Ʊ��)
          (tutcode-check-auto-help-window-begin pc katakana ()))))))

;;; selection���Ф��ƴ��������ϥ��������Ѵ��򳫻Ϥ���
(define (tutcode-begin-selection-kanji2seq-conversion pc)
  (let ((sel (tutcode-selection-acquire-text pc)))
    (if (pair? sel)
      (tutcode-selection-commit pc
        (string-list-concat (tutcode-kanji-list->sequence pc sel)) sel))))

;;; selection���Ф������ϥ������󥹢������Ѵ��򳫻Ϥ���
(define (tutcode-begin-selection-seq2kanji-conversion pc)
  (let ((sel (tutcode-selection-acquire-text pc)))
    (if (pair? sel)
      (tutcode-selection-commit pc
        (string-list-concat (tutcode-sequence->kanji-list pc sel)) sel))))

;;; selection���Ф����Ѵ�����ꤹ��
;;; @param str ���ꤹ��ʸ����
;;; @param yomi-list �Ѵ�����ʸ����(�ɤ�/����)�Υꥹ��(�ս�)
(define (tutcode-selection-commit pc str yomi-list)
  ;; commit�����selection����񤭤����Τ�delete-text������
  ;(im-delete-text pc 'selection 'beginning 0 'full)
  (tutcode-commit pc str)
  (tutcode-undo-prepare pc 'tutcode-state-off str yomi-list))

;;; selectionʸ�������Ԥ�����Ƽ�������
;;; @return ��������ʸ����Υꥹ��(�ս�)
(define (tutcode-selection-acquire-text-wo-nl pc)
  (let ((latter-seq (tutcode-selection-acquire-text pc)))
    (and (pair? latter-seq)
         (delete "\n" latter-seq))))

;;; selectionʸ������������
;;; @return ��������ʸ����Υꥹ��(�ս�)
(define (tutcode-selection-acquire-text pc)
  (and-let*
    ((ustr (im-acquire-text pc 'selection 'beginning 0 'full))
     (latter (ustr-latter-seq ustr))
     (latter-seq (and (pair? latter) (string-to-list (car latter)))))
    (and (not (null? latter-seq))
         latter-seq)))

;;; ���ַ����������Ѵ�����ꤹ��
;;; @param yomi �ɤ�
;;; @param katakana �ɤߤ򥫥����ʤ��Ѵ�����ʸ����ꥹ��
;;; @param show-help? katakana��1ʸ���ξ��˼�ư�إ�פ�ɽ�����뤫�ɤ���
(define (tutcode-postfix-katakana-commit pc yomi katakana show-help?)
  (let ((str (string-list-concat katakana)))
    (tutcode-postfix-commit pc str yomi)
    (tutcode-flush pc)
    (if (and show-help?
             (= (length katakana) 1)) ; 1ʸ���ξ�硢��ư�إ��ɽ��(tc2��Ʊ��)
      (tutcode-check-auto-help-window-begin pc katakana ()))))

;;; ���ַ����������Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;;   0: �Ҥ餬�ʤ䡼��³���֥������ʤ��Ѵ����롣
;;;   �����: �����ͤ�ʸ������Ҥ餬�ʤȤ��ƻĤ��ƥ��������Ѵ���
;;;   (�������ʤ��Ѵ�����ʸ����Ĺ����ʸ�����������Τ����ݤʾ�����)
;;;   ���㤨�Ф��פꤱ��������j2�����㤨�Х��ץꥱ��������
(define (tutcode-begin-postfix-katakana-conversion pc yomi-len)
  (let*
    ((former-all (tutcode-postfix-katakana-acquire-yomi pc
      (if (and yomi-len (<= yomi-len 0)) #f yomi-len)))
     (former-seq
      (cond
        ((not yomi-len)
          former-all)
        ((>= yomi-len 0)
          former-all)
        (else
          (let ((len (- yomi-len)))
            (if (<= (length former-all) len)
              ()
              (drop-right former-all len)))))))
    (if yomi-len
      (let ((katakana (tutcode-katakana-convert former-seq
                        (not (tutcode-context-katakana-mode? pc)))))
        (tutcode-postfix-katakana-commit pc former-seq katakana #t))
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ�
      (if (pair? former-seq)
        (begin
          (tutcode-context-set-mazegaki-yomi-all! pc former-all)
          (tutcode-context-set-head! pc
            (tutcode-katakana-convert former-seq
              (not (tutcode-context-katakana-mode? pc))))
          (tutcode-context-set-state! pc 'tutcode-state-postfix-katakana))))))

;;; ľ���θ��ַ����������Ѵ���̤��
;;; @param count �̤��ʸ����
(define (tutcode-postfix-katakana-shrink pc count)
  (let ((undo (tutcode-context-undo pc)))
    (if (and (pair? undo)
             (eq? (list-ref undo 0) 'tutcode-state-off)) ; ���ַ��Ѵ�
      (let* ((commit-len (list-ref undo 1))
             (yomi (list-ref undo 2))
             (yomi-len (length yomi)))
        (tutcode-postfix-delete-text pc commit-len)
        (receive (kata hira)
          (if (< count yomi-len)
            (split-at yomi (- yomi-len count))
            (values () yomi))
          (let ((str (string-list-concat
                      (append
                        (tutcode-katakana-convert kata
                          (not (tutcode-context-katakana-mode? pc)))
                        hira))))
            (tutcode-commit pc str)
            ;; shrink�򷫤��֤����ݤ�countʸ�����ĥ������ʤ�̤����褦��
            (tutcode-undo-prepare pc 'tutcode-state-off
              (string-list-concat kata) kata)))))))

;;; ���ַ����������Ѵ����о�ʸ������������
;;; @param yomi-len ���ꤵ�줿ʸ���������ꤵ��Ƥʤ�����#f��
;;; @return ��������ʸ����(ʸ����εս�ꥹ��)
(define (tutcode-postfix-katakana-acquire-yomi pc yomi-len)
  (let ((former-seq (tutcode-postfix-acquire-text pc
                     (or yomi-len tutcode-mazegaki-yomi-max))))
    (if yomi-len
      former-seq
      (let ((hira (take-while
                    (lambda (char)
                      (tutcode-postfix-katakana-acquire-char? pc char))
                    former-seq)))
        ;; �֥����ȤФ�塼�פ��Ф��ơ�1ʸ���Ĥ��ƥ��������Ѵ���
        ;; �֥����ȥХ�塼�פˤʤ�褦�ˡ��Ҥ餬���󤬡֡��פǻϤޤ���Ͻ���
        (reverse
          (drop-while
            (lambda (char)
              (member char tutcode-postfix-katakana-char-list))
            (reverse hira)))))))

;;; ���ַ����������Ѵ��о�ʸ��(�Ҥ餬�ʡ���)���ɤ������֤�
(define (tutcode-postfix-katakana-acquire-char? pc char)
  (or (if (tutcode-context-katakana-mode? pc)
        (tutcode-katakana? char) ; �������ʥ⡼�ɻ��ϥ��������о�
        (tutcode-hiragana? char))
      (member char tutcode-postfix-katakana-char-list)))

;;; �Ҥ餬�ʤ��ɤ���
(define (tutcode-hiragana? s)
  (and (string>=? s "��") (string<=? s "��")))
;;; �������ʤ��ɤ���
(define (tutcode-katakana? s)
  (and (string>=? s "��") (string<=? s "��")))

;;; ���ַ����������Ѵ��⡼�ɻ��Υ������Ϥ�������롣
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-postfix-katakana c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (head (tutcode-context-head pc)))
    (cond
      ((tutcode-cancel-key? key key-state)
        (tutcode-flush pc))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (tutcode-postfix-katakana-commit pc
          (take (tutcode-context-mazegaki-yomi-all pc) (length head))
          head #t))
      ((tutcode-mazegaki-relimit-right-key? key key-state)
        (if (> (length head) 1)
          (tutcode-context-set-head! pc (drop-right head 1))))
      ((tutcode-mazegaki-relimit-left-key? key key-state)
        (let ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
              (cur-len (length head)))
          (if (> (length yomi-all) cur-len)
            (tutcode-context-set-head! pc
              (tutcode-katakana-convert
                (take yomi-all (+ cur-len 1))
                (not (tutcode-context-katakana-mode? pc)))))))
      (else
        (tutcode-postfix-katakana-commit pc
          (take (tutcode-context-mazegaki-yomi-all pc) (length head))
          head #f)
        (tutcode-proc-state-on pc key key-state)))))

;;; �����Υꥹ�Ȥ����ϥ������󥹤��Ѵ����롣
;;; �������Ϥ�ü���뤿������Ϥ��줿;ʬ��verbose-stroke-key�Ϻ�������֤���
;;; @param kanji-list ����ʸ����ꥹ��(�ս�)
;;; @return ���ϥ�������ʸ����ꥹ��(�ս�)��
;;;  ���Υ������󥹤����Ϥ����kanji-list����������롣
;;;XXX:������ɽ�ˡ�����������Ф���ʣ���Υ������󥹤������硢�ǽ�Τ�Τ����
;;;    ����������������ʸ������⤢���硢��ʸ���������󥹤��Ȥ��롣
;;;    ��:"CODE "���Ǹ���"COD��"��ɽ�������������ϥ��������Ѵ������"CODe "
(define (tutcode-kanji-list->sequence pc kanji-list)
  (let*
    ((rule (rk-context-rule (tutcode-context-rk-context pc)))
     (allseq
      (append-map
        (lambda (x)
          (let ((seq (tutcode-reverse-find-seq x rule)))
            ;; ľ�����ϤǤ��ʤ����ϴ����Τޤ�(XXX:���������ˡ�ޤ�ɽ��?)
            (if seq (reverse seq) (list x))))
        kanji-list)))
    ;; �Ǹ��verbose-stroke-key(��:":")�ϴ������Ϥ�ü���뤿��
    ;; ;ʬ�����Ϥ��줿��ǽ��������ΤǺ��
    ;; ��: "undo:"��"��o"��("o" "��")��"code:"��"���:"��(":" "��" "��")
    (if (and (pair? allseq)
             (tutcode-verbose-stroke-key? (string->ichar (car allseq)) 0))
      (cdr allseq)
      allseq)))

;;; ���ַ��δ��������ϥ��������Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;;  0�ξ��ϡ�#f��Ʊ�ͤ˰��������о�ʸ��������⡼�ɤ����餺�������˳��ꡣ
(define (tutcode-begin-postfix-kanji2seq-conversion pc yomi-len)
  (let*
    ((former-all (tutcode-postfix-acquire-text pc
      (if (and yomi-len (> yomi-len 0)) yomi-len tutcode-mazegaki-yomi-max)))
     (former-seq
      (if (and yomi-len (> yomi-len 0))
        former-all
        (let*
          ;; verbose-stroke-key��" "(�ǥե����)�ξ�硢;ʬ�����Ϥ���Ƥ��
          ;; ����take����ʤ��Τǡ�;ʬ��verbose-stroke-key�ϥ����åס�
          ;; (tutcode-kanji-list->sequence��;ʬ��verbose-stroke-key����)
          ;; ��:"undo "��"��"��("��" "��")��"code "��"��� "��(" " "��" "��")
          ((first (safe-car former-all))
           (first-verbose-key?
            (tutcode-verbose-stroke-key? (and first (string->ichar first)) 0))
           (rest (if first-verbose-key? (cdr former-all) former-all))
           (seq
            (take-while
              (lambda (elem)
                (not (member elem
                      (append tutcode-postfix-kanji2seq-delimiter-char-list
                        '("\n" "\t")))))
              rest)))
          (if first-verbose-key?
            (cons first seq) ; delete-text����Ĺ�����碌�뤿��first�������
            seq)))))
    (if yomi-len
      (let ((seq (tutcode-kanji-list->sequence pc former-seq)))
        (tutcode-postfix-commit pc (string-list-concat seq) former-seq))
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ�
      (if (pair? former-seq)
        (begin
          (tutcode-context-set-mazegaki-yomi-all! pc former-all)
          (tutcode-context-set-postfix-yomi-len! pc (length former-seq))
          (tutcode-context-set-head! pc
            (tutcode-kanji-list->sequence pc former-seq))
          (tutcode-context-set-state! pc 'tutcode-state-postfix-kanji2seq))))))

;;; ���ַ��δ��������ϥ��������Ѵ��⡼�ɻ��Υ������Ϥ�������롣
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-postfix-kanji2seq c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (head (tutcode-context-head pc))
     (yomi-len (tutcode-context-postfix-yomi-len pc))
     (yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (update-context!
      (lambda (new-yomi-len)
        (tutcode-context-set-postfix-yomi-len! pc new-yomi-len)
        (tutcode-context-set-head! pc
          (tutcode-kanji-list->sequence pc (take yomi-all new-yomi-len)))))
     (commit
      (lambda ()
        (let*
          ((len (if (and tutcode-delete-leading-delimiter-on-postfix-kanji2seq?
                         (> (length yomi-all) yomi-len)
                         (member (list-ref yomi-all yomi-len)
                          tutcode-postfix-kanji2seq-delimiter-char-list))
                  (+ yomi-len 1)
                  yomi-len))
           (yomi (take yomi-all len)))
          (tutcode-postfix-commit pc (string-list-concat head) yomi)
          (tutcode-flush pc)))))
    (cond
      ((tutcode-cancel-key? key key-state)
        (tutcode-flush pc))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (commit))
      ((tutcode-mazegaki-relimit-right-key? key key-state)
        (if (> yomi-len 1)
          (update-context! (- yomi-len 1))))
      ((tutcode-mazegaki-relimit-left-key? key key-state)
        (if (> (length yomi-all) yomi-len)
          (update-context! (+ yomi-len 1))))
      (else
        (commit)
        (tutcode-proc-state-on pc key key-state)))))

;;; ���ϥ����������󥹤�������Ѵ�����
;;; @param sequence ���ϥ����������󥹡�ʸ����Υꥹ��(�ս�)
;;; @return �Ѵ���δ���ʸ����Υꥹ��(�ս�)
(define (tutcode-sequence->kanji-list pc sequence)
  (if (null? sequence)
    ()
    (let ((string->key-and-status
            (lambda (s)
              (let ((ch (string->ichar s)))
                (cond
                  ;; key-press-handler���Ϥ����ᡢsymbol���Ѵ�(uim-key.c)
                  ;; (tutcode-return-key?���ǥޥå�����褦�ˤ��뤿��)
                  ((not (integer? ch)) (cons ch 0)) ; s�������ξ��ch��#f
                  ((= ch 8) '(backspace . 0))
                  ((= ch 9) '(tab . 0))
                  ((= ch 10) '(return . 0))
                  ((= ch 27) '(escape . 0))
                  ((= ch 127) '(delete . 0))
                  ((ichar-control? ch)
                    (cons (ichar-downcase (+ ch 64)) 2)) ; ex. "<Control>j"
                  ((ichar-upper-case? ch)
                    ;; key-predicate�Ѥ�shift-key-mask��set��
                    ;; downcase�����rule�Ȱ��פ��ʤ��ʤ�ΤǤ��Τޤޡ�
                    (cons ch 1))
                  (else (cons ch 0))))))
          (key? (lambda (k) (or (integer? k) (key-symbol? k))))
          (commit-pending-rk
            (lambda (c)
              (let ((rkc (tutcode-context-rk-context c)))
                (if (pair? (rk-context-seq rkc))
                  (tutcode-commit c (rk-pending rkc) #f #t)))))
          (head-save (tutcode-context-head pc))
          ;; ����Ū�������Τ߰�̣�Τ���إ��ɽ�����ϰ��Ū�˥��դˤ���
          ;; (�䴰/ͽ¬���ϤϤҤ�äȤ��ƻȤ����⤷��ʤ��ΤǤ��Τޤ�)
          (use-candwin-save tutcode-use-candidate-window?)
          (use-stroke-help-win-save tutcode-use-stroke-help-window?)
          (use-auto-help-win-save tutcode-use-auto-help-window?)
          (use-kanji-combination-guide-save tutcode-use-kanji-combination-guide?)
          (stroke-help-with-guide-save
            tutcode-stroke-help-with-kanji-combination-guide)
          ;; child context���äƤ�����key-press�򿩤碌��
          (cpc (tutcode-setup-child-context pc 'tutcode-child-type-seq2kanji)))
      (tutcode-context-set-head! pc ()) ; ��context�Ǥ�commit��head�ˤ����
      (set! tutcode-use-candidate-window? #f)
      (set! tutcode-use-stroke-help-window? #f)
      (set! tutcode-use-auto-help-window? #f)
      (set! tutcode-use-kanji-combination-guide? #f)
      (set! tutcode-stroke-help-with-kanji-combination-guide 'disable)
      (for-each
        (lambda (s)
          (let ((k-s (string->key-and-status s)))
            (if (key? (car k-s))
              (tutcode-key-press-handler-internal cpc (car k-s) (cdr k-s))
              (begin ; �����Ϥ��Τޤ�
                (commit-pending-rk cpc)
                (tutcode-flush cpc)
                (tutcode-commit cpc s)))))
        (reverse sequence))
      (commit-pending-rk cpc) ; �Ǿ�̤�pending�Τ߳��ꡣ�ä���Ȥ��줷���ʤ�
      ;; XXX:�����ϳ����ʸ����Τ߼�����̤����ʸ����Ͼä���
      (let ((kanji-list (tutcode-context-head pc)))
        (tutcode-flush cpc)
        (tutcode-context-set-child-context! pc ())
        (tutcode-context-set-child-type! pc ())
        (tutcode-context-set-head! pc head-save)
        (set! tutcode-use-candidate-window? use-candwin-save)
        (set! tutcode-use-stroke-help-window? use-stroke-help-win-save)
        (set! tutcode-use-auto-help-window? use-auto-help-win-save)
        (set! tutcode-use-kanji-combination-guide?
          use-kanji-combination-guide-save)
        (set! tutcode-stroke-help-with-kanji-combination-guide
          stroke-help-with-guide-save)
        kanji-list))))

;;; �ҥ���ƥ����ȤǤ�commit
;;; @param str commit���줿ʸ����
(define (tutcode-seq2kanji-commit-from-child pc str)
  (tutcode-context-set-head! pc
    (append (string-to-list str) (tutcode-context-head pc))))

;;; �ҥ���ƥ����ȤǤ�commit-raw
(define (tutcode-seq2kanji-commit-raw-from-child pc key key-state)
  (let ((raw-str
          (im-get-raw-key-str
            (cond
              ;; tutcode-sequence->kanji-list���Ѵ�����symbol����charcode���᤹
              ((eq? key 'backspace) 8)
              ((eq? key 'tab) 9)
              ((eq? key 'return) 10)
              ((eq? key 'escape) 27)
              ((eq? key 'delete) 127)
              ((control-key-mask key-state)
                (- (ichar-upcase key) 64))
              ((shift-key-mask key-state)
                (ichar-upcase key))
              (else key))
            0)))
    (if raw-str
      (tutcode-seq2kanji-commit-from-child pc raw-str))))

;;; ���ַ������ϥ������󥹢������Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
(define (tutcode-begin-postfix-seq2kanji-conversion pc yomi-len)
  (let*
    ((former-all (tutcode-postfix-acquire-text pc
                  (or yomi-len tutcode-mazegaki-yomi-max)))
     (former-seq
      (if yomi-len
        former-all
        ;; ��Ƭ�ξ�硢�򤼽��Ѵ��γ����β�ǽ��������Τǡ����Ԥ�ޤ��
        (receive
          (newlines rest)
          (span
            (lambda (x)
              (string=? x "\n"))
            former-all)
          (append newlines
            (take-while
              (lambda (elem)
                (and (tutcode-ascii? elem)
                     (not (string=? elem "\n"))))
              rest))))))
    (if (pair? former-seq)
      (let ((kanji-list (tutcode-sequence->kanji-list pc former-seq)))
        (if yomi-len
          (begin
            (tutcode-postfix-commit pc
              (string-list-concat kanji-list) former-seq)
            (tutcode-flush pc))
          ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ�
          (begin
            (tutcode-context-set-mazegaki-yomi-all! pc former-all)
            (tutcode-context-set-postfix-yomi-len! pc (length former-seq))
            (tutcode-context-set-head! pc kanji-list)
            (tutcode-context-set-state! pc
              'tutcode-state-postfix-seq2kanji)))))))

;;; ���ַ������ϥ������󥹢������Ѵ��⡼�ɻ��Υ������Ϥ�������롣
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-postfix-seq2kanji c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (yomi-len (tutcode-context-postfix-yomi-len pc))
     (yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (update-context!
      (lambda (new-yomi-len)
        (tutcode-context-set-postfix-yomi-len! pc new-yomi-len)
        (tutcode-context-set-head! pc
          (tutcode-sequence->kanji-list pc (take yomi-all new-yomi-len)))))
     (commit
      (lambda ()
        (tutcode-postfix-commit pc
          (string-list-concat (tutcode-context-head pc))
          (take yomi-all yomi-len))
        (tutcode-flush pc))))
    (cond
      ((tutcode-cancel-key? key key-state)
        (tutcode-flush pc))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (commit))
      ((tutcode-mazegaki-relimit-right-key? key key-state)
        (if (> yomi-len 1)
          ;; ���ַ��򤼽񤭤ǳ��ꤵ��Ƥ��ʤ�ʸ����������ʤɡ�
          ;; relimit-right������Ѵ���ʸ���󤬿��Ӥ��礢�ꡣ
          ;; ��:"aljrk"��"" > "ljrk"��"�ߤ�"
          (update-context! (- yomi-len 1))))
      ((tutcode-mazegaki-relimit-left-key? key key-state)
        (if (> (length yomi-all) yomi-len)
          (update-context! (+ yomi-len 1))))
      (else
        (commit)
        (tutcode-proc-state-on pc key key-state)))))

;;; ľ�����Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-off c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (cond
      ((tutcode-on-key? key key-state)
        (tutcode-context-set-state! pc 'tutcode-state-on))
      ((tutcode-off-key? key key-state) ; on-key��off-key���̥����ξ��
        ) ; ����on�Ǥ�off�Ǥ⡢off-key��off�ˤ����������ʤΤ�commit-raw�����
      (else
        (tutcode-commit-raw pc key key-state)))))

;;; �������ϥ⡼�ɻ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-kigou c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (cond
      ((and
        (tutcode-vi-escape-key? key key-state)
        tutcode-use-with-vi?)
       (tutcode-reset-candidate-window pc)
       (tutcode-context-set-state! pc 'tutcode-state-off)
       (tutcode-commit-raw pc key key-state)) ; ESC�����򥢥ץ�ˤ��Ϥ�
      ((tutcode-off-key? key key-state)
       (tutcode-reset-candidate-window pc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((tutcode-kigou-toggle-key? key key-state)
       (tutcode-reset-candidate-window pc)
       (tutcode-context-set-state! pc 'tutcode-state-on))
      ((tutcode-kigou2-toggle-key? key key-state)
       (tutcode-reset-candidate-window pc)
       (if (not (tutcode-kigou2-mode? pc))
         (tutcode-toggle-kigou2-mode pc))
       (tutcode-context-set-state! pc 'tutcode-state-on))
      ;; ���ڡ������������ѥ��ڡ������ϲ�ǽ�Ȥ��뤿�ᡢ
      ;; next-candidate-key?�Υ����å��������heading-label-char?������å�
      ((and (not (and (modifier-key-mask key-state)
                      (not (shift-key-mask key-state))))
            (tutcode-heading-label-char-for-kigou-mode? key)
            (tutcode-commit-by-label-key-for-kigou-mode pc
              (charcode->string key)))
        (if (eq? (tutcode-context-candidate-window pc)
                 'tutcode-candidate-window-kigou)
          (tutcode-select-candidate pc (tutcode-context-nth pc))))
      ((tutcode-next-candidate-key? key key-state)
        (tutcode-change-candidate-index pc 1))
      ((tutcode-prev-candidate-key? key key-state)
        (tutcode-change-candidate-index pc -1))
      ((tutcode-cancel-key? key key-state)
        (tutcode-reset-candidate-window pc)
        (tutcode-begin-kigou-mode pc))
      ((tutcode-next-page-key? key key-state)
        (tutcode-change-candidate-index pc
          tutcode-nr-candidate-max-for-kigou-mode))
      ((tutcode-prev-page-key? key key-state)
        (tutcode-change-candidate-index pc
          (- tutcode-nr-candidate-max-for-kigou-mode)))
      ((tutcode-commit-key? key key-state) ; return-key�ϥ��ץ���Ϥ�
        (tutcode-commit pc (tutcode-prepare-commit-string-for-kigou-mode pc)))
      (else
        (tutcode-commit-raw pc key key-state)))))

;;; �ҥ��ȥ����ϥ⡼�ɻ��Υ������Ϥ�������롣
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-history c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (cond
      ((tutcode-next-candidate-key? key key-state)
        (tutcode-change-candidate-index pc 1))
      ((tutcode-prev-candidate-key? key key-state)
        (tutcode-change-candidate-index pc -1))
      ((tutcode-next-page-key? key key-state)
        (tutcode-change-candidate-index pc
          tutcode-nr-candidate-max-for-history))
      ((tutcode-prev-page-key? key key-state)
        (tutcode-change-candidate-index pc
          (- tutcode-nr-candidate-max-for-history)))
      ((tutcode-cancel-key? key key-state)
        (tutcode-flush pc))
      ((and (not (and (modifier-key-mask key-state)
                      (not (shift-key-mask key-state))))
            (tutcode-heading-label-char-for-history? key)
            (tutcode-commit-by-label-key-for-history pc
              (charcode->string key))))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (let ((str (tutcode-prepare-commit-string-for-history pc)))
          (tutcode-commit pc str)
          (tutcode-flush pc)
          (tutcode-check-auto-help-window-begin pc (string-to-list str) ())))
      (else
        (tutcode-commit pc (tutcode-prepare-commit-string-for-history pc))
        (tutcode-flush pc)
        (tutcode-proc-state-on pc key key-state)))))

;;; ʸ����ꥹ�Ȥ򥫥����ʤ��Ѵ�����
;;; @param strlist ʸ����Υꥹ��
;;; @param to-katakana? �������ʤ��Ѵ��������#t���Ҥ餬�ʤ��Ѵ��������#f
;;; @return �Ѵ����ʸ����ꥹ��
(define (tutcode-katakana-convert strlist to-katakana?)
  ;;XXX:���ʥ��ʺ��߻���ȿž(�����ʤ���)��̤�б�
  (let ((idx (if to-katakana? 1 0)))
    (map
      (lambda (e)
        (list-ref (ja-find-kana-list-from-rule ja-rk-rule e) idx))
      strlist)))

;;; �򤼽��Ѵ����ɤ����Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-yomi c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     (head (tutcode-context-head pc))
     (kigou2-mode? (tutcode-kigou2-mode? pc))
     (res #f)
     (katakana-commit
      (lambda ()
        (let ((str
                (string-list-concat
                  (tutcode-katakana-convert head
                    (not (tutcode-context-katakana-mode? pc))))))
          (tutcode-commit pc str)
          (tutcode-flush pc)
          (tutcode-undo-prepare pc 'tutcode-state-yomi str head))))
     (rk-append-flush
      (lambda ()
        (if tutcode-keep-illegal-sequence?
          (tutcode-context-set-head! pc (append (rk-context-seq rkc) head)))
        (rk-flush rkc)))
     ;; reset-candidate-window�ǥꥻ�åȤ����Τ���¸���Ƥ���
     (predicting?
      (eq? (tutcode-context-predicting pc) 'tutcode-predicting-prediction))
     ;; ͽ¬���ϸ���ɽ���Υڡ�����ư���ϡ�reset-candidate-window����������
     (prediction-keys-handled?
      (if predicting?
        (cond
          ((tutcode-next-page-key? key key-state)
            (tutcode-change-prediction-page pc #t)
            #t)
          ((tutcode-prev-page-key? key key-state)
            (tutcode-change-prediction-page pc #f)
            #t)
          (else
            #f))
        #f)))
    (if (not prediction-keys-handled?)
      (begin
        (tutcode-reset-candidate-window pc)
        (cond
          ((tutcode-off-key? key key-state)
           (tutcode-flush pc)
           (tutcode-context-set-state! pc 'tutcode-state-off))
          ((and (tutcode-kana-toggle-key? key key-state)
                (not (tutcode-context-latin-conv pc))
                (not kigou2-mode?))
           (rk-append-flush)
           (tutcode-context-kana-toggle pc))
          ((tutcode-kigou2-toggle-key? key key-state)
           (rk-append-flush)
           (tutcode-toggle-kigou2-mode pc))
          ((tutcode-backspace-key? key key-state)
           (if (> (length (rk-context-seq rkc)) 0)
            (rk-flush rkc)
            (if (> (length head) 0)
              (begin
                (tutcode-context-set-head! pc (cdr head))
                (if (and predicting? (> tutcode-prediction-start-char-count 0))
                  (tutcode-check-prediction pc #f))))))
          ((or
            (tutcode-commit-key? key key-state)
            (tutcode-return-key? key key-state))
           (tutcode-commit pc (string-list-concat head))
           (tutcode-flush pc))
          ((tutcode-cancel-key? key key-state)
           (tutcode-flush pc))
          ((tutcode-stroke-help-toggle-key? key key-state)
           (tutcode-toggle-stroke-help pc))
          ((and tutcode-use-prediction?
                (tutcode-begin-completion-key? key key-state))
           (rk-append-flush)
           (if (not predicting?)
             (tutcode-check-prediction pc #t)))
          ;; �������1�Ĥξ�硢�Ѵ��弫ư���ꤵ���converting�⡼�ɤ�����ʤ�
          ;; �Τǡ����ξ��Ǥ�purge�Ǥ���褦�ˡ������ǥ����å�
          ((and (tutcode-purge-candidate-key? key key-state)
                (not (null? head))
                (not kigou2-mode?))
           ;; converting�⡼�ɤ˰ܹԤ��Ƥ���purge
           (tutcode-begin-conversion pc head () #f #f)
           (if (eq? (tutcode-context-state pc) 'tutcode-state-converting)
             (tutcode-proc-state-converting pc key key-state)))
          ((and (tutcode-register-candidate-key? key key-state)
                tutcode-use-recursive-learning?
                (not kigou2-mode?))
           (tutcode-context-set-state! pc 'tutcode-state-converting)
           (tutcode-setup-child-context pc 'tutcode-child-type-editor))
          ((tutcode-katakana-commit-key? key key-state)
            (katakana-commit))
          ((tutcode-paste-key? key key-state)
            (let ((latter-seq (tutcode-clipboard-acquire-text-wo-nl pc 'full)))
              (if (pair? latter-seq)
                (tutcode-context-set-head! pc (append latter-seq head)))))
          ((symbol? key)
           (tutcode-flush pc)
           (tutcode-proc-state-on pc key key-state))
          ((and
            (modifier-key-mask key-state)
            (not (shift-key-mask key-state)))
           ;; <Control>n���Ǥ��Ѵ�����?
           (if (tutcode-begin-conv-key? key key-state)
             (if (not (null? head))
               (tutcode-begin-conversion-with-inflection pc #t)
               (tutcode-flush pc))
             (begin
               (tutcode-flush pc)
               (tutcode-proc-state-on pc key key-state))))
          ;; ͽ¬���ϸ����ѥ�٥륭��?
          ((and predicting?
                (tutcode-heading-label-char-for-prediction? key)
                (tutcode-commit-by-label-key-for-prediction pc
                  (charcode->string key) 'tutcode-predicting-prediction)))
          ((tutcode-context-latin-conv pc)
           (if (tutcode-begin-conv-key? key key-state) ; space�����Ǥ��Ѵ�����?
             (if (not (null? head))
               (tutcode-begin-conversion-with-inflection pc #t)
               (tutcode-flush pc))
             (set! res (charcode->string key))))
          ((not (rk-expect-key? rkc (charcode->string key)))
           (if (> (length (rk-context-seq rkc)) 0)
             (begin
               (cond
                 ((tutcode-verbose-stroke-key? key key-state)
                   (tutcode-context-set-head! pc
                     (append (rk-context-seq rkc) head)))
                 (tutcode-keep-illegal-sequence?
                   (tutcode-context-set-head! pc
                     (append (rk-context-seq rkc) head))
                   (set! res (charcode->string key))))
               (rk-flush rkc))
             ;; space�����Ǥ��Ѵ�����?
             ;; (space�ϥ����������󥹤˴ޤޤ���礬����Τǡ�
             ;;  rk-expect��space��̵�����Ȥ����)
             ;; (trycode��space�ǻϤޤ륭���������󥹤�ȤäƤ����硢
             ;;  space���Ѵ����ϤϤǤ��ʤ��Τǡ�<Control>n����Ȥ�ɬ�פ���)
             (if (tutcode-begin-conv-key? key key-state)
               (if (not (null? head))
                 (tutcode-begin-conversion-with-inflection pc #t)
                 (tutcode-flush pc))
               (set! res (charcode->string key)))))
          (else
           (set! res (tutcode-push-key! pc (charcode->string key)))
           (if (eq? res 'tutcode-postfix-bushu-start)
            (begin
              (set! res
                (and (>= (length head) 2)
                     (tutcode-bushu-convert (cadr head) (car head))))
              (if res
                (begin
                  (tutcode-context-set-head! pc (cddr head))
                  (tutcode-check-auto-help-window-begin pc (list res) ())))))))
        (cond
          ((string? res)
            (tutcode-append-string pc res)
            (if (and tutcode-use-prediction?
                     (> tutcode-prediction-start-char-count 0)
                     ;; ���ַ���������Ѵ��ˤ��auto-helpɽ���ѻ��ϲ��⤷�ʤ�
                     (eq? (tutcode-context-candidate-window pc)
                          'tutcode-candidate-window-off))
              (tutcode-check-prediction pc #f)))
          ((symbol? res)
            (case res
              ((tutcode-auto-help-redisplay)
                (tutcode-auto-help-redisplay pc))
              ;; ���Ѥ��ʤ���Ȥ����Ѵ����ϡ����䤬1�Ĥξ��ϼ�ư����
              ((tutcode-postfix-mazegaki-start)
                (if (not (null? head))
                  (tutcode-begin-conversion-with-inflection pc #f)
                  (begin
                    (tutcode-flush pc)
                    (tutcode-begin-postfix-mazegaki-conversion pc #f #f #f))))
              ;; ���Ѥ����Ȥ����Ѵ�����(postfix�ѥ����������󥹤�ή��)
              ((tutcode-postfix-mazegaki-inflection-start)
                (if (not (null? head))
                  (tutcode-begin-mazegaki-inflection-conversion pc)
                  (begin
                    (tutcode-flush pc)
                    (tutcode-begin-postfix-mazegaki-inflection-conversion pc #f))))
              ((tutcode-postfix-katakana-start)
                (if (not (null? head))
                  (katakana-commit)
                  (begin
                    (tutcode-flush pc)
                    (tutcode-begin-postfix-katakana-conversion pc #f))))
              ;; ���������ϥ��������Ѵ������clipboard�����paste����
              ((tutcode-postfix-kanji2seq-start)
                (if (not (null? head))
                  (let ((str
                          (string-list-concat
                            (tutcode-kanji-list->sequence pc head))))
                    (tutcode-commit pc str)
                    (tutcode-flush pc)
                    (tutcode-undo-prepare pc 'tutcode-state-yomi str head))
                  (begin
                    (tutcode-flush pc)
                    (tutcode-begin-postfix-kanji2seq-conversion pc #f))))))
          ((procedure? res)
            (res 'tutcode-state-yomi pc)))))))

;;; �������������Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-code c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (head (tutcode-context-head pc))
     (res #f))
    (cond
      ((and tutcode-use-with-vi?
            (tutcode-vi-escape-key? key key-state))
        (tutcode-flush pc)
        (tutcode-context-set-state! pc 'tutcode-state-off)
        (tutcode-commit-raw pc key key-state)) ; ESC�����򥢥ץ�ˤ��Ϥ�
      ((tutcode-off-key? key key-state)
        (tutcode-flush pc)
        (tutcode-context-set-state! pc 'tutcode-state-off))
      ((tutcode-kigou-toggle-key? key key-state)
        (tutcode-flush pc)
        (tutcode-begin-kigou-mode pc))
      ((tutcode-kigou2-toggle-key? key key-state)
        (tutcode-flush pc)
        (if (not (tutcode-kigou2-mode? pc))
          (tutcode-toggle-kigou2-mode pc)))
      ((tutcode-backspace-key? key key-state)
        (if (pair? head)
          (tutcode-context-set-head! pc (cdr head))))
      ((tutcode-cancel-key? key key-state)
        (tutcode-flush pc))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (tutcode-commit pc (string-list-concat head))
        (tutcode-flush pc))
      ((tutcode-paste-key? key key-state)
        (let ((latter-seq (tutcode-clipboard-acquire-text-wo-nl pc 'full)))
          (if (pair? latter-seq)
            (tutcode-context-set-head! pc (append latter-seq head)))))
      ((symbol? key)
        (tutcode-flush pc)
        (tutcode-proc-state-on pc key key-state))
      ((and (modifier-key-mask key-state)
            (not (shift-key-mask key-state)))
        (if (tutcode-begin-conv-key? key key-state) ; <Control>n���Ǥ��Ѵ�����?
          (if (pair? head)
            (tutcode-begin-kanji-code-input pc head)
            (tutcode-flush pc))
          (begin
            (tutcode-flush pc)
            (tutcode-proc-state-on pc key key-state))))
      ((tutcode-begin-conv-key? key key-state) ; space�����Ǥ��Ѵ�����?
        (if (pair? head)
          (tutcode-begin-kanji-code-input pc head)
          (tutcode-flush pc)))
      (else
        (tutcode-append-string pc (charcode->string key))))))

;;; ��������Ѵ����������Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-bushu c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     (res #f)
     (predicting?
      (eq? (tutcode-context-predicting pc) 'tutcode-predicting-bushu))
     (re-predict
      (lambda ()
        (if tutcode-use-bushu-prediction?
          (let ((prevchar (car (tutcode-context-head pc))))
            (if (not (string=? prevchar "��"))
              (tutcode-check-bushu-prediction pc prevchar)))))))
    (tutcode-reset-candidate-window pc)
    (cond
      ((tutcode-off-key? key key-state)
       (tutcode-flush pc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((and (tutcode-kana-toggle-key? key key-state)
            (not (tutcode-kigou2-mode? pc)))
       (rk-flush rkc)
       (tutcode-context-kana-toggle pc))
      ((tutcode-kigou2-toggle-key? key key-state)
       (rk-flush rkc)
       (tutcode-toggle-kigou2-mode pc))
      ((tutcode-backspace-key? key key-state)
       (if (> (length (rk-context-seq rkc)) 0)
        (rk-flush rkc)
        ;; head��1ʸ���ܤ���������Ѵ��Υޡ�������backspace�ǤϾä��ʤ��褦��
        ;; ���롣�ְ�äƳ���Ѥ�ʸ����ä��ʤ��褦�ˤ��뤿�ᡣ
        (if (> (length (tutcode-context-head pc)) 1)
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc))))))
      ((or
        (tutcode-commit-key? key key-state)
        (tutcode-return-key? key key-state))
        ;; �Ƶ�Ū��������Ѵ���(���ꤷ��)�����᤹
        (set! res (car (tutcode-context-head pc)))
        (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
        (if (not (string=? res "��"))
          ;; �⤦1ʸ��(���ΤϤ�)��ä��ơ�����ä�
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
          (set! res #f))
        (if (= (length (tutcode-context-head pc)) 0)
          (begin
            ;; �Ǿ�̤���������Ѵ��ξ�硢�Ѵ���������󤬤����commit
            (if res
              (tutcode-commit pc res))
            (tutcode-flush pc)
            (if res (tutcode-check-auto-help-window-begin pc (list res) ()))
            (set! res #f))
          (if (not res)
            (re-predict))))
      ((tutcode-cancel-key? key key-state)
        ;; �Ƶ�Ū��������Ѵ���(����󥻥뤷��)�����᤹
        (set! res (car (tutcode-context-head pc)))
        (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
        (if (not (string=? res "��"))
          ;; �⤦1ʸ��(���ΤϤ�)��ä��ơ�����ä�
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc))))
        (set! res #f)
        (if (= (length (tutcode-context-head pc)) 0)
          (tutcode-flush pc)
          (re-predict)))
      ((tutcode-stroke-help-toggle-key? key key-state)
       (tutcode-toggle-stroke-help pc))
      ((and predicting? (tutcode-next-page-key? key key-state))
       (tutcode-change-bushu-prediction-page pc #t))
      ((and predicting? (tutcode-prev-page-key? key key-state))
       (tutcode-change-bushu-prediction-page pc #f))
      ((tutcode-paste-key? key key-state)
        (let ((latter-seq (tutcode-clipboard-acquire-text-wo-nl pc 'full)))
          (if (pair? latter-seq)
            (let* ((head (tutcode-context-head pc))
                   (paste-res
                    (tutcode-bushu-convert-on-list
                      (reverse (append latter-seq head)) ())))
              (if (string? paste-res)
                (begin
                  (tutcode-commit pc paste-res)
                  (tutcode-flush pc)
                  (tutcode-undo-prepare pc 'tutcode-state-bushu paste-res head)
                  (tutcode-check-auto-help-window-begin pc (list paste-res) ()))
                (begin
                  (tutcode-context-set-head! pc paste-res)
                  (if (and tutcode-use-bushu-prediction?
                           (pair? paste-res)
                           (not (string=? (car paste-res) "��")))
                    (tutcode-check-bushu-prediction pc (car paste-res)))))))))
      ((or
        (symbol? key)
        (and
          (modifier-key-mask key-state)
          (not (shift-key-mask key-state))))
       (tutcode-flush pc)
       (tutcode-proc-state-on pc key key-state))
      ;; ͽ¬���ϸ����ѥ�٥륭��?
      ((and predicting?
            (tutcode-heading-label-char-for-prediction? key)
            (tutcode-commit-by-label-key-for-prediction pc
              (charcode->string key) 'tutcode-predicting-bushu)))
      ((not (rk-expect-key? rkc (charcode->string key)))
       (if (> (length (rk-context-seq rkc)) 0)
         (begin
           (if (tutcode-verbose-stroke-key? key key-state)
             (set! res (last (rk-context-seq rkc))))
           (rk-flush rkc))
         (set! res (charcode->string key))))
      (else
       (set! res (tutcode-push-key! pc (charcode->string key)))))
    (cond
      ((string? res)
        ;; �Ƶ�Ū���������������礬����Τǡ�head���Τ�undo�Ѥ��ݻ�
        (tutcode-undo-prepare pc 'tutcode-state-bushu " " ; " ":������1ʸ��
          (tutcode-context-head pc))
        (tutcode-begin-bushu-conversion pc res))
      ((symbol? res)
       (case res
        ((tutcode-bushu-start) ; �Ƶ�Ū����������Ѵ�
          (tutcode-append-string pc "��"))
        ((tutcode-auto-help-redisplay)
          (tutcode-auto-help-redisplay pc))
        ((tutcode-undo) ; �Ƶ�Ū����������Ѵ���undo����
          (let ((undo (tutcode-context-undo pc)))
            (if (pair? undo)
              (tutcode-context-set-head! pc (list-ref undo 2)))))
        ;;XXX ��������Ѵ���ϸ򤼽��Ѵ�����̵���ˤ���
        ))
      ((procedure? res)
       (res 'tutcode-state-bushu pc)))))

;;; ��������Ѵ�����
;;; @param char ���������Ϥ��줿ʸ��(2���ܤ�����)
(define (tutcode-begin-bushu-conversion pc char)
  (let ((prevchar (car (tutcode-context-head pc))))
    (if (string=? prevchar "��")
      (begin
        (tutcode-append-string pc char)
        (if tutcode-use-bushu-prediction?
          (tutcode-check-bushu-prediction pc char)))
      ;; ľ����ʸ������������ޡ����Ǥʤ���2ʸ���ܤ����Ϥ��줿���Ѵ�����
      (let ((convchar (tutcode-bushu-convert prevchar char)))
        (if (string? convchar)
          ;; ��������
          (tutcode-bushu-commit pc convchar)
          ;; �������Ի������Ϥ�ľ�����Ԥġ�ͽ¬���ϸ���Ϻ�ɽ��
          (if tutcode-use-bushu-prediction?
            (if (string? (tutcode-context-prediction-bushu pc)) ; �ٱ��Ԥ���?
              (tutcode-check-bushu-prediction pc prevchar)
              ;; ͽ¬���ϸ���ꥹ�Ⱥ����Ѥξ�硢����ɽ�������ڡ��������ɽ��
              (tutcode-bushu-prediction-make-page pc
                (tutcode-context-prediction-bushu-page-start pc) #t))))))))

;;; ��������Ѵ����Ѵ�����ʸ������ꤹ��
;;; @param convchar �Ѵ����ʸ��
(define (tutcode-bushu-commit pc convchar)
  ;; 1���ܤ�����Ȣ���ä�
  (tutcode-context-set-head! pc (cddr (tutcode-context-head pc)))
  (if (null? (tutcode-context-head pc))
    ;; �Ѵ��Ԥ������󤬻ĤäƤʤ���С����ꤷ�ƽ�λ
    (let ((undo-data (tutcode-context-undo pc))) ; commit����ȥ��ꥢ�����
      (tutcode-commit pc convchar)
      (tutcode-flush pc)
      (tutcode-context-set-undo! pc undo-data)
      (tutcode-check-auto-help-window-begin pc (list convchar) ()))
    ;; ���󤬤ޤ��ĤäƤ�С��Ƴ�ǧ��
    ;; (��������ʸ����2ʸ���ܤʤ�С�Ϣ³������������Ѵ�)
    (tutcode-begin-bushu-conversion pc convchar)))

;;; ��������Ѵ���ꥹ�Ȥ��Ф���Ŭ�Ѥ���
;;; @param bushu-list ��������������󥹤Υꥹ�ȡ�
;;;  ��:("��" "��" "��" "��" "��" "��" "��" "��")
;;; @param conv-list �Ѵ���Υꥹ��(�ս�)
;;; @return ������λ�����Ѵ���ʸ���󡣹�������ξ����Ѵ���ꥹ��(�ս�)��
;;;  ��:"��"
(define (tutcode-bushu-convert-on-list bushu-list conv-list)
  (if (null? bushu-list)
    conv-list
    (let ((bushu (car bushu-list))
          (prevchar (safe-car conv-list)))
      (if (or (not prevchar) (string=? prevchar "��") (string=? bushu "��"))
        ;; 1ʸ���� or �Ƶ�����
        (tutcode-bushu-convert-on-list (cdr bushu-list) (cons bushu conv-list))
        ;; ľ����ʸ������������ޡ����Ǥʤ���2ʸ���ܢ��Ѵ�����
        (let ((convchar (tutcode-bushu-convert prevchar bushu)))
          (if (string? convchar) ; ��������?
            (if (or (null? (cdr conv-list)) (null? (cddr conv-list)))
              convchar ; ������λ(bushu-list�λĤ��̵��)
              (tutcode-bushu-convert-on-list
                (cons convchar (cdr bushu-list))
                (cddr conv-list))) ; �Ƶ�Ū�˹���
            ;; �������Ի��ϼ�������ǻ
            (tutcode-bushu-convert-on-list (cdr bushu-list) conv-list)))))))

;;; ����Ū��������Ѵ��ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-interactive-bushu c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     (head (tutcode-context-head pc))
     (res #f)
     (has-candidate? (> (tutcode-context-prediction-nr pc) 0))
     ;; ����ɽ���Υڡ�����ư���ϡ�reset-candidate-window����������
     (candidate-selection-keys-handled?
      (if has-candidate?
        (cond
          ((tutcode-next-page-key? key key-state)
            (tutcode-change-prediction-page pc #t)
            #t)
          ((tutcode-prev-page-key? key key-state)
            (tutcode-change-prediction-page pc #f)
            #t)
          ((and (tutcode-next-candidate-key? key key-state)
                ;; 2�Ǹ��ܤΥ��ڡ��������ξ��ϸ�������ǤϤʤ�
                (= (length (rk-context-seq rkc)) 0))
            (tutcode-change-prediction-index pc 1)
            #t)
          ((tutcode-prev-candidate-key? key key-state)
            (tutcode-change-prediction-index pc -1)
            #t)
          (else
            #f))
        #f)))
    (if (not candidate-selection-keys-handled?)
      (begin
        (tutcode-reset-candidate-window pc)
        (cond
          ((tutcode-off-key? key key-state)
           (tutcode-flush pc)
           (tutcode-context-set-state! pc 'tutcode-state-off))
          ((and (tutcode-kana-toggle-key? key key-state)
                (not (tutcode-kigou2-mode? pc)))
           (rk-flush rkc)
           (tutcode-context-kana-toggle pc))
          ((tutcode-kigou2-toggle-key? key key-state)
           (rk-flush rkc)
           (tutcode-toggle-kigou2-mode pc))
          ((tutcode-backspace-key? key key-state)
           (if (> (length (rk-context-seq rkc)) 0)
            (rk-flush rkc)
            (if (> (length head) 0)
              (begin
                (tutcode-context-set-head! pc (cdr head))
                (if has-candidate?
                  (tutcode-begin-interactive-bushu-conversion pc))))))
          ((or
            (tutcode-commit-key? key key-state)
            (tutcode-return-key? key key-state))
           (let ((str
                  (cond
                    (has-candidate?
                      (tutcode-get-prediction-string pc
                        (tutcode-context-prediction-index pc))) ; �ϸ쥬����̵
                    ((> (length head) 0)
                      (string-list-concat (tutcode-context-head pc)))
                    (else
                      #f))))
             (if str (tutcode-commit pc str))
             (tutcode-flush pc)
             (if str (tutcode-check-auto-help-window-begin pc (list str) ()))))
          ((tutcode-cancel-key? key key-state)
           (tutcode-flush pc))
          ((tutcode-stroke-help-toggle-key? key key-state)
           (tutcode-toggle-stroke-help pc))
          ((tutcode-paste-key? key key-state)
            (let ((latter-seq (tutcode-clipboard-acquire-text-wo-nl pc 'full)))
              (if (pair? latter-seq)
                (begin
                  (tutcode-context-set-head! pc (append latter-seq head))
                  (tutcode-begin-interactive-bushu-conversion pc)))))
          ((or
            (symbol? key)
            (and
              (modifier-key-mask key-state)
              (not (shift-key-mask key-state))))
           (tutcode-flush pc)
           (tutcode-proc-state-on pc key key-state))
          ((and (tutcode-heading-label-char-for-prediction? key)
                (= (length (rk-context-seq rkc)) 0)
                (tutcode-commit-by-label-key-for-prediction pc
                  (charcode->string key)
                  'tutcode-predicting-interactive-bushu)))
          ((not (rk-expect-key? rkc (charcode->string key)))
           (if (> (length (rk-context-seq rkc)) 0)
             (begin
               (if (tutcode-verbose-stroke-key? key key-state)
                 (set! res (last (rk-context-seq rkc))))
               (rk-flush rkc))
             (set! res (charcode->string key))))
          (else
           (set! res (tutcode-push-key! pc (charcode->string key)))))
        (cond
          ((string? res)
            (tutcode-append-string pc res)
            (tutcode-begin-interactive-bushu-conversion pc))
          ((symbol? res)
           (case res
            ((tutcode-auto-help-redisplay)
              (tutcode-auto-help-redisplay pc))
            ;;XXX ��������Ѵ���ϸ򤼽��Ѵ�����̵���ˤ���
            ))
          ((procedure? res)
           (res 'tutcode-state-interactive-bushu pc)))))))

;;; ����Ū��������Ѵ�����
(define (tutcode-begin-interactive-bushu-conversion pc)
  (let*
    ((head (tutcode-context-head pc))
     (res
      (if (null? head)
        ()
        (tutcode-bushu-compose-interactively (reverse head)))))
    (cond
      ;; BS������ʸ���������ä��줿��硢preedit�θ����ä�����nr��0��
      ((null? head)
        (tutcode-context-set-prediction-nr! pc 0)
        (tutcode-context-set-prediction-candidates! pc ()))
      ;; ����������ʸ����ä���������ǽ������������ʸ������
      ((null? res)
        (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
        (if (> (tutcode-context-prediction-nr pc) 0)
          (begin
            (tutcode-activate-candidate-window pc
              'tutcode-candidate-window-interactive-bushu
              tutcode-candidate-window-activate-delay-for-interactive-bushu
              (tutcode-context-prediction-nr-all pc)
              (tutcode-context-prediction-page-limit pc))
            (tutcode-select-candidate pc
              (tutcode-context-prediction-index pc)))
          ;; paste���줿ʣ������������ƻȤ��ȹ�����ǽ��1������äƺƸ���
          (tutcode-begin-interactive-bushu-conversion pc)))
      (else
        (let ((nr (length res)))
          (tutcode-context-set-prediction-word! pc ())
          (tutcode-context-set-prediction-candidates! pc res)
          (tutcode-context-set-prediction-appendix! pc ())
          (tutcode-context-set-prediction-nr! pc nr)
          (tutcode-context-set-prediction-index! pc 0)
          (let*
            ((params (tutcode-prediction-calc-window-param nr 0))
             (nr-all (list-ref params 0)) ; �������
             (page-limit (list-ref params 1)) ; �ڡ���������
             (nr-in-page (list-ref params 2))) ; �ڡ���������
            (if (> page-limit 0)
              (begin
                ;; ͽ¬���ϸ������ѿ���ή��
                (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
                (tutcode-context-set-prediction-page-limit! pc page-limit)
                (tutcode-context-set-prediction-nr-all! pc nr-all)
                (tutcode-activate-candidate-window pc
                  'tutcode-candidate-window-interactive-bushu
                  tutcode-candidate-window-activate-delay-for-interactive-bushu
                  nr-all
                  page-limit)
                (tutcode-select-candidate pc 0)))))))))

;;; ��������������򤹤�
;;; @param pc ����ƥ����ȥꥹ��
;;; @param num ���ߤθ����ֹ椫�鿷�����ֹ�ޤǤΥ��ե��å�
(define (tutcode-change-candidate-index pc num)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (new-nth (+ nth num)))
    (cond
      ((< new-nth 0)
       (set! new-nth 0))
      ((and tutcode-use-recursive-learning?
            (eq? (tutcode-context-state pc) 'tutcode-state-converting)
            (= nth (- nr 1))
            (>= new-nth nr))
       (tutcode-reset-candidate-window pc)
       (tutcode-setup-child-context pc 'tutcode-child-type-editor))
      ((>= new-nth nr)
       (set! new-nth (- nr 1))))
    (tutcode-context-set-nth! pc new-nth))
  (if (null? (tutcode-context-child-context pc))
    (begin
      (tutcode-check-candidate-window-begin pc)
      (if (not (eq? (tutcode-context-candidate-window pc)
                    'tutcode-candidate-window-off))
        (tutcode-select-candidate pc (tutcode-context-nth pc))))))

;;; �������䴰/ͽ¬���ϸ�������򤹤�
;;; @param num ���ߤθ����ֹ椫�鿷�����ֹ�ޤǤΥ��ե��å�
(define (tutcode-change-prediction-index pc num)
  (let* ((nr-all (tutcode-context-prediction-nr-all pc))
         (idx (tutcode-context-prediction-index pc))
         (n (+ idx num))
         (compensated-n
          (cond
           ((>= n nr-all) (- nr-all 1))
           ((< n 0) 0)
           (else n))))
    (tutcode-context-set-prediction-index! pc compensated-n)
    (tutcode-select-candidate pc compensated-n)))

;;; ��/���ڡ������䴰/ͽ¬���ϸ����ɽ������
;;; @param next? #t:���ڡ���, #f:���ڡ���
(define (tutcode-change-prediction-page pc next?)
  (let ((page-limit (tutcode-context-prediction-page-limit pc)))
    (tutcode-change-prediction-index pc (if next? page-limit (- page-limit)))))

;;; ��/���ڡ�������������Ѵ���ͽ¬���ϸ����ɽ������
;;; @param next? #t:���ڡ���, #f:���ڡ���
(define (tutcode-change-bushu-prediction-page pc next?)
  (let* ((idx (tutcode-context-prediction-bushu-page-start pc))
         (n (+ idx
              (if next?
                tutcode-nr-candidate-max-for-prediction
                (- tutcode-nr-candidate-max-for-prediction)))))
    (tutcode-bushu-prediction-make-page pc n #t)))

;;; ���䥦����ɥ����Ĥ���
(define (tutcode-reset-candidate-window pc)
  (if (not (eq? (tutcode-context-candidate-window pc)
                'tutcode-candidate-window-off))
    (begin
      (im-deactivate-candidate-selector pc)
      (tutcode-context-set-candidate-window! pc 'tutcode-candidate-window-off)
      (tutcode-context-set-predicting! pc 'tutcode-predicting-off)
      (tutcode-context-set-pseudo-table-cands! pc #f)
      (tutcode-context-set-candwin-delay-waiting! pc #f)
      (tutcode-context-set-candwin-delay-selected-index! pc -1))))

;;; �򤼽��Ѵ��θ���������֤��顢�ɤ����Ͼ��֤��᤹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-back-to-yomi-state pc)
  (let ((postfix-yomi-len (tutcode-context-postfix-yomi-len pc)))
    (cond
      ((= postfix-yomi-len 0)
        (tutcode-reset-candidate-window pc)
        (tutcode-context-set-state! pc 'tutcode-state-yomi)
        (tutcode-context-set-head! pc (tutcode-context-mazegaki-yomi-all pc))
        (tutcode-context-set-mazegaki-suffix! pc ())
        (tutcode-context-set-nr-candidates! pc 0))
      ((> postfix-yomi-len 0)
        (tutcode-flush pc))
      (else ; selection
        (im-clear-preedit pc)
        (im-update-preedit pc)
        ;; Firefox��qt4�ξ�硢preeditɽ������selection����񤭤����褦�ǡ�
        ;; cancel���Ƥ�ä����ޤޤˤʤ�Τǡ������Ѥ�selection���Ƥ���᤹��
        ;; (selection���֤��������뤿��Firefox��qt4�ʳ�(leafpad��)�ǤϤ��줷
        ;; ���ʤ������ä���ǥ��åȤ�����selection����Υǥ��åȤ���礭��)
        ;; (����acquire-text���Ƥ�Ƚ���Firefox�ξ��pair���֤뤿��Ƚ����ǽ)
        (tutcode-commit pc
          (string-list-concat (tutcode-context-mazegaki-yomi-all pc)) #t #t)
        (tutcode-flush pc)))))

;;; �򤼽��Ѵ��μ�����Ͽ���֤��顢����������֤��᤹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-back-to-converting-state pc)
  (tutcode-context-set-nth! pc (- (tutcode-context-nr-candidates pc) 1))
  (tutcode-check-candidate-window-begin pc)
  (if (eq? (tutcode-context-candidate-window pc)
           'tutcode-candidate-window-converting)
    (tutcode-select-candidate pc (tutcode-context-nth pc)))
  (tutcode-context-set-state! pc 'tutcode-state-converting))

;;; ���Ϥ��줿�����������٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char? key)
  (member (charcode->string key) tutcode-heading-label-char-list))

;;; ���Ϥ��줿�������������ϥ⡼�ɻ��θ����٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char-for-kigou-mode? key)
  (member (charcode->string key) tutcode-heading-label-char-list-for-kigou-mode))

;;; ���Ϥ��줿�������ҥ��ȥ����ϥ⡼�ɻ��θ����٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char-for-history? key)
  (member (charcode->string key) tutcode-heading-label-char-list-for-history))

;;; ���Ϥ��줿�������䴰/ͽ¬���ϻ��θ����٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char-for-prediction? key)
  (member (charcode->string key) tutcode-heading-label-char-list-for-prediction))

;;; �򤼽��Ѵ��θ���������֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-converting c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (cond
      ((tutcode-next-candidate-key? key key-state)
        (tutcode-change-candidate-index pc 1))
      ((tutcode-prev-candidate-key? key key-state)
        (tutcode-change-candidate-index pc -1))
      ((tutcode-cancel-key? key key-state)
        (tutcode-back-to-yomi-state pc))
      ((tutcode-next-page-key? key key-state)
        (tutcode-change-candidate-index pc tutcode-nr-candidate-max))
      ((tutcode-prev-page-key? key key-state)
        (tutcode-change-candidate-index pc (- tutcode-nr-candidate-max)))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (tutcode-commit-with-auto-help pc))
      ((tutcode-purge-candidate-key? key key-state)
        (tutcode-reset-candidate-window pc)
        (tutcode-setup-child-context pc 'tutcode-child-type-dialog))
      ((and (tutcode-register-candidate-key? key key-state)
            tutcode-use-recursive-learning?)
        (tutcode-reset-candidate-window pc)
        (tutcode-setup-child-context pc 'tutcode-child-type-editor))
      ((tutcode-mazegaki-relimit-right-key? key key-state)
        (tutcode-mazegaki-proc-relimit-right pc))
      ((tutcode-mazegaki-relimit-left-key? key key-state)
        (tutcode-mazegaki-proc-relimit-left pc))
      ((and (or (eq? tutcode-commit-candidate-by-label-key 'always)
                (eq? tutcode-commit-candidate-by-label-key 'havecand)
                (and (eq? tutcode-commit-candidate-by-label-key 'candwin)
                     (not (eq? (tutcode-context-candidate-window pc)
                               'tutcode-candidate-window-off))
                     (not (tutcode-context-candwin-delay-waiting pc))))
            (not (and (modifier-key-mask key-state)
                      (not (shift-key-mask key-state))))
            (> (tutcode-context-nr-candidates pc) 1)
            (tutcode-heading-label-char? key)
            (tutcode-commit-by-label-key pc (charcode->string key))))
      (else
        (let* ((postfix-yomi-len (tutcode-context-postfix-yomi-len pc))
               (yomi (and (not (zero? postfix-yomi-len))
                          (take (tutcode-context-mazegaki-yomi-all pc)
                                (abs postfix-yomi-len))))
               (commit-str (tutcode-prepare-commit-string pc)))
          (cond
            ((= postfix-yomi-len 0)
              (tutcode-commit pc commit-str))
            ((> postfix-yomi-len 0)
              (tutcode-postfix-commit pc commit-str yomi))
            (else
              (tutcode-selection-commit pc commit-str yomi))))
        (tutcode-proc-state-on pc key key-state)))))

;;; ��������Ѵ���Ԥ���
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-convert c1 c2)
  (case tutcode-bushu-conversion-algorithm
    ((tc-2.3.1-22.6)
      (tutcode-bushu-convert-tc23 c1 c2))
    ((kw-yamanobe)
      (tutcode-bushu-convert-kwyamanobe c1 c2))
    (else ; 'tc-2.1+ml1925
      (tutcode-bushu-convert-tc21 c1 c2))))

;;; ��������Ѵ���Ԥ���
;;; tc-2.1+[tcode-ml:1925]������������르�ꥺ�����ѡ�
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-convert-tc21 c1 c2)
  (if (null? tutcode-bushu-help)
    (set! tutcode-bushu-help (tutcode-bushu-help-load)))
  (and c1 c2
    (or
      (and tutcode-bushu-help (tutcode-bushu-compose c1 c2 tutcode-bushu-help))
      (tutcode-bushu-compose-sub c1 c2)
      (let ((a1 (tutcode-bushu-alternative c1))
            (a2 (tutcode-bushu-alternative c2)))
        (and
          (or
            (not (string=? a1 c1))
            (not (string=? a2 c2)))
          (begin
            (set! c1 a1)
            (set! c2 a2)
            #t)
          (tutcode-bushu-compose-sub c1 c2)))
      (let* ((decomposed1 (tutcode-bushu-decompose c1))
             (decomposed2 (tutcode-bushu-decompose c2))
             (tc11 (and decomposed1 (car decomposed1)))
             (tc12 (and decomposed1 (cadr decomposed1)))
             (tc21 (and decomposed2 (car decomposed2)))
             (tc22 (and decomposed2 (cadr decomposed2)))
             ;; �������ʸ��������������2�Ĥ�����Ȥϰۤʤ�
             ;; ������ʸ���Ǥ��뤳�Ȥ��ǧ���롣
             ;; (string=?����#f�����ä��Ȥ��˥��顼�ˤʤ�Τ�equal?�����)
             (newchar
                (lambda (new)
                  (and
                    (not (equal? new c1))
                    (not (equal? new c2))
                    new))))
        (or
          ;; ������
          (and
            (equal? tc11 c2)
            (newchar tc12))
          (and
            (equal? tc12 c2)
            (newchar tc11))
          (and
            (equal? tc21 c1)
            (newchar tc22))
          (and
            (equal? tc22 c1)
            (newchar tc21))
          ;; ���ʤˤ��­����
          (let ((compose-newchar
                  (lambda (i1 i2)
                    (let ((res (tutcode-bushu-compose-sub i1 i2)))
                      (and res
                        (newchar res))))))
            (or
              (compose-newchar c1 tc22) (compose-newchar tc11 c2)
              (compose-newchar c1 tc21) (compose-newchar tc12 c2)
              (compose-newchar tc11 tc22) (compose-newchar tc11 tc21)
              (compose-newchar tc12 tc22) (compose-newchar tc12 tc21)))
          ;; ���ʤˤ�������
          (and tc11
            (equal? tc11 tc21)
            (newchar tc12))
          (and tc11
            (equal? tc11 tc22)
            (newchar tc12))
          (and tc12
            (equal? tc12 tc21)
            (newchar tc11))
          (and tc12
            (equal? tc12 tc22)
            (newchar tc11)))))))

;;; ��������Ѵ���Ԥ���
;;; ��ľWin+YAMANOBE����������르�ꥺ�����ѡ�
;;; @param ca 1���ܤ�����
;;; @param cb 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-convert-kwyamanobe ca cb)
  (if (null? tutcode-bushu-help)
    (set! tutcode-bushu-help (tutcode-bushu-help-load)))
  (and ca cb
    (or
      (and tutcode-bushu-help (tutcode-bushu-compose ca cb tutcode-bushu-help))
      (let
        ;; �������ʸ��������������2�Ĥ�����Ȥϰۤʤ�
        ;; ������ʸ���Ǥ��뤳�Ȥ��ǧ���롣
        ;; (string=?����#f�����ä��Ȥ��˥��顼�ˤʤ�Τ�equal?�����)
        ((newchar
          (lambda (new)
            (and new
              (not (equal? new ca))
              (not (equal? new cb))
              new)))
         (bushu-compose-sub
          (lambda (x y)
            (and x y
              (tutcode-bushu-compose x y tutcode-bushudic))))) ; no swap
        (or
          (newchar (bushu-compose-sub ca cb))
          (let
            ((a (tutcode-bushu-alternative ca))
             (b (tutcode-bushu-alternative cb))
             (compose-alt
              (lambda (cx cy x y)
                (and
                  (or
                    (not (string=? x cx))
                    (not (string=? y cy)))
                  (newchar (bushu-compose-sub x y))))))
            (or
              (compose-alt ca cb a b)
              (let*
                ((ad (tutcode-bushu-decompose a))
                 (bd (tutcode-bushu-decompose b))
                 (a1 (and ad (car ad)))
                 (a2 (and ad (cadr ad)))
                 (b1 (and bd (car bd)))
                 (b2 (and bd (cadr bd)))
                 (compose-newchar
                  (lambda (i1 i2)
                    (newchar (bushu-compose-sub i1 i2))))
                 (compose-l2r
                  (lambda (x y z)
                    (newchar (bushu-compose-sub (bushu-compose-sub x y) z))))
                 (compose-r2l
                  (lambda (x y z)
                    (newchar (bushu-compose-sub x (bushu-compose-sub y z)))))
                 (compose-lr
                  (lambda (a a1 a2 b b1 b2)
                    (or
                      (and a1 a2
                        (or
                          (compose-l2r a1 b a2)
                          (compose-r2l a1 a2 b)))
                      (and b1 b2
                        (or
                          (compose-l2r a b1 b2)
                          (compose-r2l b1 a b2))))))
                 (subtract
                  (lambda (a1 a2 b)
                    (or
                      (and (equal? a2 b) (newchar a1))
                      (and (equal? a1 b) (newchar a2))))))
                (or
                  (compose-lr a a1 a2 b b1 b2)
                  ;; ������
                  (subtract a1 a2 b)
                  (let*
                    ((ad1 (and a1 (tutcode-bushu-decompose a1)))
                     (ad2 (and a2 (tutcode-bushu-decompose a2)))
                     (a11 (and ad1 (car ad1)))
                     (a12 (and ad1 (cadr ad1)))
                     (a21 (and ad2 (car ad2)))
                     (a22 (and ad2 (cadr ad2)))
                     (bushu-convert-sub
                      (lambda (a a1 a11 a12 a2 a21 a22 b b1 b2)
                        (or
                          (and a2 a11 a12
                            (or
                              (and (equal? a12 b) (compose-newchar a11 a2))
                              (and (equal? a11 b) (compose-newchar a12 a2))))
                          (and a1 a21 a22
                            (or
                              (and (equal? a22 b) (compose-newchar a1 a21))
                              (and (equal? a21 b) (compose-newchar a1 a22))))
                          ;; ���������ʤˤ��­����
                          (compose-newchar a b1)
                          (compose-newchar a b2)
                          (compose-newchar a1 b)
                          (compose-newchar a2 b)
                          (and a1 a2 b1
                            (or
                              (compose-l2r a1 b1 a2)
                              (compose-r2l a1 a2 b1)))
                          (and a1 a2 b2
                            (or
                              (compose-l2r a1 b2 a2)
                              (compose-r2l a1 a2 b2)))
                          (and a1 b1 b2
                            (or
                              (compose-l2r a1 b1 b2)
                              (compose-r2l b1 a1 b2)))
                          (and a2 b1 b2
                            (or
                              (compose-l2r a2 b1 b2)
                              (compose-r2l b1 a2 b2)))
                          ;; ξ�������ʤˤ��­����
                          (compose-newchar a1 b1)
                          (compose-newchar a1 b2)
                          (compose-newchar a2 b1)
                          (compose-newchar a2 b2)
                          ;; ���ʤˤ�������
                          (and a2 b1 (equal? a2 b1) (newchar a1))
                          (and a2 b2 (equal? a2 b2) (newchar a1))
                          (and a1 b1 (equal? a1 b1) (newchar a2))
                          (and a1 b2 (equal? a1 b2) (newchar a2))
                          (and a2 a11 a12
                            (or
                              (and (or (equal? a12 b1) (equal? a12 b2))
                                (compose-newchar a11 a2))
                              (and (or (equal? a11 b1) (equal? a11 b2))
                                (compose-newchar a12 a2))))
                          (and a1 a21 a22
                            (or
                              (and (or (equal? a22 b1) (equal? a22 b2))
                                (compose-newchar a1 a21))
                              (and (or (equal? a21 b1) (equal? a21 b2))
                                (compose-newchar a1 a22))))))))
                    (or
                      (bushu-convert-sub a a1 a11 a12 a2 a21 a22 b b1 b2)
                      ;; ʸ���ν����դˤ��Ƥߤ�
                      (and (not (equal? ca cb))
                        (or
                          (newchar (bushu-compose-sub cb ca))
                          (compose-alt cb ca b a)
                          (compose-lr b b1 b2 a a1 a2)
                          (subtract b1 b2 a)
                          (let*
                            ((bd1 (and b1 (tutcode-bushu-decompose b1)))
                             (bd2 (and b2 (tutcode-bushu-decompose b2)))
                             (b11 (and bd1 (car bd1)))
                             (b12 (and bd1 (cadr bd1)))
                             (b21 (and bd2 (car bd2)))
                             (b22 (and bd2 (cadr bd2))))
                            (bushu-convert-sub b b1 b11 b12 b2 b21 b22 a a1 a2)
                            ))))))))))))))

;;; ��������Ѵ�:c1��c2��������ƤǤ���ʸ����õ�����֤���
;;; ���ꤵ�줿���֤Ǹ��Ĥ���ʤ��ä����ϡ����֤����줫����õ����
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-compose-sub c1 c2)
  (and c1 c2
    (or
      (tutcode-bushu-compose c1 c2 tutcode-bushudic)
      (tutcode-bushu-compose c2 c1 tutcode-bushudic))))

;;; ��������Ѵ�:c1��c2��������ƤǤ���ʸ����õ�����֤���
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-compose c1 c2 bushudic)
  (let ((seq (rk-lib-find-seq (list c1 c2) bushudic)))
    (and seq
      (car (cadr seq)))))

;;; ��������Ѵ�:����ʸ����õ�����֤���
;;; @param c �����оݤ�ʸ��
;;; @return ����ʸ��������ʸ�������Ĥ���ʤ��ä��Ȥ��ϸ���ʸ������
(define (tutcode-bushu-alternative c)
  (let ((alt (assoc c tutcode-bushudic-altchar)))
    (or
      (and alt (cadr alt))
      c)))

;;; ��������Ѵ�:ʸ����2�Ĥ������ʬ�򤹤롣
;;; @param c ʬ���оݤ�ʸ��
;;; @return ʬ�򤷤ƤǤ���2�Ĥ�����Υꥹ�ȡ�ʬ��Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-decompose c)
  (if (null? tutcode-reverse-bushudic-hash-table)
    (set! tutcode-reverse-bushudic-hash-table
      (tutcode-rule->reverse-hash-table tutcode-bushudic)))
  (let ((i (tutcode-euc-jp-string->ichar c)))
    (and i
      (hash-table-ref/default tutcode-reverse-bushudic-hash-table i #f))))

;;; tutcode-rule�����Υꥹ�Ȥ��顢�հ�������(���������Ǹ��ꥹ�Ȥ����)�Ѥ�
;;; hash-table����
;;; @param rule tutcode-rule�����Υꥹ��
;;; @return hash-table
(define (tutcode-rule->reverse-hash-table rule)
  (alist->hash-table
    (filter-map
      (lambda (elem)
        (and-let*
          ((kanji (caadr elem))
           (kanji-string? (string? kanji)) ; 'tutcode-mazegaki-start���Ͻ���
           (i (tutcode-euc-jp-string->ichar kanji)))
          (cons i (caar elem))))
      rule)))

;;; hash-table�Υ����Ѥˡ�����1ʸ����ʸ���󤫤���������ɤ��Ѵ�����
;;; @param s ʸ����
;;; @return ���������ɡ�ʸ�����Ĺ����1�Ǥʤ�����#f
(define (tutcode-euc-jp-string->ichar s)
  ;; ichar.scm��string->ichar(string->charcode)��EUC-JP��
  (let ((sl (with-char-codec "EUC-JP"
              (lambda ()
                (string->list s)))))
    (cond
      ((null? sl)
        0)
      ((null? (cdr sl))
        (char->integer (car sl)))
      (else
        #f))))

;;; ��ư�إ��:bushu.help�ե�����򸡺������о�ʸ���Υإ��(2�Ĥ�����)���������
;;; @param c �о�ʸ��
;;; @return �إ�פ�ɽ���������(2�Ĥ�����Υꥹ��)�����Ĥ���ʤ��ä�����#f
(define (tutcode-bushu-help-lookup c)
  (and (not (string=? tutcode-bushu-help-filename "")) ; �ǥե���Ȥ�""
    (let*
      ((looked (tutcode-bushu-search c tutcode-bushu-help-filename))
       (lst (and looked (tutcode-bushu-parse-entry looked))))
      (and lst
        (>= (length lst) 2)
        (take lst 2)))))

;;; ��ư�إ��:�о�ʸ���������������Τ�ɬ�פȤʤ롢
;;; �����Ǥʤ�2�Ĥ�ʸ���Υꥹ�Ȥ��֤�
;;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @param stime ��������
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose c rule stime)
  (case tutcode-bushu-conversion-algorithm
    ((tc-2.3.1-22.6)
      (tutcode-auto-help-bushu-decompose-tc23 c rule stime))
    (else ; 'tc-2.1+ml1925
      (tutcode-auto-help-bushu-decompose-tc21 c rule stime))))

;;; ��ư�إ��:�о�ʸ���������������Τ�ɬ�פȤʤ롢
;;; �����Ǥʤ�2�Ĥ�ʸ���Υꥹ�Ȥ��֤�
;;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @param stime ��������
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose-tc21 c rule stime)
  (if (> (string->number (difftime (time) stime)) tutcode-auto-help-time-limit)
    #f
    (let*
      ((bushu (or (tutcode-bushu-help-lookup c)
                  (tutcode-bushu-decompose c)))
       (b1 (and bushu (car bushu)))
       (b2 (and bushu (cadr bushu)))
       (seq1 (and b1 (tutcode-auto-help-get-stroke b1 rule)))
       (seq2 (and b2 (tutcode-auto-help-get-stroke b2 rule))))
      (or
        ;; ­�����ˤ�����
        (and seq1 seq2
          (list seq1 seq2))
        ;; ñ��ʰ������ˤ�����
        (tutcode-auto-help-bushu-decompose-by-subtraction c rule)
        ;; ���ʤˤ�����
        (or
          ;; ����1��ľ�����ϲ�ǽ
          ;; ��(����1)��(����2�����ʤȤ��ƻ��Ĵ���)�ˤ���������ǽ��?
          (and seq1 b2
            (or
              (tutcode-auto-help-bushu-decompose-looking-bushudic
                tutcode-bushudic () 99
                (lambda (elem)
                  (tutcode-auto-help-get-stroke-list-with-right-part
                    c b1 b2 seq1 rule elem)))
              ;; ����2�ǤϹ�����ǽ������2�򤵤��ʬ��
              (let
                ((b2dec
                  (tutcode-auto-help-bushu-decompose-tc21 b2 rule stime)))
                (and b2dec
                  (list seq1 b2dec)))))
          ;; ����2��ľ�����ϲ�ǽ
          ;; ��(����2)��(����1�����ʤȤ��ƻ��Ĵ���)�ˤ���������ǽ��?
          (and seq2 b1
            (or
              (tutcode-auto-help-bushu-decompose-looking-bushudic
                tutcode-bushudic () 99
                (lambda (elem)
                  (tutcode-auto-help-get-stroke-list-with-left-part
                    c b1 b2 seq2 rule elem)))
              ;; ����1�ǤϹ�����ǽ������1�򤵤��ʬ��
              (let
                ((b1dec
                  (tutcode-auto-help-bushu-decompose-tc21 b1 rule stime)))
                (and b1dec
                  (list b1dec seq2)))))
          ;; ����1������2��ľ�������ԲĢ������ʬ��
          (and b1 b2
            (let
              ((b1dec (tutcode-auto-help-bushu-decompose-tc21 b1 rule stime))
               (b2dec (tutcode-auto-help-bushu-decompose-tc21 b2 rule stime)))
              (and b1dec b2dec
                (list b1dec b2dec))))
          ;; XXX: ���ʤɤ����ι�����̤�б�
          )))))

;;; ��ư�إ��:�о�ʸ�������Ϥ���ݤ��Ǹ��Υꥹ�Ȥ�������롣
;;; ��: "��" => ((("," "o")) ("��"))
;;; @param b �о�ʸ��
;;; @param rule tutcode-rule
;;; @return �Ǹ��ꥹ�ȡ������Բ�ǽ�ʾ���#f
(define (tutcode-auto-help-get-stroke b rule)
  (let
    ((seq
      (or (tutcode-reverse-find-seq b rule)
          ;; ��������ǻȤ���"3"�Τ褦��ľ�����ϲ�ǽ��������б����뤿�ᡢ
          ;; ��٥�ʸ���˴ޤޤ�Ƥ���С�ľ�����ϲ�ǽ�Ȥߤʤ�
          (and
            (member b tutcode-heading-label-char-list-for-kigou-mode)
            (list b)))))
    (and seq
      (list (list seq) (list b)))))

;;; ��ư�إ��:���������������Ǥ��˸���
;;; �ǽ�˸��Ĥ��ä�2�Ǹ���������Ȥ߹�碌���֤���
;;; (filter��map��Ȥäơ��Ǿ��Υ��ȥ����Τ�Τ�õ���Ȼ��֤�������Τǡ�)
;;; ξ���Ȥ�2�Ǹ���������Ȥ߹�碌�����Ĥ���ʤ��ä��顢
;;; 3�Ǹ�������Ȥ��Ȥ߹�碌��������֤���
;;; @param long-stroke-result 3�Ǹ��ʾ��ʸ����ޤ���
;;; @param min-stroke long-stroke-result��θ��ߤκǾ��Ǹ���
;;; @param get-stroke-list ��������Ѥ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�Ȥ��֤��ؿ�
;;; @return ��������Ѥ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose-looking-bushudic bushudic
          long-stroke-result min-stroke get-stroke-list)
  (if (null? bushudic)
    (and
      (not (null? long-stroke-result))
      long-stroke-result)
    (let*
      ((res
        (get-stroke-list (list min-stroke (car bushudic))))
       (len (if (not res) 99 (tutcode-auto-help-count-stroke-length res)))
       (min (if (< len min-stroke) len min-stroke)))
      (if (<= len 4) ; "5"����Ȥ����������4�Ǹ�̤���⤢�뤬�������ޤǤϸ��ʤ�
        res
        (tutcode-auto-help-bushu-decompose-looking-bushudic (cdr bushudic)
          (if (< len min-stroke) res long-stroke-result)
          min get-stroke-list)))))

;;; ��ư�إ��:�о�ʸ����������ˤ�������������Τ�ɬ�פȤʤ롢
;;; �����Ǥʤ�ʸ���Υꥹ�Ȥ��֤���
;;; ��: "��" => (((("g" "t" "h")) ("��")) ((("G" "I")) ("��")))
;;;    (���Ȥʤ�tutcode-bushudic������Ǥ�((("��" "��")) ("��")))
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose-by-subtraction c rule)
  (tutcode-auto-help-bushu-decompose-looking-bushudic tutcode-bushudic
    () 99
    (lambda (elem)
      (tutcode-auto-help-get-stroke-list-by-subtraction c rule elem))))

;;; ��ư�إ��:���������ɬ�פ��Ǹ����������
;;; @param bushu-compose-list ��������˻Ȥ�2ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ��: (((("g" "t" "h")) ("��")) ((("G" "I")) ("��")))
;;; @return bushu-compose-list�˴ޤޤ���Ǹ�����(�����ξ���5)
(define (tutcode-auto-help-count-stroke-length bushu-compose-list)
  (+ (length (caaar bushu-compose-list))
     (length (caaadr bushu-compose-list))))

;;; ��ư�إ��:�о�ʸ����������ˤ����������Ǥ�����ϡ�
;;; �����˻Ȥ���ʸ���ȡ����Υ��ȥ����Υꥹ�Ȥ��֤���
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @param min-stroke-bushu-list min-stroke��bushudic������ǤΥꥹ�ȡ�
;;;  ��: (6 ((("��" "��")) ("��")))
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  bushu-list��Ȥäƹ����Ǥ��ʤ�����#f��
;;;  ��: (((("g" "t" "h")) ("��")) ((("G" "I")) ("��")))
(define (tutcode-auto-help-get-stroke-list-by-subtraction
          c rule min-stroke-bushu-list)
  (and-let*
    ((min-stroke (car min-stroke-bushu-list))
     (bushu-list (cadr min-stroke-bushu-list))
     (mem (member c (caar bushu-list)))
     (b1 (caadr bushu-list))
     ;; 2�Ĥ�����Τ�����c�ʳ�����������
     (b2 (if (= 2 (length mem)) (cadr mem) (car (caar bushu-list))))
     (seq1 (tutcode-auto-help-get-stroke b1 rule))
     (seq2 (tutcode-auto-help-get-stroke b2 rule))
     (ret (list seq1 seq2))
     ;; ����������٤��Τǡ�����Ǹ���������å�
     (small-stroke? (< (tutcode-auto-help-count-stroke-length ret) min-stroke))
     ;; �ºݤ�����������ơ��о�ʸ������������ʤ���Τ�����
     (composed (tutcode-bushu-convert b1 b2))
     (c-composed? (string=? composed c)))
    ret))

;;; ��ư�إ��:�о�ʸ���������1�פȡ�����2�����ʤȤ��ƻ��Ĵ����פˤ��
;;; ��������Ǥ�����ϡ�
;;; �����˻Ȥ���ʸ���ȡ����Υ��ȥ����Υꥹ�Ȥ��֤���
;;; @param c �о�ʸ��
;;; @param b1 ����1(ľ�����ϲ�ǽ)
;;; @param b2 ����2(ľ�������Բ�ǽ)
;;; @param seq1 b1�����ϥ����������󥹤�����Υꥹ��
;;; @param rule tutcode-rule
;;; @param min-stroke-bushu-list min-stroke��bushudic������ǤΥꥹ�ȡ�
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  bushu-list��Ȥäƹ����Ǥ��ʤ�����#f��
(define (tutcode-auto-help-get-stroke-list-with-right-part
         c b1 b2 seq1 rule min-stroke-bushu-list)
  (and-let*
    ((min-stroke (car min-stroke-bushu-list))
     (bushu-list (cadr min-stroke-bushu-list))
     (mem (member b2 (caar bushu-list)))
     (kanji (caadr bushu-list)) ; ����2�����ʤȤ��ƻ��Ĵ���
     (seq (tutcode-auto-help-get-stroke kanji rule))
     (ret (list seq1 seq))
     ;; ����������٤��Τǡ�����Ǹ���������å�
     (small-stroke? (< (tutcode-auto-help-count-stroke-length ret) min-stroke))
     ;; �ºݤ�����������ơ��о�ʸ������������ʤ���Τ�����
     (composed (tutcode-bushu-convert b1 kanji))
     (c-composed? (string=? composed c)))
    ret))

;;; ��ư�إ��:�о�ʸ���������1�����ʤȤ��ƻ��Ĵ����פȡ�����2�פˤ��
;;; ��������Ǥ�����ϡ�
;;; �����˻Ȥ���ʸ���ȡ����Υ��ȥ����Υꥹ�Ȥ��֤���
;;; @param c �о�ʸ�� (��: "��")
;;; @param b1 ����1(ľ�������Բ�ǽ) (��: "�")
;;; @param b2 ����2(ľ�����ϲ�ǽ) (��: "��")
;;; @param seq2 b2�����ϥ����������󥹤�����Υꥹ�ȡ�
;;;  ��: ((("b" ",")) ("��"))
;;; @param rule tutcode-rule
;;; @param min-stroke-bushu-list min-stroke��bushudic������ǤΥꥹ�ȡ�
;;;  ��: (6 ((("��" "�")) ("��")))
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  bushu-list��Ȥäƹ����Ǥ��ʤ�����#f��
;;;  ��: (((("e" "v" ".")) ("��")) ((("b" ",")) ("��")))
(define (tutcode-auto-help-get-stroke-list-with-left-part
         c b1 b2 seq2 rule min-stroke-bushu-list)
  (and-let*
    ((min-stroke (car min-stroke-bushu-list))
     (bushu-list (cadr min-stroke-bushu-list))
     (mem (member b1 (caar bushu-list)))
     (kanji (caadr bushu-list)) ; ����1�����ʤȤ��ƻ��Ĵ���
     (seq (tutcode-auto-help-get-stroke kanji rule))
     (ret (list seq seq2))
     ;; ����������٤��Τǡ�����Ǹ���������å�
     (small-stroke? (< (tutcode-auto-help-count-stroke-length ret) min-stroke))
     ;; �ºݤ�����������ơ��о�ʸ������������ʤ���Τ�����
     (composed (tutcode-bushu-convert kanji b2))
     (c-composed? (string=? composed c)))
    ret))

;;; ��������Ѵ�����ͽ¬���ϸ���򸡺�
;;; @param str ����1
;;; @param bushudic ��������ꥹ��
;;; @return (<����2> <����ʸ��>)�Υꥹ��
(define (tutcode-bushu-predict str bushudic)
  (if (null? tutcode-bushu-help)
    (set! tutcode-bushu-help (tutcode-bushu-help-load)))
  (let*
    ((rules-help
      (if tutcode-bushu-help
        (rk-lib-find-partial-seqs (list str) tutcode-bushu-help)
        ()))
     (rules-dic (rk-lib-find-partial-seqs (list str) bushudic))
     (rules (append rules-help rules-dic)) ; ��ʣ�����bushu.help¦�ǲ�ǽ
     (words1 (map (lambda (elem) (cadaar elem)) rules))
     ;; (((str ����2))(����ʸ��)) -> (����2 ����ʸ��)
     (word/cand1 (map (lambda (elem) (list (cadaar elem) (caadr elem))) rules))
     (more-cands
      (filter-map
        (lambda (elem)
          (let
            ;; (((����1 ����2))(����ʸ��))
            ((bushu1 (caaar elem))
             (bushu2 (cadaar elem))
             (gosei (caadr elem)))
            (or
              ;; str��1ʸ���ܤξ���rk-lib-find-partial-seqs�Ǹ�����
              ;(string=? str bushu1) ; (((str ����2))(����ʸ��))
              (and (string=? str bushu2) ; (((����1 str))(����ʸ��))
                    ;; ���˾�ǽи��Ѥξ��Ͻ�����
                    ;; ��: ((("��" "��"))("��"))��"��"���и��Ѥξ�硢
                    ;;     ((("��" "��"))("��"))��"��"�Ͻ�����
                   (not (member bushu1 words1))
                   (list bushu1 gosei))
              (and (string=? str gosei) ; (((����1 ����2))(str))
                   ;; XXX:���ξ�硢str��bushu1��bushu2�������Ǥ��뤳�Ȥ�
                   ;;     ��ǧ���٤�������tutcode-bushu-convert���٤��ΤǾ�ά
                   (list bushu1 bushu2)))))
          bushudic)))
    (append word/cand1 more-cands)))

;;; tutcode-rule��հ������ơ��Ѵ����ʸ�����顢���ϥ������������롣
;;; ��: (tutcode-reverse-find-seq "��" tutcode-rule) => ("r" "k")
;;; @param c �Ѵ����ʸ��
;;; @param rule tutcode-rule
;;; @return ���ϥ����Υꥹ�ȡ�tutcode-rule���c�����Ĥ���ʤ��ä�����#f
(define (tutcode-reverse-find-seq c rule)
  (and (string? c)
    (let*
      ((hash-table
        (if (eq? rule tutcode-kigou-rule)
          (begin
            (if (null? tutcode-reverse-kigou-rule-hash-table)
              (set! tutcode-reverse-kigou-rule-hash-table
                (tutcode-rule->reverse-hash-table rule)))
            tutcode-reverse-kigou-rule-hash-table)
          (begin
            (if (null? tutcode-reverse-rule-hash-table)
              (set! tutcode-reverse-rule-hash-table
                (tutcode-rule->reverse-hash-table rule)))
            tutcode-reverse-rule-hash-table)))
       (i (tutcode-euc-jp-string->ichar c)))
      (and i
        (hash-table-ref/default hash-table i #f)))))

;;; ���ߤ�state��preedit����Ĥ��ɤ������֤���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-state-has-preedit? pc)
  (or
    (not (null? (tutcode-context-child-context pc)))
    (memq (tutcode-context-state pc)
      '(tutcode-state-yomi tutcode-state-bushu tutcode-state-converting
        tutcode-state-interactive-bushu tutcode-state-kigou
        tutcode-state-code tutcode-state-history
        tutcode-state-postfix-katakana tutcode-state-postfix-kanji2seq
        tutcode-state-postfix-seq2kanji))))

;;; �����������줿�Ȥ��ν����ο���ʬ����Ԥ���
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-key-press-handler c key key-state)
  (if (ichar-control? key)
      (im-commit-raw c)
      (tutcode-key-press-handler-internal c key key-state)))

;;; �����������줿�Ȥ��ν����ο���ʬ����Ԥ���
;;; (seq2kanji����θƽ��ѡ�ichar-control?ʸ����seq2kanji���̤��Ƥ�Ĥ�褦��)
(define (tutcode-key-press-handler-internal c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (case (tutcode-context-state pc)
      ((tutcode-state-on)
       (let* ((rkc (tutcode-context-rk-context pc))
              (prev-pending-rk (rk-context-seq rkc)))
         (tutcode-proc-state-on pc key key-state)
         (if (or (and tutcode-show-pending-rk?
                      (or (pair? (rk-context-seq rkc))
                          (pair? prev-pending-rk))) ; prev-pending-rk�õ���
               ;; �򤼽��Ѵ�����������Ѵ����ϡ����䢥��ɽ������
               (tutcode-state-has-preedit? c)
               ;; ʸ����������ַ��򤼽��Ѵ��κƵ��ؽ�����󥻥�
               (not (eq? (tutcode-find-descendant-context c) pc)))
           (tutcode-update-preedit pc))))
      ((tutcode-state-kigou)
       (tutcode-proc-state-kigou pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-yomi)
       (tutcode-proc-state-yomi pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-converting)
       (tutcode-proc-state-converting pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-bushu)
       (tutcode-proc-state-bushu pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-interactive-bushu)
       (tutcode-proc-state-interactive-bushu pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-code)
       (tutcode-proc-state-code pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-history)
       (tutcode-proc-state-history pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-postfix-katakana)
       (tutcode-proc-state-postfix-katakana pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-postfix-kanji2seq)
       (tutcode-proc-state-postfix-kanji2seq pc key key-state)
       (tutcode-update-preedit pc))
      ((tutcode-state-postfix-seq2kanji)
       (tutcode-proc-state-postfix-seq2kanji pc key key-state)
       (tutcode-update-preedit pc))
      (else
       (tutcode-proc-state-off pc key key-state)
       (if (or (and tutcode-show-pending-rk?
                    (pair? (rk-context-seq (tutcode-context-rk-context pc))))
               (tutcode-state-has-preedit? c)) ; �Ƶ��ؽ���
         (tutcode-update-preedit pc))))
    (if (or tutcode-use-stroke-help-window?
            (not (eq? tutcode-stroke-help-with-kanji-combination-guide
                      'disable)))
      ;; editor�κ���������β�ǽ��������Τ�descendant-context������ľ��
      (let ((newpc (tutcode-find-descendant-context c)))
        (if
          (and
            (memq (tutcode-context-state newpc)
              '(tutcode-state-on tutcode-state-yomi tutcode-state-bushu
                tutcode-state-interactive-bushu))
            (not (tutcode-context-latin-conv newpc)))
          (tutcode-check-stroke-help-window-begin newpc))))))

;;; ������Υ���줿�Ȥ��ν�����Ԥ���
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-key-release-handler pc key key-state)
  (if (or (ichar-control? key)
	  (not (tutcode-context-on? pc)))
      ;; don't discard key release event for apps
      (im-commit-raw pc)))

;;; TUT-Code IM�ν������Ԥ���
(define (tutcode-init-handler id im arg)
  (let ((tc (tutcode-context-new id im)))
    (set! tutcode-context-list (cons tc tutcode-context-list))
    tc))

(define (tutcode-release-handler tc)
  (tutcode-save-personal-dictionary #f)
  (set! tutcode-context-list (delete! tc tutcode-context-list))
  (if (null? tutcode-context-list)
    (begin
      (skk-lib-free-dic tutcode-dic)
      (set! tutcode-dic #f))))

(define (tutcode-reset-handler tc)
  (tutcode-flush tc))

(define (tutcode-focus-in-handler tc) #f)

(define (tutcode-focus-out-handler c)
  (if (not tutcode-show-pending-rk?)
    (let* ((tc (tutcode-find-descendant-context c))
           (rkc (tutcode-context-rk-context tc)))
      (rk-flush rkc))))

(define tutcode-place-handler tutcode-focus-in-handler)
(define tutcode-displace-handler tutcode-focus-out-handler)

;;; ���䥦����ɥ�������ʸ�����������뤿��˸Ƥִؿ�
(define (tutcode-get-candidate-handler c idx accel-enum-hint)
  (let ((tc (tutcode-find-descendant-context c)))
    (if tutcode-use-pseudo-table-style?
      (let* ((vec (tutcode-context-pseudo-table-cands tc))
             (dl (length (vector-ref vec 0)))
             (page (quotient idx dl))
             (pcands (vector-ref vec page))
             (cands
              (or pcands
                  (let ((cands (tutcode-pseudo-table-style-make-new-page tc)))
                    (vector-set! vec page cands)
                    cands))))
        (list-ref cands (remainder idx dl)))
      (tutcode-get-candidate-handler-internal tc idx accel-enum-hint))))

;;; ���䥦����ɥ�������ʸ�����������뤿��˸Ƥִؿ�
;;; (tutcode-pseudo-table-style-setup����θƤӽФ���)
(define (tutcode-get-candidate-handler-internal tc idx accel-enum-hint)
  (cond
    ;; ��������
    ((eq? (tutcode-context-state tc) 'tutcode-state-kigou)
      (let* ((cand (tutcode-get-nth-candidate-for-kigou-mode tc idx))
             (n (remainder idx
                  (length tutcode-heading-label-char-list-for-kigou-mode)))
             (label (nth n tutcode-heading-label-char-list-for-kigou-mode)))
        ;; XXX:annotationɽ���ϸ���̵��������Ƥ���Τǡ����""���֤��Ƥ���
        (list cand label "")))
    ;; �ҥ��ȥ�����
    ((eq? (tutcode-context-state tc) 'tutcode-state-history)
      (let* ((cand (tutcode-get-nth-candidate-for-history tc idx))
             (n (remainder idx
                  (length tutcode-heading-label-char-list-for-history)))
             (label (nth n tutcode-heading-label-char-list-for-history)))
        (list cand label "")))
    ;; �䴰/ͽ¬���ϸ���
    ((eq? (tutcode-context-candidate-window tc)
          'tutcode-candidate-window-predicting)
      (let*
        ((nr-in-page (tutcode-context-prediction-nr-in-page tc))
         (page-limit (tutcode-context-prediction-page-limit tc))
         (pages (quotient idx page-limit))
         (idx-in-page (remainder idx page-limit)))
        ;; �ƥڡ����ˤϡ�nr-in-page�Ĥ��䴰/ͽ¬���ϸ���ȡ��ϸ쥬���ɤ�ɽ��
        (if (< idx-in-page nr-in-page)
          ;; �䴰/ͽ¬���ϸ���ʸ����
          (let*
            ((nr-predictions (tutcode-lib-get-nr-predictions tc))
             (p-idx (+ idx-in-page (* pages nr-in-page)))
             (i (remainder p-idx nr-predictions))
             (cand (tutcode-lib-get-nth-prediction tc i))
             (word (and (eq? (tutcode-context-predicting tc)
                             'tutcode-predicting-bushu)
                        (tutcode-lib-get-nth-word tc i)))
             (cand-guide
              (if word
                (string-append cand "(" word ")")
                cand))
             (n (remainder p-idx
                  (length tutcode-heading-label-char-list-for-prediction)))
             (label (nth n tutcode-heading-label-char-list-for-prediction)))
            (list cand-guide label ""))
          ;; �ϸ쥬����
          (let*
            ((guide (tutcode-context-guide tc))
             (guide-len (length guide)))
            (if (= guide-len 0)
              (list "" "" "")
              (let*
                ((guide-idx-in-page (- idx-in-page nr-in-page))
                 (nr-guide-in-page (- page-limit nr-in-page))
                 (guide-idx (+ guide-idx-in-page (* pages nr-guide-in-page)))
                 (n (remainder guide-idx guide-len))
                 (label-cands-alist (nth n guide))
                 (label (car label-cands-alist))
                 (cands (cdr label-cands-alist))
                 (cand
                  (string-list-concat
                    (append cands (list tutcode-guide-mark)))))
                (list cand label "")))))))
    ;; ���۸���
    ((eq? (tutcode-context-candidate-window tc)
          'tutcode-candidate-window-stroke-help)
      (nth idx (tutcode-context-stroke-help tc)))
    ;; ��ư�إ��
    ((eq? (tutcode-context-candidate-window tc)
          'tutcode-candidate-window-auto-help)
      (nth idx (tutcode-context-auto-help tc)))
    ;; ����Ū��������Ѵ�
    ((eq? (tutcode-context-state tc) 'tutcode-state-interactive-bushu)
      (let*
        ;; ͽ¬���ϸ������ѿ���ή��
        ((nr-in-page (tutcode-context-prediction-nr-in-page tc))
         (page-limit (tutcode-context-prediction-page-limit tc))
         (pages (quotient idx page-limit))
         (idx-in-page (remainder idx page-limit))
         (nr-predictions (tutcode-lib-get-nr-predictions tc))
         (p-idx (+ idx-in-page (* pages nr-in-page)))
         (i (remainder p-idx nr-predictions))
         (cand (tutcode-lib-get-nth-prediction tc i))
         (n (remainder p-idx
              (length tutcode-heading-label-char-list-for-prediction)))
         (label (nth n tutcode-heading-label-char-list-for-prediction)))
        (list cand label "")))
    ;; �򤼽��Ѵ�
    ((eq? (tutcode-context-candidate-window tc)
          'tutcode-candidate-window-converting)
      (let* ((cand (tutcode-get-nth-candidate tc idx))
             (n (remainder idx (length tutcode-heading-label-char-list)))
             (label (nth n tutcode-heading-label-char-list)))
        (list cand label "")))
    (else
      (list "" "" ""))))

;;; ���䥦����ɥ�����������򤷤��Ȥ��˸Ƥִؿ���
;;; ɽ����θ��䤬���򤵤줿��硢��������������ꤹ�롣
;;; ɽ������Ƥ��ʤ����䤬���򤵤줿(���䥦����ɥ�¦��
;;; �ڡ�����ư���Ԥ�줿)��硢��������������ֹ�򹹿����������
(define (tutcode-set-candidate-index-handler c pidx)
  (let* ((pc (tutcode-find-descendant-context c))
         (candwin (tutcode-context-candidate-window pc))
         (idx (if tutcode-use-pseudo-table-style?
                ;; XXX:����ɽ�����Ǥϡ��ޥ����ˤ����������̤�б���
                ;;     candwin�ڡ�����Υ���å����ϡ��ڡ�����ǽ�θ������
                (tutcode-pseudo-table-style-scm-index pc pidx)
                pidx))
         ;; ���۸��׾�Υ���å��򥭡����ϤȤ��ƽ���(���եȥ����ܡ���)
         (label-to-key-press
          (lambda (label)
            (let ((key (string->ichar label)))
              (if key
                (tutcode-key-press-handler c key 0)))))
         (candlist-to-key-press
          (lambda (candlist)
            (let* ((candlabel (list-ref candlist idx))
                   (label (cadr candlabel)))
              (label-to-key-press label)))))
    (cond
      ((and (memq candwin '(tutcode-candidate-window-converting
                            tutcode-candidate-window-kigou
                            tutcode-candidate-window-history))
          (>= idx 0)
          (< idx (tutcode-context-nr-candidates pc)))
        (let*
          ((prev (tutcode-context-nth pc))
           (state (tutcode-context-state pc))
           (page-limit
            (case state
              ((tutcode-state-kigou) tutcode-nr-candidate-max-for-kigou-mode)
              ((tutcode-state-history) tutcode-nr-candidate-max-for-history)
              (else tutcode-nr-candidate-max)))
           (prev-page (quotient prev page-limit))
           (new-page (quotient idx page-limit)))
          (tutcode-context-set-nth! pc idx)
          (if (= new-page prev-page)
            (case state
              ((tutcode-state-kigou)
                (tutcode-commit pc
                  (tutcode-prepare-commit-string-for-kigou-mode pc)))
              ((tutcode-state-history)
                (let ((str (tutcode-prepare-commit-string-for-history pc)))
                  (tutcode-commit pc str)
                  (tutcode-flush pc)
                  (tutcode-check-auto-help-window-begin pc
                    (string-to-list str) ())))
              (else
                (tutcode-commit-with-auto-help pc))))
          (tutcode-update-preedit pc)))
      ((and (or (eq? candwin 'tutcode-candidate-window-predicting)
                (eq? candwin 'tutcode-candidate-window-interactive-bushu))
            (>= idx 0))
        (let*
          ((nr-in-page (tutcode-context-prediction-nr-in-page pc))
           (page-limit (tutcode-context-prediction-page-limit pc))
           (idx-in-page (remainder idx page-limit))
           (prev (tutcode-context-prediction-index pc))
           (prev-page (quotient prev page-limit))
           (new-page (quotient idx page-limit)))
          (tutcode-context-set-prediction-index! pc idx)
          (if (= new-page prev-page)
            (if (< idx-in-page nr-in-page)
              (let*
                ((nr-predictions (tutcode-lib-get-nr-predictions pc))
                 (p-idx (+ idx-in-page (* new-page nr-in-page)))
                 (i (remainder p-idx nr-predictions))
                 (mode (tutcode-context-predicting pc)))
                (if (eq? candwin 'tutcode-candidate-window-interactive-bushu)
                  (tutcode-do-commit-prediction-for-interactive-bushu pc i)
                  (if (eq? mode 'tutcode-predicting-bushu)
                    (tutcode-do-commit-prediction-for-bushu pc i)
                    (tutcode-do-commit-prediction pc i
                      (eq? mode 'tutcode-predicting-completion)))))
              ;; �ϸ쥬����
              (let*
                ((guide (tutcode-context-guide pc))
                 (guide-len (length guide)))
                (if (positive? guide-len)
                  (let*
                    ((guide-idx-in-page (- idx-in-page nr-in-page))
                     (nr-guide-in-page (- page-limit nr-in-page))
                     (guide-idx (+ guide-idx-in-page
                                   (* new-page nr-guide-in-page)))
                     (n (remainder guide-idx guide-len))
                     (label-cands-alist (nth n guide))
                     (label (car label-cands-alist)))
                    (label-to-key-press label))))))
          (tutcode-update-preedit pc)))
        ((eq? candwin 'tutcode-candidate-window-stroke-help)
          (candlist-to-key-press (tutcode-context-stroke-help pc)))
        ((eq? candwin 'tutcode-candidate-window-auto-help)
          (candlist-to-key-press (tutcode-context-auto-help pc))))))

;;; �ٱ�ɽ�����б����Ƥ�����䥦����ɥ������Ԥ�������λ����
;;; (��������ڡ��������ɽ���������򤵤줿����ǥå����ֹ�)��
;;; �������뤿��˸Ƥִؿ�
;;; @return (nr display-limit selected-index)
(define (tutcode-delay-activating-handler c)
  (let* ((tc (tutcode-find-descendant-context c))
         (selected-index (tutcode-context-candwin-delay-selected-index tc)))
    (tutcode-context-set-candwin-delay-waiting! tc #f)
    (let
      ((res
        (cond
          ((eq? (tutcode-context-state tc) 'tutcode-state-kigou)
            (list tutcode-nr-candidate-max-for-kigou-mode
                  (tutcode-context-nr-candidates tc)))
          ((eq? (tutcode-context-state tc) 'tutcode-state-history)
            (list tutcode-nr-candidate-max-for-history
                  (tutcode-context-nr-candidates tc)))
          ((eq? (tutcode-context-candidate-window tc)
                'tutcode-candidate-window-predicting)
            (case (tutcode-context-state tc)
              ((tutcode-state-bushu)
                (if (tutcode-check-bushu-prediction-make tc
                      (tutcode-context-prediction-bushu tc) #f) ;����ꥹ�Ⱥ���
                  (list (tutcode-context-prediction-page-limit tc)
                        (tutcode-context-prediction-nr-all tc))
                  (list (tutcode-context-prediction-page-limit tc) 0)))
              ((tutcode-state-on)
                (if (tutcode-check-completion-make tc #f 0)
                  (list (tutcode-context-prediction-page-limit tc)
                        (tutcode-context-prediction-nr-all tc))
                  (list (tutcode-context-prediction-page-limit tc) 0)))
              ((tutcode-state-yomi)
                (if (tutcode-check-prediction-make tc #f)
                  (list (tutcode-context-prediction-page-limit tc)
                        (tutcode-context-prediction-nr-all tc))
                  (list (tutcode-context-prediction-page-limit tc) 0)))
              (else
                '(0 0))))
          ((eq? (tutcode-context-candidate-window tc)
                'tutcode-candidate-window-stroke-help)
            (let ((stroke-help (tutcode-stroke-help-make tc)))
              (if (pair? stroke-help)
                (begin
                  (tutcode-context-set-stroke-help! tc stroke-help)
                  (list tutcode-nr-candidate-max-for-kigou-mode
                        (length stroke-help)))
                (list tutcode-nr-candidate-max-for-kigou-mode 0))))
          ((eq? (tutcode-context-candidate-window tc)
                'tutcode-candidate-window-auto-help)
            (let*
              ((tmp (cdr (tutcode-context-auto-help tc)))
               (strlist (car tmp))
               (yomilist (cadr tmp))
               (auto-help (tutcode-auto-help-make tc strlist yomilist)))
              (if (pair? auto-help)
                (begin
                  (tutcode-context-set-auto-help! tc auto-help)
                  (list tutcode-nr-candidate-max-for-kigou-mode
                        (length auto-help)))
                (list tutcode-nr-candidate-max-for-kigou-mode 0))))
          ((eq? (tutcode-context-state tc)
                'tutcode-state-interactive-bushu)
            (list (tutcode-context-prediction-page-limit tc)
                  (tutcode-context-prediction-nr-all tc)))
          ((eq? (tutcode-context-candidate-window tc)
                'tutcode-candidate-window-converting)
            (list tutcode-nr-candidate-max
                  (tutcode-context-nr-candidates tc)))
          (else
            (list tutcode-nr-candidate-max 0)))))
      (reverse
        (if (and tutcode-use-pseudo-table-style?
                 (> (cadr res) 0)) ; nr��0�ξ���candwin��ɽ������ʤ�
          (let ((pres
                  (tutcode-pseudo-table-style-setup tc (cadr res) (car res))))
            ;; candwin-index��setup�ƽи�˸Ƥ�ɬ�פ���
            (cons (tutcode-pseudo-table-style-candwin-index tc selected-index)
                    (reverse pres)))
          (cons selected-index res))))))

(tutcode-configure-widgets)

;;; TUT-Code IM����Ͽ���롣
(register-im
 'tutcode
 "ja"
 "EUC-JP"
 tutcode-im-name-label
 tutcode-im-short-desc
 #f
 tutcode-init-handler
 tutcode-release-handler
 context-mode-handler
 tutcode-key-press-handler
 tutcode-key-release-handler
 tutcode-reset-handler
 tutcode-get-candidate-handler
 tutcode-set-candidate-index-handler
 context-prop-activate-handler
 #f
 tutcode-focus-in-handler
 tutcode-focus-out-handler
 tutcode-place-handler
 tutcode-displace-handler
 )

;;; ������ɽ���Ѵ����롣
;;; @param from �Ѵ��оݥ�����ɽ
;;; @param translate-alist �Ѵ�ɽ
;;; @return �Ѵ�����������ɽ
(define (tutcode-rule-translate from translate-alist)
  (map
    (lambda (elem)
      (cons
        (list
          (map
            (lambda (key)
              (let ((res (assoc key translate-alist)))
                (if res
                  (cadr res)
                  key)))
            (caar elem)))
        (cdr elem)))
    from))

;;; ������ɽ��Qwerty����Dvorak�Ѥ��Ѵ����롣
;;; @param qwerty Qwerty�Υ�����ɽ
;;; @return Dvorak���Ѵ�����������ɽ
(define (tutcode-rule-qwerty-to-dvorak qwerty)
  (tutcode-rule-translate qwerty tutcode-rule-qwerty-to-dvorak-alist))

;;; ������ɽ��Qwerty-jis����Qwerty-us�Ѥ��Ѵ����롣
;;; @param jis Qwerty-jis�Υ�����ɽ
;;; @return Qwerty-us���Ѵ�����������ɽ
(define (tutcode-rule-qwerty-jis-to-qwerty-us jis)
  (tutcode-rule-translate jis tutcode-rule-qwerty-jis-to-qwerty-us-alist))

;;; kigou-rule�򥭡��ܡ��ɥ쥤�����Ȥ˹�碌���Ѵ�����
;;; @param layout tutcode-candidate-window-table-layout
(define (tutcode-kigou-rule-translate layout)
  (let
    ((translate-stroke-help-alist
      (lambda (lis translate-alist)
        (map
          (lambda (elem)
            (cons
              (let ((res (assoc (car elem) translate-alist)))
                (if res
                  (cadr res)
                  (car elem)))
              (cdr elem)))
          lis))))
    (case layout
      ((qwerty-us)
        (set! tutcode-kigou-rule
          (tutcode-rule-qwerty-jis-to-qwerty-us
            (tutcode-kigou-rule-pre-translate
              tutcode-rule-qwerty-jis-to-qwerty-us-alist)))
        (set! tutcode-kigou-rule-stroke-help-top-page-alist
          (translate-stroke-help-alist 
            tutcode-kigou-rule-stroke-help-top-page-alist
            tutcode-rule-qwerty-jis-to-qwerty-us-alist)))
      ((dvorak)
        (set! tutcode-kigou-rule
          (tutcode-rule-qwerty-to-dvorak
            (tutcode-kigou-rule-pre-translate
              tutcode-rule-qwerty-to-dvorak-alist)))
        (set! tutcode-kigou-rule-stroke-help-top-page-alist
          (translate-stroke-help-alist 
            tutcode-kigou-rule-stroke-help-top-page-alist
            tutcode-rule-qwerty-to-dvorak-alist))))))

;;; Qwerty-jis����Qwerty-us�ؤ��Ѵ��ơ��֥롣
(define tutcode-rule-qwerty-jis-to-qwerty-us-alist
  '(
    ("^" "=")
    ("@" "[")
    ("[" "]")
    (":" "'")
    ("]" "`")
    ("\"" "@")
    ("'" "&")
    ("&" "^")
    ("(" "*")
    (")" "(")
    ("|" ")") ;tutcode-kigou-rule�ѡ�<Shift>0��qwerty-jis�Ǥ�|�����Ѥ��Ƥ�Τ�
    ("=" "_")
    ("~" "+")
    ("_" "|") ;XXX
    ("`" "{")
    ("{" "}")
    ("+" ":")
    ("*" "\"")
    ("}" "~")))

;;; Qwerty����Dvorak�ؤ��Ѵ��ơ��֥롣
(define tutcode-rule-qwerty-to-dvorak-alist
  '(
    ;("1" "1")
    ;("2" "2")
    ;("3" "3")
    ;("4" "4")
    ;("5" "5")
    ;("6" "6")
    ;("7" "7")
    ;("8" "8")
    ;("9" "9")
    ;("0" "0")
    ("-" "[")
    ("^" "]") ;106
    ("q" "'")
    ("w" ",")
    ("e" ".")
    ("r" "p")
    ("t" "y")
    ("y" "f")
    ("u" "g")
    ("i" "c")
    ("o" "r")
    ("p" "l")
    ("@" "/") ;106
    ("[" "=") ;106
    ;("a" "a")
    ("s" "o")
    ("d" "e")
    ("f" "u")
    ("g" "i")
    ("h" "d")
    ("j" "h")
    ("k" "t")
    ("l" "n")
    (";" "s")
    (":" "-") ;106
    ("]" "`")
    ("z" ";")
    ("x" "q")
    ("c" "j")
    ("v" "k")
    ("b" "x")
    ("n" "b")
    ;("m" "m")
    ("," "w")
    ("." "v")
    ("/" "z")
    ;(" " " ")
    ;; shift
    ;("!" "!")
    ("\"" "@") ;106
    ;("#" "#")
    ;("$" "$")
    ;("%" "%")
    ("&" "^") ;106
    ("'" "&") ;106
    ("(" "*") ;106
    (")" "(") ;106
    ("=" "{") ;106
    ("~" "}") ;106
    ("|" ")") ;tutcode-kigou-rule�ѡ�<Shift>0��qwerty-jis�Ǥ�|�����Ѥ��Ƥ�Τ�
    ("_" "|") ;XXX
    ("Q" "\"")
    ("W" "<")
    ("E" ">")
    ("R" "P")
    ("T" "Y")
    ("Y" "F")
    ("U" "G")
    ("I" "C")
    ("O" "R")
    ("P" "L")
    ("`" "?") ;106
    ("{" "+") ;106
    ;("A" "A")
    ("S" "O")
    ("D" "E")
    ("F" "U")
    ("G" "I")
    ("H" "D")
    ("J" "H")
    ("K" "T")
    ("L" "N")
    ("+" "S") ;106
    ("*" "_") ;106
    ("}" "~")
    ("Z" ":")
    ("X" "Q")
    ("C" "J")
    ("V" "K")
    ("B" "X")
    ("N" "B")
    ;("M" "M")
    ("<" "W")
    (">" "V")
    ("?" "Z")
    ))

;;; tutcode-custom�����ꤵ�줿������ɽ�Υե�����̾���饳����ɽ̾���äơ�
;;; ���Ѥ��륳����ɽ�Ȥ������ꤹ�롣
;;; �������륳����ɽ̾�ϡ��ե�����̾����".scm"�򤱤��äơ�
;;; "-rule"���Ĥ��Ƥʤ��ä����ɲä�����Ρ�
;;; ��: "tutcode-rule.scm"��tutcode-rule
;;;     "tcode.scm"��tcode-rule
;;; @param filename tutcode-rule-filename
(define (tutcode-custom-load-rule! filename)
  (and
    (try-load filename)
    (let*
      ((basename (last (string-split filename "/")))
       ;; �ե�����̾����".scm"�򤱤���
       (bnlist (string-to-list basename))
       (codename
        (or
          (and
            (> (length bnlist) 4)
            (string=? (string-list-concat (list-head bnlist 4)) ".scm")
            (string-list-concat (list-tail bnlist 4)))
          basename))
       ;; "-rule"���Ĥ��Ƥʤ��ä����ɲ�
       (rulename
        (or
          (and
            (not (string=? (last (string-split codename "-")) "rule"))
            (string-append codename "-rule"))
          codename)))
      (and rulename
        (symbol-bound? (string->symbol rulename))
        (set! tutcode-rule
          (eval (string->symbol rulename) (interaction-environment)))))))

;;; tutcode-key-custom�����ꤵ�줿�򤼽�/��������Ѵ����ϤΥ����������󥹤�
;;; ������ɽ��ȿ�Ǥ���
(define (tutcode-custom-set-mazegaki/bushu-start-sequence!)
  (let
    ((make-subrule
      (lambda (keyseq cmd)
        (and keyseq
             (> (string-length keyseq) 0))
          (let ((keys (reverse (string-to-list keyseq))))
            (list (list keys) cmd)))))
    (tutcode-rule-set-sequences!
      (filter
        pair?
        (list
          (make-subrule tutcode-katakana-sequence
            (list
              (lambda (state pc) (tutcode-context-set-katakana-mode! pc #t))))
          (make-subrule tutcode-hiragana-sequence
            (list
              (lambda (state pc) (tutcode-context-set-katakana-mode! pc #f))))
          (make-subrule tutcode-mazegaki-start-sequence
            '(tutcode-mazegaki-start))
          (make-subrule tutcode-latin-conv-start-sequence
            '(tutcode-latin-conv-start))
          (make-subrule tutcode-kanji-code-input-start-sequence
            '(tutcode-kanji-code-input-start))
          (make-subrule tutcode-history-start-sequence
            '(tutcode-history-start))
          (make-subrule tutcode-bushu-start-sequence
            '(tutcode-bushu-start))
          (and
            tutcode-use-interactive-bushu-conversion?
            (make-subrule tutcode-interactive-bushu-start-sequence
              '(tutcode-interactive-bushu-start)))
          (make-subrule tutcode-postfix-bushu-start-sequence
            '(tutcode-postfix-bushu-start))
          (make-subrule tutcode-selection-mazegaki-start-sequence
            '(tutcode-selection-mazegaki-start))
          (make-subrule tutcode-selection-mazegaki-inflection-start-sequence
            '(tutcode-selection-mazegaki-inflection-start))
          (make-subrule tutcode-selection-katakana-start-sequence
            '(tutcode-selection-katakana-start))
          (make-subrule tutcode-selection-kanji2seq-start-sequence
            '(tutcode-selection-kanji2seq-start))
          (make-subrule tutcode-selection-seq2kanji-start-sequence
            '(tutcode-selection-seq2kanji-start))
          (make-subrule tutcode-clipboard-seq2kanji-start-sequence
            '(tutcode-clipboard-seq2kanji-start))
          (make-subrule tutcode-postfix-mazegaki-start-sequence
            '(tutcode-postfix-mazegaki-start))
          (make-subrule tutcode-postfix-mazegaki-1-start-sequence
            '(tutcode-postfix-mazegaki-1-start))
          (make-subrule tutcode-postfix-mazegaki-2-start-sequence
            '(tutcode-postfix-mazegaki-2-start))
          (make-subrule tutcode-postfix-mazegaki-3-start-sequence
            '(tutcode-postfix-mazegaki-3-start))
          (make-subrule tutcode-postfix-mazegaki-4-start-sequence
            '(tutcode-postfix-mazegaki-4-start))
          (make-subrule tutcode-postfix-mazegaki-5-start-sequence
            '(tutcode-postfix-mazegaki-5-start))
          (make-subrule tutcode-postfix-mazegaki-6-start-sequence
            '(tutcode-postfix-mazegaki-6-start))
          (make-subrule tutcode-postfix-mazegaki-7-start-sequence
            '(tutcode-postfix-mazegaki-7-start))
          (make-subrule tutcode-postfix-mazegaki-8-start-sequence
            '(tutcode-postfix-mazegaki-8-start))
          (make-subrule tutcode-postfix-mazegaki-9-start-sequence
            '(tutcode-postfix-mazegaki-9-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-start-sequence
            '(tutcode-postfix-mazegaki-inflection-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-1-start-sequence
            '(tutcode-postfix-mazegaki-inflection-1-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-2-start-sequence
            '(tutcode-postfix-mazegaki-inflection-2-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-3-start-sequence
            '(tutcode-postfix-mazegaki-inflection-3-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-4-start-sequence
            '(tutcode-postfix-mazegaki-inflection-4-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-5-start-sequence
            '(tutcode-postfix-mazegaki-inflection-5-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-6-start-sequence
            '(tutcode-postfix-mazegaki-inflection-6-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-7-start-sequence
            '(tutcode-postfix-mazegaki-inflection-7-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-8-start-sequence
            '(tutcode-postfix-mazegaki-inflection-8-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-9-start-sequence
            '(tutcode-postfix-mazegaki-inflection-9-start))
          (make-subrule tutcode-postfix-katakana-start-sequence
            '(tutcode-postfix-katakana-start))
          (make-subrule tutcode-postfix-katakana-0-start-sequence
            '(tutcode-postfix-katakana-0-start))
          (make-subrule tutcode-postfix-katakana-1-start-sequence
            '(tutcode-postfix-katakana-1-start))
          (make-subrule tutcode-postfix-katakana-2-start-sequence
            '(tutcode-postfix-katakana-2-start))
          (make-subrule tutcode-postfix-katakana-3-start-sequence
            '(tutcode-postfix-katakana-3-start))
          (make-subrule tutcode-postfix-katakana-4-start-sequence
            '(tutcode-postfix-katakana-4-start))
          (make-subrule tutcode-postfix-katakana-5-start-sequence
            '(tutcode-postfix-katakana-5-start))
          (make-subrule tutcode-postfix-katakana-6-start-sequence
            '(tutcode-postfix-katakana-6-start))
          (make-subrule tutcode-postfix-katakana-7-start-sequence
            '(tutcode-postfix-katakana-7-start))
          (make-subrule tutcode-postfix-katakana-8-start-sequence
            '(tutcode-postfix-katakana-8-start))
          (make-subrule tutcode-postfix-katakana-9-start-sequence
            '(tutcode-postfix-katakana-9-start))
          (make-subrule tutcode-postfix-katakana-exclude-1-sequence
            '(tutcode-postfix-katakana-exclude-1))
          (make-subrule tutcode-postfix-katakana-exclude-2-sequence
            '(tutcode-postfix-katakana-exclude-2))
          (make-subrule tutcode-postfix-katakana-exclude-3-sequence
            '(tutcode-postfix-katakana-exclude-3))
          (make-subrule tutcode-postfix-katakana-exclude-4-sequence
            '(tutcode-postfix-katakana-exclude-4))
          (make-subrule tutcode-postfix-katakana-exclude-5-sequence
            '(tutcode-postfix-katakana-exclude-5))
          (make-subrule tutcode-postfix-katakana-exclude-6-sequence
            '(tutcode-postfix-katakana-exclude-6))
          (make-subrule tutcode-postfix-katakana-shrink-1-sequence
            '(tutcode-postfix-katakana-shrink-1))
          (make-subrule tutcode-postfix-katakana-shrink-2-sequence
            '(tutcode-postfix-katakana-shrink-2))
          (make-subrule tutcode-postfix-katakana-shrink-3-sequence
            '(tutcode-postfix-katakana-shrink-3))
          (make-subrule tutcode-postfix-katakana-shrink-4-sequence
            '(tutcode-postfix-katakana-shrink-4))
          (make-subrule tutcode-postfix-katakana-shrink-5-sequence
            '(tutcode-postfix-katakana-shrink-5))
          (make-subrule tutcode-postfix-katakana-shrink-6-sequence
            '(tutcode-postfix-katakana-shrink-6))
          (make-subrule tutcode-postfix-kanji2seq-start-sequence
            '(tutcode-postfix-kanji2seq-start))
          (make-subrule tutcode-postfix-kanji2seq-1-start-sequence
            '(tutcode-postfix-kanji2seq-1-start))
          (make-subrule tutcode-postfix-kanji2seq-2-start-sequence
            '(tutcode-postfix-kanji2seq-2-start))
          (make-subrule tutcode-postfix-kanji2seq-3-start-sequence
            '(tutcode-postfix-kanji2seq-3-start))
          (make-subrule tutcode-postfix-kanji2seq-4-start-sequence
            '(tutcode-postfix-kanji2seq-4-start))
          (make-subrule tutcode-postfix-kanji2seq-5-start-sequence
            '(tutcode-postfix-kanji2seq-5-start))
          (make-subrule tutcode-postfix-kanji2seq-6-start-sequence
            '(tutcode-postfix-kanji2seq-6-start))
          (make-subrule tutcode-postfix-kanji2seq-7-start-sequence
            '(tutcode-postfix-kanji2seq-7-start))
          (make-subrule tutcode-postfix-kanji2seq-8-start-sequence
            '(tutcode-postfix-kanji2seq-8-start))
          (make-subrule tutcode-postfix-kanji2seq-9-start-sequence
            '(tutcode-postfix-kanji2seq-9-start))
          (make-subrule tutcode-postfix-seq2kanji-start-sequence
            '(tutcode-postfix-seq2kanji-start))
          (make-subrule tutcode-postfix-seq2kanji-1-start-sequence
            '(tutcode-postfix-seq2kanji-1-start))
          (make-subrule tutcode-postfix-seq2kanji-2-start-sequence
            '(tutcode-postfix-seq2kanji-2-start))
          (make-subrule tutcode-postfix-seq2kanji-3-start-sequence
            '(tutcode-postfix-seq2kanji-3-start))
          (make-subrule tutcode-postfix-seq2kanji-4-start-sequence
            '(tutcode-postfix-seq2kanji-4-start))
          (make-subrule tutcode-postfix-seq2kanji-5-start-sequence
            '(tutcode-postfix-seq2kanji-5-start))
          (make-subrule tutcode-postfix-seq2kanji-6-start-sequence
            '(tutcode-postfix-seq2kanji-6-start))
          (make-subrule tutcode-postfix-seq2kanji-7-start-sequence
            '(tutcode-postfix-seq2kanji-7-start))
          (make-subrule tutcode-postfix-seq2kanji-8-start-sequence
            '(tutcode-postfix-seq2kanji-8-start))
          (make-subrule tutcode-postfix-seq2kanji-9-start-sequence
            '(tutcode-postfix-seq2kanji-9-start))
          (make-subrule tutcode-auto-help-redisplay-sequence
            '(tutcode-auto-help-redisplay))
          (make-subrule tutcode-auto-help-dump-sequence
            (list tutcode-auto-help-dump))
          (make-subrule tutcode-help-sequence
            '(tutcode-help))
          (make-subrule tutcode-help-clipboard-sequence
            '(tutcode-help-clipboard))
          (make-subrule tutcode-undo-sequence
            '(tutcode-undo)))))))

;;; ������ɽ�ΰ�������������ѹ�/�ɲä��롣~/.uim����λ��Ѥ����ꡣ
;;; �ƤӽФ����ˤ�tutcode-rule-userconfig����Ͽ���Ƥ��������ǡ�
;;; �ºݤ˥�����ɽ��ȿ�Ǥ���Τϡ�tutcode-context-new����
;;;
;;; (tutcode-rule-filename�����꤬��uim-pref��~/.uim�Τɤ���ǹԤ�줿���Ǥ�
;;;  ~/.uim�ǤΥ�����ɽ�ΰ����ѹ���Ʊ�����ҤǤǤ���褦�ˤ��뤿�ᡣ
;;;  ������ɽ���ɸ��hook���Ѱդ���������������)��
;;;
;;; �ƤӽФ���:
;;;   (tutcode-rule-set-sequences!
;;;     '(((("d" "l" "u")) ("��" "��"))
;;;       ((("d" "l" "d" "u")) ("��" "��"))))
;;; @param rules �����������󥹤����Ϥ����ʸ���Υꥹ��
(define (tutcode-rule-set-sequences! rules)
  (set! tutcode-rule-userconfig
    (append rules tutcode-rule-userconfig)))

;;; ������ɽ�ξ���ѹ�/�ɲäΤ����tutcode-rule-userconfig��
;;; ������ɽ��ȿ�Ǥ��롣
(define (tutcode-rule-commit-sequences! rules)
  (let* ((newseqs ()) ;�����ɲä��륭����������
         ;; ������ɽ��λ��ꥷ�����󥹤����Ϥ����ʸ�����ѹ����롣
         ;; seq ������������
         ;; kanji ���Ϥ����ʸ����car���Ҥ餬�ʥ⡼���ѡ�cadr���������ʥ⡼����
         (setseq1!
          (lambda (elem)
            (let* ((seq (caar elem))
                   (kanji (cadr elem))
                   (curseq (rk-lib-find-seq seq tutcode-rule))
                   (pair (and curseq (cadr curseq))))
              (if (and pair (pair? pair))
                (begin
                  (set-car! pair (car kanji))
                  (if (not (null? (cdr kanji)))
                    (if (< (length pair) 2)
                      (set-cdr! pair (list (cadr kanji)))
                      (set-car! (cdr pair) (cadr kanji)))))
                (begin
                  ;; ������ɽ��˻��ꤵ�줿�����������󥹤������̵��
                  (set! newseqs (append newseqs (list elem)))))))))
    (for-each setseq1! rules)
    ;; �����ɲå�������
    (if (not (null? newseqs))
      (set! tutcode-rule (append tutcode-rule newseqs)))))

;;; selection���Ф��ƻ��ꤵ�줿������Ŭ�Ѥ�����̤��ִ����롣
;;; ~/.uim�Ǥλ�����:
;;; (require "external-filter.scm")
;;; (define (tutcode-filter-fmt-quote state pc)
;;;   (tutcode-selection-filter pc
;;;     (lambda (str)
;;;       ;; ʸ�������塢���ѥޡ������Ƭ���դ��� (nkf -e: uim-tutcode��EUC-JP)
;;;       (external-filter-launch-command "nkf -e -f | sed -e 's/^/> /'" str))))
;;; (require "fmt-ja.scm")
;;; (define (tutcode-filter-fmt-ja state pc)
;;;   (tutcode-selection-filter pc
;;;     (lambda (str)
;;;       (apply string-append (fmt-ja-str str)))))
;;; (require "japan-util.scm")
;;; (define (tutcode-filter-ascii-fullkana state pc)
;;;   (tutcode-selection-filter pc
;;;     (lambda (str)
;;;       (string-list-concat
;;;         (japan-util-ascii-convert
;;;           (japan-util-halfkana-to-fullkana-convert
;;;             (string-to-list str)))))))
;;; (tutcode-rule-set-sequences!
;;;   `(((("a" "v" "q")) (,tutcode-filter-fmt-quote))
;;;     ((("a" "v" "f")) (,tutcode-filter-fmt-ja))
;;;     ((("a" "v" "a")) (,tutcode-filter-ascii-fullkana))))
;;; @param fn �ե��륿�����ؿ���ʸ��������Ϥ˼�ꡢ��̤�ʸ������֤���
(define (tutcode-selection-filter pc fn)
  (let ((sel (tutcode-selection-acquire-text pc)))
    (if (pair? sel)
      (let* ((str (string-list-concat sel))
             (res (fn str)))
        (if (and (string? res)
                 ;; �ѹ�̵���ʤ�commit���ʤ�(���쥯����󤬲������ʤ��褦��)
                 (not (string=? res str)))
          (tutcode-selection-commit pc res sel))))))
