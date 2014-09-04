/*
Copyright (c) 2014 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "letohclass.h"
#include <QSettings>
#include <QCoreApplication>
#include <QTime>
#include <QDebug>
#include <QVariantMap>
#include <QColor>
#include <QThread>
#include "pca9685.h"

#define SHUTUP

LetohClass::LetohClass(QObject *parent) :
    QObject(parent)
{

    // Create seed for the random
    // That is needed only once on application startup
    QTime time = QTime::currentTime();
    qsrand((uint)time.msec());

    emit versionChanged();

    ledDrivers["topright"] = QVariant(QVariantMap());
    ledDrivers["upperright"] = QVariant(QVariantMap());
    ledDrivers["middleright"] = QVariant(QVariantMap());
    ledDrivers["lowerright"] = QVariant(QVariantMap());
    ledDrivers["bottomright"] = QVariant(QVariantMap());
    ledDrivers["bottomleft"] = QVariant(QVariantMap());
    ledDrivers["lowerleft"] = QVariant(QVariantMap());
    ledDrivers["middleleft"] = QVariant(QVariantMap());
    ledDrivers["upperleft"] = QVariant(QVariantMap());
    ledDrivers["topleft"] = QVariant(QVariantMap());

    QVariantMap driver;

    /* Assign I2C address, PCA9685 ports and default colors */

    driver["address"] = 0x40; driver["red"] = 1; driver["green"] = 0; driver["blue"] = 2; driver["color"] = QColor("#ff0000");
    ledDrivers["topright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 4; driver["green"] = 3; driver["blue"] = 5; driver["color"] = QColor("#000000");
    ledDrivers["upperright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 7; driver["green"] = 6; driver["blue"] = 8; driver["color"] = QColor("#000000");
    ledDrivers["middleright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 10; driver["green"] = 9; driver["blue"] = 11; driver["color"] = QColor("#000000");
    ledDrivers["lowerright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 13; driver["green"] = 12; driver["blue"] = 14; driver["color"] = QColor("#000000");
    ledDrivers["bottomright"] = QVariant(driver);

    driver["address"] = 0x41; driver["red"] = 1; driver["green"] = 0; driver["blue"] = 2; driver["color"] = QColor("#000000");
    ledDrivers["bottomleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 4; driver["green"] = 3; driver["blue"] = 5; driver["color"] = QColor("#000000");
    ledDrivers["lowerleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 7; driver["green"] = 6; driver["blue"] = 8; driver["color"] = QColor("#000000");
    ledDrivers["middleleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 10; driver["green"] = 9; driver["blue"] = 11; driver["color"] = QColor("#000000");
    ledDrivers["upperleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 13; driver["green"] = 12; driver["blue"] = 14; driver["color"] = QColor("#00ff00");
    ledDrivers["topleft"] = QVariant(driver);

    for(QVariantMap::const_iterator iter = ledDrivers.begin(); iter != ledDrivers.end(); ++iter)
    {
        qDebug() << iter.key() << " = " << qvariant_cast<QVariantMap>(iter.value())["color"].toString();
    }

    controlVdd(true);

    QThread::msleep(100);

    ledDriver1 = new PCA9685(0x41);
    ledDriver0 = new PCA9685(0x40); /* Init driver with stepup converter control last */
}

LetohClass::~LetohClass()
{
    controlVdd(false);
}

/* Return git describe as string (see .pro file) */
QString LetohClass::readVersion()
{
    return APPVERSION;
}

/* Function to set led colors from QML side
*/

void LetohClass::setLedColors(QVariantMap colorMap)
{
    /* Update changed led values in main table */
    for(QVariantMap::const_iterator iter = colorMap.begin(); iter != colorMap.end(); ++iter)
    {
        QVariantMap t = qvariant_cast<QVariantMap>(ledDrivers[iter.key()]);
        t["color"] = QColor(iter.value().toString());
        ledDrivers[iter.key()] = QVariant(t);
    }

    char data[120] = { 0 };

    for(QVariantMap::const_iterator iter = ledDrivers.begin(); iter != ledDrivers.end(); ++iter)
    {
        int offset = 0;

        QVariantMap t = qvariant_cast<QVariantMap>(ledDrivers[iter.key()]);

        if (t["address"].toInt() == 0x41)
            offset = 60;

        int red = QColor(t["color"].toString()).red();
        int green = QColor(t["color"].toString()).green();
        int blue = QColor(t["color"].toString()).blue();

        /* Setting maximun dutycycle to 50% for safety during testing */
        int ledOnRed = 2047;
        int ledOnGreen = 1023;
        int ledOnBlue = 0;

        int ledOffRed = ledOnRed + 8*red;
        int ledOffGreen = ledOnGreen + 12*green;
        int ledOffBlue = ledOnBlue + 8*blue;

        data[offset + 4*t["red"].toInt()+0] = ledOnRed & 0xff;
        data[offset + 4*t["red"].toInt()+1] = (ledOnRed >> 8) & 0xff;
        data[offset + 4*t["red"].toInt()+2] = ledOffRed & 0xff;
        data[offset + 4*t["red"].toInt()+3] = (ledOffRed >> 8) & 0xff;
        data[offset + 4*t["green"].toInt()+0] = ledOnGreen & 0xff;
        data[offset + 4*t["green"].toInt()+1] = (ledOnGreen >> 8) & 0xff;
        data[offset + 4*t["green"].toInt()+2] = ledOffGreen & 0xff;
        data[offset + 4*t["green"].toInt()+3] = (ledOffGreen >> 8) & 0xff;
        data[offset + 4*t["blue"].toInt()+0] = ledOnBlue & 0xff;
        data[offset + 4*t["blue"].toInt()+1] = (ledOnBlue >> 8) & 0xff;
        data[offset + 4*t["blue"].toInt()+2] = ledOffBlue & 0xff;
        data[offset + 4*t["blue"].toInt()+3] = (ledOffBlue >> 8) & 0xff;

        //qDebug() << iter.key() << " = " << qvariant_cast<QVariantMap>(iter.value())["color"].toString();
    }

    ledDriver0->updateLeds(data,0,60);
    ledDriver1->updateLeds(data,60,60);
}



int LetohClass::randInt(int low, int high)
{
    // Random number between low and high
    return qrand() % ((high + 1) - low) + low;
}

QString LetohClass::randomColor()
{
    return QString("#%1%2%3").arg(randInt(0, 255), 2, 16, QChar('0')).arg(randInt(0, 255), 2, 16, QChar('0')).arg(randInt(0, 255), 2, 16, QChar('0')).toUpper();
}

/************************************************************************/

void LetohClass::controlVdd(bool state)
{
    int fd = open("/sys/devices/platform/reg-userspace-consumer.0/state", O_WRONLY);

    if (!(fd < 0))
    {
        if (write (fd, state ? "1" : "0", 1) != 1)
            qDebug() << "Failed to control VDD.";

        close(fd);
    }

    return;
}
