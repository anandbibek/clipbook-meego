#ifndef QMLCLIPBOARDADAPTER_H
#define QMLCLIPBOARDADAPTER_H

#include <QApplication>
#include <QClipboard>
#include <meventfeed.h>
#include <QObject>
#include <QtDeclarative>

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
    Q_INVOKABLE void suicide(){
        system("killall clipbookdaemon");
    }
    Q_INVOKABLE void publishFeed(void);


private:
    QClipboard *clipboard;
    QString m_text;

signals:
    void textChanged(void);

public slots:
    void onDataChanged(void);
};

#endif // QMLCLIPBOARDADAPTER_H
