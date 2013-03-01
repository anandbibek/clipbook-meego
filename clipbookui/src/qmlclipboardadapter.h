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
    }

    Q_INVOKABLE void setText(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
    }

    Q_INVOKABLE QString text(){
        return m_text;
    }

    Q_INVOKABLE void startDaemon(){
        qDebug() << "starting daemon";
        system("xdg-open /opt/clipbookdaemon/bin/clipbookdaemon_harmattan.desktop");
    }
    Q_INVOKABLE void killDaemon(){
        system("killall clipbookdaemon");
    }
    Q_INVOKABLE void writeToFile(QString data, QString file){
        QString command = "echo \"" + data + "\" >> " + file ;
        QByteArray byte = command.toLocal8Bit();
        const char *c = byte.data() ;
        system(c);

    }

private:
    QClipboard *clipboard;
    QString m_text;

signals:
    void textChanged(void);

public slots:
    void onDataChanged(){
        QString temp = clipboard->text(QClipboard::Clipboard);
        if(temp != m_text)
        {
            m_text = clipboard->text(QClipboard::Clipboard);
            qDebug() << "Clipboard changed :: " << m_text;
            emit textChanged();
        }
    }
};

#endif // QMLCLIPBOARDADAPTER_H
