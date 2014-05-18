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

#include "qmultimediaaudiorecorder.h"

#include <QDebug>
#include <QUrl>

QMultimediaAudioRecorder::QMultimediaAudioRecorder(QObject *parent) :
    QObject(parent)
{
    m_audioRecorder = new QAudioRecorder();
    m_audioInputs = m_audioRecorder->audioInputs();

    qDebug() << "Available audio inputs: " << m_audioInputs;

    foreach (QString input, m_audioInputs)
    {
        qDebug() << input << ": " << m_audioRecorder->audioInputDescription(input);
    }

    qDebug() << "Supported audio codecs: " << m_audioRecorder->supportedAudioCodecs();
    qDebug() << "Supported containers: " << m_audioRecorder->supportedContainers();



    QAudioEncoderSettings audioSettings;
    audioSettings.setCodec("audio/vorbis");
    audioSettings.setQuality(QMultimedia::NormalQuality);

    m_audioRecorder->setEncodingSettings(audioSettings);
    m_audioRecorder->setContainerFormat("ogg");
    m_audioRecorder->setAudioInput(m_audioRecorder->defaultAudioInput());

    m_audioProbe = new QAudioProbe();
    if (m_audioProbe->setSource(m_audioRecorder))
    {
        if (m_audioProbe->isActive())
        {
            qDebug("Connecting probe.");
            connect(m_audioProbe, SIGNAL(audioBufferProbed(QAudioBuffer)), this, SLOT(updateVuMeter(QAudioBuffer)));
        } else
        {
            qDebug("Probe is inactive.");
        }
    }
    else
    {
        qDebug("Failed to setSource for probe.");
    }
}

QMultimediaAudioRecorder::~QMultimediaAudioRecorder()
{
    qDebug("QMultimediaAudioRecorder::~QMultimediaAudioRecorder()");
    disconnect(m_audioProbe, SIGNAL(audioBufferProbed(QAudioBuffer)), this, SLOT(updateVuMeter(QAudioBuffer)));
    delete m_audioProbe;
    delete m_audioRecorder;
}

void QMultimediaAudioRecorder::connectAudio(int index)
{
}

void QMultimediaAudioRecorder::disconnectAudio()
{
}

void QMultimediaAudioRecorder::startRecord(QString fileName)
{
    qDebug() << "Recording, fileName: " << fileName;
    m_audioRecorder->setOutputLocation(QUrl(fileName));
    qDebug() << "Recording to: " << m_audioRecorder->outputLocation();
    m_audioRecorder->record();
    qDebug() << "Recorder mute state: " << m_audioRecorder->isMuted();
    qDebug() << "Recorder volume: " << m_audioRecorder->volume();
}

void QMultimediaAudioRecorder::stopRecord()
{
    m_audioRecorder->stop();
}

void QMultimediaAudioRecorder::updateVuMeter(QAudioBuffer aBuf)
{
//    qDebug() << "Got audio buffer."
//             << "Format: " << aBuf.format();
    const float sample = qAbs(*reinterpret_cast<const float*>(aBuf.constData()));

    /* Clip output to 0.5 */
    emit vuMeterValueUpdate((sample>0.5) ? 0.5 : sample);
}
