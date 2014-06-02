# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = LeTOH

CONFIG += sailfishapp

QT += multimedia

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

SOURCES += src/LeTOH.cpp \
	src/letohclass.cpp \
    src/qmultimediavumeterbackend.cpp \
    src/qmultimediaaudiorecorder.cpp \
    src/driverBase.cpp \
    src/pca9685.cpp
	
HEADERS += src/letohclass.h \
    src/qmultimediavumeterbackend.h \
    src/qmultimediaaudiorecorder.h \
    src/driverBase.h \
    src/pca9685.h

OTHER_FILES += qml/LeTOH.qml \
    qml/cover/CoverPage.qml \
    qml/pages/LeTOH.qml \
    rpm/LeTOH.spec \
	LeTOH.png \
    LeTOH.desktop \
    qml/pages/aboutPage.qml

