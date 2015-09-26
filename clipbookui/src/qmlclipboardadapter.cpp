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

void QmlClipboardAdapter :: writeToFile(QString data, QString file)
{
    QString command = "echo \"" + data + "\" >> " + file ;
    QByteArray byte = command.toLocal8Bit();
    const char *c = byte.data() ;
    system(c);
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

void QmlClipboardAdapter :: onDataChanged(void){
    QString temp = clipboard->text(QClipboard::Clipboard);
    if(temp != m_text)
    {
        m_text = clipboard->text(QClipboard::Clipboard);
        emit textChanged();
    }
}

