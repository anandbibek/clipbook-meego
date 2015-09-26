#-------------------------------------------------
#
# Project created by QtCreator 2013-03-01T23:12:40
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = clipbookdm
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

mydaemon.path = /etc/init/apps
mydaemon.files = clipbookdm.conf
INSTALLS += mydaemon

SOURCES += main.cpp

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/clipbookdaemon/bin
    INSTALLS += target
}
