#include "qmlclipboardadapter.h"

QmlClipboardAdapter::QmlClipboardAdapter(QObject *parent = 0):
    QObject(parent),
    m_text("")
{
    clipboard = QApplication::clipboard();
    m_text = clipboard->text(QClipboard::Clipboard);
    QObject::connect(clipboard, SIGNAL(dataChanged()),
                     this, SLOT(onDataChanged()));
}

