#include "qmlclipboardadapter.h"

QmlClipboardAdapter :: QmlClipboardAdapter(QObject *parent):
    QObject(parent),
    m_text("")
{
    clipboard = QApplication::clipboard();
    m_text = clipboard->text(QClipboard::Clipboard);

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("clipbook.sqlite");

    if (!db.open()) {
        qDebug()<<tr("Unable to establish a database connection.");
    }
    else{
        if(!db.tables(QSql::AllTables).contains("clip")) {
            QSqlQuery query;
            query.exec("CREATE TABLE IF NOT EXISTS clip (title MEMO UNIQUE, modified TEXT, id LONG)");
        }
    }

    QObject::connect(clipboard, SIGNAL(dataChanged()),
                     this, SLOT(onDataChanged()));
}

void QmlClipboardAdapter :: onDataChanged(){
    QString temp = clipboard->text(QClipboard::Clipboard);
    if(temp != m_text)
    {
        m_text = clipboard->text(QClipboard::Clipboard);
        qDebug() << "Clipboard changed (daemon) :: " << m_text;
        emit textChanged();
    }
}

void QmlClipboardAdapter :: writeToDatabase(QString data){
    QDateTime epoch = QDateTime :: currentDateTime();
    QSqlQuery query;
    query.prepare("INSERT OR REPLACE INTO clip (title, modified, id) VALUES(?, ?, ?)");
    query.bindValue(0, data);
    query.bindValue(1, epoch.toString("d MMM yyyy h:mm AP"));
    query.bindValue(2, epoch.toString("yyyyMMddhhmmss"));
    query.exec();
}

