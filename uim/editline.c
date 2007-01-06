/*

  Copyright (c) 2003-2007 uim Project http://uim.freedesktop.org/

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

/*
 * Currently defined as 1 to be compatible with previous code. If no
 * distro packagers need this, please remove
 */
#define UIM_EDITLINE_SEPARATED_BUILD 1

#include <histedit.h>

#if UIM_EDITLINE_SEPARATED_BUILD
#include <uim/uim.h>
#include <uim/uim-scm.h>
#include <uim/uim-compat-scm.h>
#include <uim/plugin.h>
#else
#include "uim.h"
#include "uim-scm.h"
#include "uim-compat-scm.h"
#include "plugin.h"
#endif

#include "editline.h"

static EditLine *el;
static History *hist;
static HistEvent hev;
static uim_lisp uim_editline_readline(void);
static char *prompt(EditLine *e);

#if UIM_SCM_GCC4_READY_GC
static void *uim_editline_readline_internal(void *dummy);
#endif

void
editline_init(void)
{
  el = el_init("uim", stdin, stdout, stderr);
  el_set(el, EL_PROMPT, &prompt);
  el_set(el, EL_EDITOR, "emacs");

  hist = history_init();
  history(hist, &hev, H_SETSIZE, 100);
  el_set(el, EL_HIST, history, hist);
  el_source(el, NULL);

  uim_scm_init_subr_0("uim-editline-readline", uim_editline_readline);
}

void
editline_quit(void)
{
    history_end(hist);
    el_end(el);
}

static uim_lisp
uim_editline_readline(void)
#if UIM_SCM_GCC4_READY_GC
{
  return (uim_lisp)uim_scm_call_with_gc_ready_stack(uim_editline_readline_internal, NULL);
}

static void *
uim_editline_readline_internal(void *dummy)
#endif
{
    const char *line;
    int count = 0;
#if !UIM_SCM_GCC4_READY_GC
    uim_lisp stack_start;
#endif
    uim_lisp ret;

#if !UIM_SCM_GCC4_READY_GC
    uim_scm_gc_protect_stack(&stack_start);
#endif

    line = el_gets(el, &count);

    if(count > 0 && line) {
	history(hist, &hev, H_ENTER, line);
	ret = uim_scm_make_str(line);
    } else {
	ret = uim_scm_make_str("");
    }

#if UIM_SCM_GCC4_READY_GC
    return (void *)ret;
#else
    uim_scm_gc_unprotect_stack(&stack_start);

    return ret;
#endif
}

static char *prompt(EditLine *e) {
    char *p;

    p = uim_scm_symbol_value_str("uim-sh-prompt"); /* XXX */

    if(!p)
	return "uim-sh> ";
    else
	return p;
}
