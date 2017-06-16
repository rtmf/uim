/*
  Copyright (c) 2008-2013 uim Project https://github.com/uim/uim

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
  3. Neither the name of authors nor the names of its contributors
  may be used to endorse or promote products derived from this software
  without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

*/
/* $Id: wnnlib.h,v 10.8 1999/05/25 06:21:10 ishisone Exp $ */

/*
 *	wnnlib.h -- wnnlib $BMQ%X%C%@%U%!%$%k(B (Wnn Version4/6 $BBP1~HG(B)
 *		version 5.0
 *		ishisone@sra.co.jp
 */

/*
 * Copyright (c) 1989  Software Research Associates, Inc.
 * Copyright (c) 1998  MORIBE, Hideyuki
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of Software Research Associates not be
 * used in advertising or publicity pertaining to distribution of the
 * software without specific, written prior permission.  Software Research
 * Associates makes no representations about the suitability of this software
 * for any purpose.  It is provided "as is" without express or implied
 * warranty.
 *
 * Author:  Makoto Ishisone, Software Research Associates, Inc., Japan
 *          MORIBE, Hideyuki
 */

#ifndef _wnnlib_h
#define _wnnlib_h

#include <config.h>

#include	<commonhd.h>
#include	<jllib.h>
#include	<wnnerror.h>

#include "uim.h"
#include "uim-scm.h"

#ifndef WCHAR_DEFINED
#define WCHAR_DEFINED
#undef wchar
typedef unsigned short wchar;
#endif


/* $BDj?t(B */
#define JC_FORWARD	1
#define JC_BACKWARD	0
#define JC_NEXT		0
#define JC_PREV		1
#define JC_HIRAGANA	0
#define JC_KATAKANA	1

/* $B%(%i!<HV9f(B */
#define JE_NOERROR		0
#define JE_WNNERROR		1	/* jllib $B$N%(%i!<(B */
#define JE_NOCORE		2	/* $B%a%b%j$,3NJ]$G$-$J$$(B */
#define JE_NOTCONVERTED		3	/* $BBP>]J8@a$,$^$@JQ49$5$l$F$$$J$$(B */
#define JE_CANTDELETE		4	/* $B%P%C%U%!$N@hF,$NA0!"$"$k$$$O(B
					 * $B:G8e$N<!$NJ8;z$r:o=|$7$h$&$H$7$?(B */
#define JE_NOSUCHCLAUSE		5	/* $B;XDj$5$l$?HV9f$NJ8@a$,B8:_$7$J$$(B */
#define JE_CANTSHRINK		6	/* 1 $BJ8;z$NJ8@a$r=L$a$h$&$H$7$?(B */
#define JE_CANTEXPAND		7	/* $B:G8e$NJ8@a$r?-$P$=$&$H$7$?(B */
#define JE_NOCANDIDATE		8	/* $B<!8uJd$,$J$$(B */
#define JE_NOSUCHCANDIDATE	9	/* $B;XDj$5$l$?HV9f$N8uJd$,B8:_$7$J$$(B */
#define JE_CANTMOVE		10	/* $B%P%C%U%!$N@hF,$NA0!"$"$k$$$O(B
					 * $B:G8e$N<!$K0\F0$7$h$&$H$7$?(B */
#define JE_CLAUSEEMPTY		11	/* $B6u$NJ8$rJQ49$7$h$&$H$7$?(B */
#define JE_ALREADYFIXED		12	/* $B$9$G$K3NDj$5$l$F$$$kJ8$KBP$7$F(B
					 * $BA`:n$r9T$J$C$?(B */

/* $B%(%i!<HV9f(B */
extern int	jcErrno;	/* $B%(%i!<HV9f(B */

/* $B%G!<%?%?%$%W(B */

/* $B3F>.J8@a$N>pJs(B */
typedef struct {
	wchar	*kanap;		/* $BFI$_J8;zNs(B */
	wchar	*dispp;		/* $BI=<(J8;zNs(B */
	char	conv;		/* $BJQ49:Q$_$+(B */
				/* 0: $BL$JQ49(B 1: $BJQ49:Q(B -1: $B$G5?;wJQ49(B */
	char	ltop;		/* $BBgJ8@a$N@hF,$+(B? */
} jcClause;


/* $B:n6H0h(B */
typedef struct {
    /* public member */
	int		nClause;	/* $BJ8@a?t(B */
	int		curClause;	/* $B%+%l%s%HJ8@aHV9f(B */
	int		curLCStart;	/* $B%+%l%s%HBgJ8@a3+;OJ8@aHV9f(B */
	int		curLCEnd;	/* $B%+%l%s%HBgJ8@a=*N;J8@aHV9f(B */
	wchar		*kanaBuf;	/* $B$+$J%P%C%U%!(B */
	wchar		*kanaEnd;
	wchar		*displayBuf;	/* $B%G%#%9%W%l%$%P%C%U%!(B */
	wchar		*displayEnd;
	jcClause	*clauseInfo;	/* $BJ8@a>pJs(B */
	struct wnn_buf	*wnn;
    /* private member */
	int		fixed;		/* $B3NDj$5$l$?$+$I$&$+(B */
	wchar		*dot;		/* $B%I%C%H$N0LCV(B */
	int		candKind;	/* $BBgJ8@a$NA48uJd$+>.J8@a$N8uJd$+$r(B
					   $BI=$9%U%i%0(B */
	int		candClause;	/* $BA48uJd$r$H$C$F$$$kJ8@aHV9f(B */
	int		candClauseEnd;	/* $BBgJ8@a$NA48uJd$N;~!"=*N;J8@aHV9f(B */
	int		bufferSize;	/* kanaBuf/displayBuf $B$NBg$-$5(B */
	int		clauseSize;	/* clauseInfo $B$NBg$-$5(B */
} jcConvBuf;

struct wnn_buf *jcOpen(char *, char *, int, char *, void (*)(), int (*)(), int);
struct wnn_buf *jcOpen2(char *, char *, int, char *, char *, void (*)(), int (*)(), int);
void jcClose(struct wnn_buf *);
int jcIsConnect(struct wnn_buf *);
jcConvBuf *jcCreateBuffer(struct wnn_buf *, int, int);
int jcDestroyBuffer(jcConvBuf *, int);
int jcClear(jcConvBuf *);
int jcInsertChar(jcConvBuf *, int);
int jcDeleteChar(jcConvBuf *, int);
int jcKillLine(jcConvBuf *);
int jcConvert(jcConvBuf *, int, int, int);
int jcUnconvert(jcConvBuf *);
int jcCancel(jcConvBuf *);
int jcExpand(jcConvBuf *, int, int);
int jcShrink(jcConvBuf *, int, int);
int jcKana(jcConvBuf *, int, int);
int jcFix(jcConvBuf *);
int jcFix1(jcConvBuf *);
int jcNext(jcConvBuf *, int, int);
int jcCandidateInfo(jcConvBuf *, int, int *, int *);
int jcGetCandidate(jcConvBuf *, int, wchar *, int);
int jcSelect(jcConvBuf *, int);
int jcDotOffset(jcConvBuf *);
int jcIsConverted(jcConvBuf *, int);
int jcMove(jcConvBuf *, int, int);
int jcTop(jcConvBuf *);
int jcBottom(jcConvBuf *);
int jcChangeClause(jcConvBuf *, wchar *);
int jcSaveDic(jcConvBuf *);

#endif /* _wnnlib_h */
