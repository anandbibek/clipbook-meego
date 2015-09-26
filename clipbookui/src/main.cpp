#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QObject>
#include "qmlapplicationviewer.h"
#include "qmlclipboardadapter.h"
#include "gconfitemqmlproxy.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QmlClipboardAdapter myAdapter;

    if (argc>1) {
        QString data = QCoreApplication::arguments().at(1);
        data.remove(0,9);
        myAdapter.setText(data);
        QTimer :: singleShot(300,&myAdapter,SLOT(kill()));
        return app->exec();
    }
    else {

        QCoreApplication::setApplicationName("clipbook");
        QmlApplicationViewer viewer;
        viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
        viewer.setAttribute(Qt::WA_NoSystemBackground);
        viewer.setAutoFillBackground(false);

        //gconf and adapter passing to qml
        qmlRegisterType<GConfItemQmlProxy>("GConf", 1, 0, "GConfItem");
        viewer.rootContext()->setContextProperty("clippie", &myAdapter);
        viewer.setMainQmlFile(QLatin1String("qml/clipbookui/main.qml"));
        viewer.showExpanded();
        return app->exec();
    }
}
