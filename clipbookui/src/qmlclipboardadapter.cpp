#include "qmlclipboardadapter.h"

QmlClipboardAdapter :: QmlClipboardAdapter(QObject *parent):
    QObject(parent),
    m_text(""),
    m_entry(""),
    m_date("")
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

void QmlClipboardAdapter :: readDatabase(){
    QSqlQuery query;
    query.exec("SELECT * FROM clip ORDER BY id DESC");
    while(query.next()) {
        m_entry = query.value(0).toString();
        m_date = query.value(1).toString();
        emit entryChanged();
    }
    emit readFinished();
}

void QmlClipboardAdapter :: writeToFile(QString data, QString file)
{
    QString command = "echo \"" + data + "\" >> " + file ;
    QByteArray byte = command.toLocal8Bit();
    const char *c = byte.data() ;
    system(c);
}

void QmlClipboardAdapter :: onDataChanged(void){
    QString temp = clipboard->text(QClipboard::Clipboard);
    if(temp != m_text)
    {
        m_text = clipboard->text(QClipboard::Clipboard);
        qDebug() << "Clipboard changed :: " << m_text;
        emit textChanged();
        //Add auto call to DB write if daemon
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

void QmlClipboardAdapter :: deleteDB(QString title){
    QSqlQuery query;
    query.prepare("DELETE FROM clip WHERE title = ?");
    query.bindValue(0, title);
    query.exec();
}

void QmlClipboardAdapter :: dropDB(){
    QSqlQuery query;
    query.prepare("DROP TABLE IF EXISTS clip");
    query.exec();
}

