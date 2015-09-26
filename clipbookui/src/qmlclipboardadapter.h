#ifndef QMLCLIPBOARDADAPTER_H
#define QMLCLIPBOARDADAPTER_H

#include <QApplication>
#include <QClipboard>
#include <QObject>
#include <QtDeclarative>
#include <meventfeed.h>

class QmlClipboardAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit QmlClipboardAdapter(QObject *parent = 0);

    Q_INVOKABLE void setText(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
    }

    Q_INVOKABLE QString text(){
        return m_text;
    }

    Q_INVOKABLE void startDaemon(){
        qDebug() << "starting daemon";
        QProcess proc;
        proc.startDetached("/usr/bin/single-instance /opt/clipbookdaemon/bin/clipbookdaemon");
    }
    Q_INVOKABLE void killDaemon(){
        system("killall clipbookdaemon");
    }
    Q_INVOKABLE void publishFeed(void);
    Q_INVOKABLE void writeToFile(QString data, QString file);


private:
    QClipboard *clipboard;
    QString m_text;

signals:
    void textChanged(void);

public slots:
    void onDataChanged(void);
    void kill(){
            system("killall clipbookui");
        }
};

#endif // QMLCLIPBOARDADAPTER_H
