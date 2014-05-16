/*
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{

    property int ledSize: 20

    Label
    {
        id: label
        anchors.centerIn: parent
        text: "LeTOH"
    }

    Component.onCompleted: {
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
    }

}


