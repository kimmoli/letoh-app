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

#ifndef QMULTIMEDIAAUDIORECORDER_H
#define QMULTIMEDIAAUDIORECORDER_H

#include <QObject>
#include <QStringList>
#include <QtMultimedia/QAudioBuffer>
#include <QtMultimedia/QAudioProbe>
#include <QtMultimedia/QAudioRecorder>

class QMultimediaAudioRecorder : public QObject
{
    Q_OBJECT
public:
    explicit QMultimediaAudioRecorder(QObject *parent = 0);
    ~QMultimediaAudioRecorder();

signals:
    void vuMeterValueUpdate(float value);

public slots:
    void connectAudio(int index);
    void disconnectAudio();

    void startRecord(QString fileName);
    void stopRecord();

private slots:
    void updateVuMeter(QAudioBuffer aBuf);

private:
    QAudioProbe *m_audioProbe;
    QAudioRecorder *m_audioRecorder;
    QStringList m_audioInputs;

};

#endif // QMULTIMEDIAAUDIORECORDER_H
