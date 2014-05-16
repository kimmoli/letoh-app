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

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

SOURCES += src/LeTOH.cpp \
	src/letohclass.cpp
	
HEADERS += src/letohclass.h

OTHER_FILES += qml/LeTOH.qml \
    qml/cover/CoverPage.qml \
    qml/pages/LeTOH.qml \
    rpm/LeTOH.spec \
	LeTOH.png \
    LeTOH.desktop \
    qml/pages/aboutPage.qml

