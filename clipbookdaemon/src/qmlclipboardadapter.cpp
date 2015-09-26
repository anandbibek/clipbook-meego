#include "qmlclipboardadapter.h"

QmlClipboardAdapter :: QmlClipboardAdapter(QObject *parent):
    QObject(parent),
    m_text("")
{
    clipboard = QApplication::clipboard();
    m_text = clipboard->text(QClipboard::Clipboard);

    QObject::connect(clipboard, SIGNAL(dataChanged()),
                     this, SLOT(onDataChanged()));
}

void QmlClipboardAdapter :: publishFeed() {
    MEventFeed::instance()->addItem(QString("/opt/clipbookui/qml/clipbookui/feed.png"),
                                    QString("Clipboard Content"),
                                    QString(m_text),
                                    QStringList(""),
                                    QDateTime::currentDateTime(),
                                    QString("Tap to copy"),
                                    false,
                                    QUrl("clipbook:"+m_text),
                                    QString("clipbook"),
                                    QString("Clipbook"));
}

void QmlClipboardAdapter :: onDataChanged(){
    m_text = clipboard->text(QClipboard::Clipboard);
    //qDebug() << "Clipboard changed (daemon) :: " << m_text;
    emit textChanged();
}

