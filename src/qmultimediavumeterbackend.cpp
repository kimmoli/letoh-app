/*
 *  Copyright 2013 Ruediger Gad
 *
 *  This file is part of StultitiaSimplex.
 *
 *  StultitiaSimplex is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  StultitiaSimplex is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with StultitiaSimplex.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "qmultimediavumeterbackend.h"
#include <QAudioDeviceInfo>
#include <QDebug>

QMultimediaVuMeterBackend::QMultimediaVuMeterBackend(QObject *parent) :
    QObject(parent)
{
    QList<QAudioDeviceInfo> inputDevices = QAudioDeviceInfo::availableDevices(QAudio::AudioInput);
    qDebug() << "Got available input devices: " << inputDevices.size();

    foreach (QAudioDeviceInfo inputDev, inputDevices) {
        qDebug() << inputDev.deviceName()
                 << "\nCodecs: " << inputDev.supportedCodecs()
                 << "\nSample Rates: " << inputDev.supportedSampleRates()
                 << "\nSample Sizes: " << inputDev.supportedSampleSizes()
                 << "\nByte Orders: " << inputDev.supportedByteOrders()
                 << "\nChannel Counts: " << inputDev.supportedChannelCounts();
    }

    QAudioDeviceInfo defaultInput = QAudioDeviceInfo::defaultInputDevice();
    if (! defaultInput.isNull()) {
        qDebug() << "Default Input Device: " << defaultInput.deviceName()
                 << "\nCodecs: " << defaultInput.supportedCodecs()
                 << "\nSample Rates: " << defaultInput.supportedSampleRates()
                 << "\nSample Sizes: " << defaultInput.supportedSampleSizes()
                 << "\nByte Orders: " << defaultInput.supportedByteOrders()
                 << "\nChannel Counts: " << defaultInput.supportedChannelCounts();
    } else {
        qDebug("Default audio input device is null.");
    }
}

QMultimediaVuMeterBackend::~QMultimediaVuMeterBackend() {

}
