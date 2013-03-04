#include <QtCore/QCoreApplication>
#include <QProcess>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QProcess proc;
    proc.startDetached("/usr/bin/single-instance /opt/clipbookdaemon/bin/clipbookdaemon");
    //proc.startDetached("/opt/clipbookdaemon/bin/clipbookdaemon");
    //proc.startDetached("xdg-open /opt/clipbookdaemon/bin/clipbookdaemon_harmattan.desktop");
    return a.exec();
}
