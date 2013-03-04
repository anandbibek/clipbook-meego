# Add more folders to ship with the application, here
folder_01.source = qml/clipbookui
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

#symbian:TARGET.UID3 = 0xE356129B

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
#symbian:TARGET.CAPABILITY += NetworkServices

QT += sql

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=
CONFIG += link_pkgconfig
PKGCONFIG += gq-gconf

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

splash.files = clipbookui-splash.png
splash.path = /usr/share/themes/blanco/meegotouch/images/splash
INSTALLS += splash

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += src/main.cpp \
    src/gconfitemqmlproxy.cpp \
    src/qmlclipboardadapter.cpp

HEADERS += \
    src/qmlclipboardadapter.h \
    src/gconfitemqmlproxy.h

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
