#ifndef QMLCLIPBOARDADAPTER_H
#define QMLCLIPBOARDADAPTER_H

#include <QApplication>
#include <QClipboard>
#include <QtSql/QtSql>
#include <QDateTime>
#include <QObject>
#include <QtDeclarative>
#include <QDebug>

class QmlClipboardAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString entry READ entry)
    Q_PROPERTY(QString date READ date)

public:
    explicit QmlClipboardAdapter(QObject *parent = 0);

    Q_INVOKABLE void setText(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
    }

    Q_INVOKABLE QString text(){
        return m_text;
    }

    Q_INVOKABLE QString entry(){
        return m_entry;
    }

    Q_INVOKABLE QString date(){
        return m_date;
    }

    Q_INVOKABLE void startDaemon(){
        qDebug() << "starting daemon";        
        QProcess proc;
        proc.startDetached("/usr/bin/single-instance /opt/clipbookdaemon/bin/clipbookdaemon");
        //system("xdg-open /opt/clipbookdaemon/bin/clipbookdaemon_harmattan.desktop");
    }
    Q_INVOKABLE void killDaemon(){
        system("killall clipbookdaemon");
    }
    Q_INVOKABLE void writeToFile(QString data, QString file);
    Q_INVOKABLE void writeToDatabase(QString data);
    Q_INVOKABLE void readDatabase(void);
    Q_INVOKABLE void deleteDB(QString title);
    Q_INVOKABLE void dropDB(void);


private:
    QClipboard *clipboard;
    QString m_text;
    QString m_entry;
    QString m_date;
    QSqlDatabase db;

signals:
    void textChanged(void);
    void entryChanged(void);
    void readFinished(void);

public slots:
    void onDataChanged(void);
};

#endif // QMLCLIPBOARDADAPTER_H
