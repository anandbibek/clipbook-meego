#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "qmlclipboardadapter.h"
#include "gconfitemqmlproxy.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QCoreApplication::setApplicationName("clipbook");

    QmlClipboardAdapter myAdapter;
    QmlApplicationViewer viewer;
    system("killall clipbookdm");
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.setAutoFillBackground(false);

    //gconf and adapter passing to qml
    viewer.rootContext()->setContextProperty("clippie", &myAdapter);
    qmlRegisterType<GConfItemQmlProxy>("GConf", 1, 0, "GConfItem");
    viewer.setMainQmlFile(QLatin1String("qml/clipbookdaemon/mainD.qml"));

    return app->exec();
}
