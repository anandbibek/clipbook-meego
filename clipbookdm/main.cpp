#include <QtCore/QCoreApplication>
#include <QProcess>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QProcess proc;
    proc.startDetached("/usr/bin/single-instance /opt/clipbookdaemon/bin/clipbookdaemon");
    return a.exec();
}
