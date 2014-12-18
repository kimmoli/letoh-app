TARGET = harbour-letoh

CONFIG += sailfishapp

QT += multimedia

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

SOURCES += src/letoh.cpp \
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
    rpm/harbour-letoh.spec \
	harbour-letoh.png \
    harbour-letoh.desktop \
    qml/pages/aboutPage.qml

