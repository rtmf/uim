/*

 Copyright (c) 2006 uim Project http://uim.freedesktop.org/

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

#include <stdlib.h>

#include <kglobal.h>
#include <klocale.h>

#include "toolbar-applet-kde.h"
#include "toolbar-common-quimhelpertoolbar.h"
#include "toolbar-common-uimstateindicator.h"

#include "uim.h"

extern "C"
{
    KDE_EXPORT KPanelApplet* init(QWidget *parent, const QString& configFile)
    {
	KGlobal::locale()->insertCatalogue("uimapplet");

	return new UimApplet(configFile, KPanelApplet::Normal,
			     KPanelApplet::Preferences, parent, "uimapplet");
    }
}

UimApplet::UimApplet(const QString& configFile, Type type, int actions,
		     QWidget *parent, const char *name)
     : KPanelApplet(configFile, type, actions, parent, name)
{
    uim_init();
    setBackgroundMode(QWidget::X11ParentRelative);
    toolbar = new UimToolbar(this);
    toolbar->show();
    QObject::connect( toolbar, SIGNAL( toolbarResized() ), this, SLOT( slotToolbarResized() ) );
}

UimApplet::~UimApplet()
{
    delete toolbar;
    // Don't call uim_quit() since kicker may have IM contexts of uim.
    // uim_quit();
}

int UimApplet::widthForHeight(int /* h */) const
{
    int width;

    width = toolbar->preferedWidthForHeight();
    return width;
}

int UimApplet::heightForWidth(int /* w */) const
{
    return height();
}

void UimApplet::preferences()
{
    toolbar->slotExecPref();
}

void UimApplet::slotToolbarResized()
{
    toolbar->resize(QSize(toolbar->preferedWidthForHeight(), size().height()));
    updateLayout();
}

UimToolbar::UimToolbar(QWidget *parent, const char *name, WFlags f)
    : QUimHelperToolbar(parent, name, f)
{
    setBackgroundMode(X11ParentRelative);
}

UimToolbar::~UimToolbar()
{
}

int UimToolbar::preferedWidthForHeight()
{
    return BUTTON_SIZE * getNumButtons();
}

#include "toolbar-applet-kde.moc"