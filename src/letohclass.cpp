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

    driver["address"] = 0x40; driver["red"] = 1; driver["green"] = 2; driver["blue"] = 0; driver["color"] = QColor("#ff0000");
    ledDrivers["topright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 4; driver["green"] = 5; driver["blue"] = 3; driver["color"] = QColor("#ff0000");
    ledDrivers["upperright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 7; driver["green"] = 8; driver["blue"] = 6; driver["color"] = QColor("#ff0000");
    ledDrivers["middleright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 10; driver["green"] = 11; driver["blue"] = 9; driver["color"] = QColor("#ff0000");
    ledDrivers["lowerright"] = QVariant(driver);
    driver["address"] = 0x40; driver["red"] = 13; driver["green"] = 14; driver["blue"] = 12; driver["color"] = QColor("#ff0000");
    ledDrivers["bottomright"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 1; driver["green"] = 2; driver["blue"] = 0; driver["color"] = QColor("#ff0000");
    ledDrivers["bottomleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 4; driver["green"] = 5; driver["blue"] = 3; driver["color"] = QColor("#ff0000");
    ledDrivers["lowerleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 7; driver["green"] = 8; driver["blue"] = 6; driver["color"] = QColor("#ff0000");
    ledDrivers["middleleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 10; driver["green"] = 11; driver["blue"] = 9; driver["color"] = QColor("#ff0000");
    ledDrivers["upperleft"] = QVariant(driver);
    driver["address"] = 0x41; driver["red"] = 13; driver["green"] = 14; driver["blue"] = 12; driver["color"] = QColor("#ff0000");
    ledDrivers["topleft"] = QVariant(driver);

    for(QVariantMap::const_iterator iter = ledDrivers.begin(); iter != ledDrivers.end(); ++iter)
    {
        qDebug() << iter.key() << " = " << qvariant_cast<QVariantMap>(iter.value())["color"].toString();
    }


}

LetohClass::~LetohClass()
{
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

#ifndef SHUTUP
    qDebug() << "Led values changed:";

    for(QVariantMap::const_iterator iter = ledDrivers.begin(); iter != ledDrivers.end(); ++iter)
        qDebug() << iter.key() << " = " << qvariant_cast<QVariantMap>(iter.value())["color"].toString();
#endif
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
