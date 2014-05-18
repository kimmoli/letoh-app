/*
  Copyright (C) 2014 Kimmo Lindholm

*/

import QtMultimedia 5.0
import QtQuick 2.0
import Sailfish.Silica 1.0
import LeTOH.LetohClass 1.0


Page
{
    id: page

    property bool appActive : false

    property int ledSize: 40
    property color tmp : "black"

    property var rainbow : [ "#ff0080", "#ff0000", "#ff8000", "#ffff00", "#00ff00",
                             "#00ff80", "#00ffff", "#0000ff", "#8000ff", "#ff00ff",
                             "#000000", "#ffffff" ] // also black and white

    function updateAllColors()
    {
        // Updates all colors at once to C++ side
        letohclass.setLedColors( {
            "topleft" : topleft.ledColor,
            "upperleft" : upperleft.ledColor,
            "middleleft" : middleleft.ledColor,
            "lowerleft" : lowerleft.ledColor,
            "bottomleft" : bottomleft.ledColor,
            "bottomright" : bottomright.ledColor,
            "lowerright" : lowerright.ledColor,
            "middleright" : middleright.ledColor,
            "upperright" : upperright.ledColor,
            "topright" : topright.ledColor } )
    }

    onAppActiveChanged:
    {
        /* Seems that there is applicationActive, but no onApplicationActive -signal
            So i had to do this with secondary signal appActive which is connected
            on ApplicationWindow to applicationActive */

        console.log("Application Active: " + appActive)
        if (appActive == false)
        {
            recorder.stopRecord()
            audioMode.checked = false
            animateMode.checked = false
        }
    }

    QMultimediaAudioRecorder
    {
        id: recorder
        onVuMeterValueUpdate:
        {
            if (value > vuValue.vuPeak)
            {
                vuPeakHold.restart()
                vuValue.vuPeak = value
            }
            vuValue.value = value

            var vuStep = vuValue.vuPeak/6

            topleft.ledColor = value > (5*vuStep) ? rainbow[1] : "black"
            topright.ledColor = topleft.ledColor
            upperleft.ledColor = value > (4*vuStep) ? rainbow[2] : "black"
            upperright.ledColor = upperleft.ledColor
            middleleft.ledColor = value > (3*vuStep) ? rainbow[3] : "black"
            middleright.ledColor = middleleft.ledColor
            lowerleft.ledColor = value > (2*vuStep) ? rainbow[4] : "black"
            lowerright.ledColor = lowerleft.ledColor
            bottomleft.ledColor = value > (1*vuStep) ? rainbow[5] : "black"
            bottomright.ledColor = bottomleft.ledColor

            updateAllColors()
        }
    }

    Timer
    {
        id: vuPeakHold
        interval: 750
        repeat: true
        running: audioMode.checked && applicationActive  && page.status === PageStatus.Active
        onTriggered:
        {
            vuValue.vuPeak = 0.1
        }
    }

    QMultimediaVuMeterBackend
    {
        id: vuMeterBackend
    }


    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("aboutPage.qml"),
                                          { "version": letohclass.version, "year": "2014", "name": "LeTOH" } )
            }
        }

        contentHeight: page.height

        Column
        {
            anchors.centerIn: parent
            height: parent.height-(6*ledSize)
            width: parent.width-(2*ledSize)
            spacing: Theme.paddingSmall

            Button
            {
                text: "Randomize"
                enabled: audioMode.checked
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    topleft.ledColor =     letohclass.randomColor()
                    upperleft.ledColor =   letohclass.randomColor()
                    middleleft.ledColor =  letohclass.randomColor()
                    lowerleft.ledColor =   letohclass.randomColor()
                    bottomleft.ledColor =  letohclass.randomColor()
                    bottomright.ledColor = letohclass.randomColor()
                    lowerright.ledColor =  letohclass.randomColor()
                    middleright.ledColor = letohclass.randomColor()
                    upperright.ledColor =  letohclass.randomColor()
                    topright.ledColor =    letohclass.randomColor()

                    updateAllColors()
                }
            }

            Button
            {
                text: "Rainbow'ze"
                enabled: audioMode.checked
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    topleft.ledColor = rainbow[0]
                    upperleft.ledColor = rainbow[1]
                    middleleft.ledColor = rainbow[2]
                    lowerleft.ledColor = rainbow[3]
                    bottomleft.ledColor = rainbow[4]
                    bottomright.ledColor = rainbow[5]
                    lowerright.ledColor = rainbow[6]
                    middleright.ledColor = rainbow[7]
                    upperright.ledColor = rainbow[8]
                    topright.ledColor = rainbow[9]

                    updateAllColors()
                }
            }

            Button
            {
                text: "Select color"
                enabled: audioMode.checked
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change all leds to " + dialog.color)

                               topleft.ledColor = dialog.color
                               upperleft.ledColor = dialog.color
                               middleleft.ledColor = dialog.color
                               lowerleft.ledColor = dialog.color
                               bottomleft.ledColor = dialog.color
                               bottomright.ledColor = dialog.color
                               lowerright.ledColor = dialog.color
                               middleright.ledColor = dialog.color
                               upperright.ledColor = dialog.color
                               topright.ledColor = dialog.color

                               updateAllColors()
                           })
                }

            }

            TextSwitch
            {
                id: audioMode
                text: "Disco Stu"
                anchors.horizontalCenter: parent.horizontalCenter
                description: "Mic level VU meter"
                onCheckedChanged:
                {
                    animateMode.checked = false

                    if (checked)
                    {
                        animateMode.checked = false
                        topleft.ledColor = "black"
                        upperleft.ledColor = "black"
                        middleleft.ledColor = "black"
                        lowerleft.ledColor = "black"
                        bottomleft.ledColor = "black"
                        bottomright.ledColor = "black"
                        lowerright.ledColor = "black"
                        middleright.ledColor = "black"
                        upperright.ledColor = "black"
                        topright.ledColor = "black"

                        recorder.startRecord("/dev/null")
                    }
                    else
                    {
                        recorder.stopRecord()
                    }
                }
            }

            Slider
            {
                id: vuValue

                property real vuPeak: 0.1

                minimumValue: 0
                maximumValue: 0.5
                value: 0
                width: parent.width
                visible: audioMode.checked
                anchors.horizontalCenter: parent.horizontalCenter

                GlassItem
                {
                    color: "red"
                    falloffRadius: 0.15
                    radius: 0.15
                    cache: false
                    anchors.verticalCenter: parent.verticalCenter
                    x: (parent.width - (5*Theme.paddingLarge)) * (parent.vuPeak / parent.maximumValue)
                }
            }

            TextSwitch
            {
                id: animateMode
                text: "Animation"
                anchors.horizontalCenter: parent.horizontalCenter
                description: "Select from predefined movements"
                onCheckedChanged:
                {
                    if (audioMode.checked)
                    {
                        audioMode.checked = false
                        recorder.stopRecord()
                    }
                }
            }

            Slider
            {
                id: animateSpeed
                label: "Speed"
                visible: animateMode.checked
                width: parent.width - Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 100
                maximumValue: 700
                value: (maximumValue+minimumValue)/2
                stepSize: (maximumValue-minimumValue)/2
                valueText: (value == maximumValue) ? "Fast" : ((value == minimumValue) ? "Slow" : "Intermediate")
            }

        }

        Timer
        {
            interval: (animateSpeed.maximumValue+animateSpeed.minimumValue)-animateSpeed.value
            running: animateMode.checked && applicationActive  && page.status === PageStatus.Active
            repeat: true
            onTriggered:
            {
                tmp = topleft.ledColor

                topleft.ledColor =     upperleft.ledColor
                upperleft.ledColor =   middleleft.ledColor
                middleleft.ledColor =  lowerleft.ledColor
                lowerleft.ledColor =   bottomleft.ledColor
                bottomleft.ledColor =  bottomright.ledColor
                bottomright.ledColor = lowerright.ledColor
                lowerright.ledColor =  middleright.ledColor
                middleright.ledColor = upperright.ledColor
                upperright.ledColor =  topright.ledColor
                topright.ledColor =    tmp;

                updateAllColors()
            }

        }


        Rectangle
        {
            id: topleft
            rotation: 90
            width: ledSize
            height: parent.width/2
            x: parent.width/4
            y: (width/2)-(height/2)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: topleft.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"topleft" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: topright
            rotation: 90
            width: ledSize
            height: parent.width/2
            x: 3*(parent.width/4)
            y: (width/2)-(height/2)

            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: topright.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"topright" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: bottomleft
            rotation: 90
            width: ledSize
            height: parent.width/2
            x: parent.width/4
            y: parent.height-(width/2)-(height/2)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: bottomleft.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"bottomleft" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: bottomright
            rotation: 90
            width: ledSize
            height: parent.width/2
            x: 3*(parent.width/4)
            y: parent.height-(width/2)-(height/2)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: bottomright.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"bottomright" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: middleleft
            width: ledSize
            height: parent.height/3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: middleleft.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"middleleft" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: middleright
            width: ledSize
            height: parent.height/3
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: middleright.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"middleright" : dialog.color})
                           })
                }
            }

        }

        Rectangle
        {
            id: upperleft
            width: ledSize
            height: parent.height/3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -(parent.height/3)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: upperleft.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"upperleft" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: upperright
            width: ledSize
            height: parent.height/3
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -(parent.height/3)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: upperright.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"upperright" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: lowerleft
            width: ledSize
            height: parent.height/3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: (parent.height/3)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: lowerleft.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"lowerleft" : dialog.color})
                           })
                }
            }
        }

        Rectangle
        {
            id: lowerright
            width: ledSize
            height: parent.height/3
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: (parent.height/3)
            property color ledColor: "red"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: lowerright.ledColor }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog", { "colors": rainbow })
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
                               letohclass.setLedColors( {"lowerright" : dialog.color})
                           })
                }
            }
        }



    }

    LetohClass
    {
        id: letohclass
    }
}


