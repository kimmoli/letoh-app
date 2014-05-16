/*
  Copyright (C) 2014 Kimmo Lindholm

*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import LeTOH.LetohClass 1.0


Page
{
    id: page

    property int ledSize: 40
    property color tmp : "black"

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

        contentHeight: page.height //column.height

        Column
        {
            anchors.centerIn: parent
            height: parent.height-(6*ledSize)
            width: parent.width-(2*ledSize)
            spacing: Theme.paddingLarge

            Button
            {
                text: "Randomize"
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
                }
            }

            Button
            {
                text: "Rainbow'ze"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:
                {
                    topleft.ledColor =     "#ff0080"
                    upperleft.ledColor =   "#ff0000"
                    middleleft.ledColor =  "#ff8000"
                    lowerleft.ledColor =   "#ffff00"
                    bottomleft.ledColor =  "#00ff00"
                    bottomright.ledColor = "#00ff80"
                    lowerright.ledColor =  "#00ffff"
                    middleright.ledColor = "#0000ff"
                    upperright.ledColor =  "#8000ff"
                    topright.ledColor =    "#ff00ff"
                }
            }


            TextSwitch
            {
                id: rotateColors
                text: "Rotate"
                anchors.horizontalCenter: parent.horizontalCenter
                description: "Rotate colors clockvise"
            }

            Slider
            {
                id: rotateSpeed
                label: "Speed"
                visible: rotateColors.checked
                width: parent.width - Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 100
                maximumValue: 700
                value: (rotateSpeed.maximumValue+rotateSpeed.minimumValue)/2
                stepSize: (rotateSpeed.maximumValue-rotateSpeed.minimumValue)/2
                valueText: (value == maximumValue) ? "Fast" : ((value == minimumValue) ? "Slow" : "Intermediate")
            }
        }

        Timer
        {
            interval: (rotateSpeed.maximumValue+rotateSpeed.minimumValue)-rotateSpeed.value
            running: rotateColors.checked
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                           dialog.accepted.connect(function() {
                               console.log("change color to " + dialog.color)
                               parent.ledColor = dialog.color
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


