#ifndef QMLCLIPBOARDADAPTER_H
#define QMLCLIPBOARDADAPTER_H

#include <QApplication>
#include <QClipboard>
#include <QObject>
#include <QtDeclarative>
#include <QDebug>

class QmlClipboardAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit QmlClipboardAdapter(QObject *parent = 0):
        QObject(parent),
        m_text("")
    {
        clipboard = QApplication::clipboard();
        m_text = clipboard->text(QClipboard::Clipboard);
        QObject::connect(clipboard, SIGNAL(dataChanged()),
                         this, SLOT(onDataChanged()));
        qDebug() << "Clipbook Daemon started";
    }

    Q_INVOKABLE void setText(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
        //clipboard->setText(text, QClipboard::Selection);
    }

    Q_INVOKABLE QString text(){
        return m_text;
    }

    Q_INVOKABLE void killDaemon(){
        system("killall clipbookdaemon");
    }

private:
    QClipboard *clipboard;
    QString m_text;

signals:
    void textChanged();

public slots:
    void onDataChanged(){
        QString temp = clipboard->text(QClipboard::Clipboard);
        if(temp != m_text)
        {
            m_text = clipboard->text(QClipboard::Clipboard);
            qDebug() << "Clipboard changed (via daemon) :: " << m_text;
            emit textChanged();
        }
    }
};

#endif // QMLCLIPBOARDADAPTER_H
