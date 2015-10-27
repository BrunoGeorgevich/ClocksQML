import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

Tab {
    property string strokeColor : "Black"
    property double endPoint : Math.PI*2
    property double initialEndPoint
    property int initialMaxTime
    property int maxTime : 1
    property bool restartSwitch : false

    Component.onCompleted: {
        initialEndPoint = endPoint
    }

    Rectangle {
        anchors.fill: parent

        Timer {
            id:digitalClockTimer
            interval: 1000
            repeat: true
            onTriggered: {
                endPoint -= initialEndPoint/initialMaxTime
                maxTime -= 1
                timerLabel.text = maxTime
                canvas.requestPaint()

                if(endPoint == 0) {
                    stop()
                    endPoint = initialEndPoint
                    maxTime = initialMaxTime
                    timerLabel.text = "Start"
                }
            }
        }

        Canvas {
            id:canvas
            anchors {
                fill: parent
            }

            onPaint: {
                var ctx = canvas.getContext("2d")
                ctx.reset()

                var centerX = parent.width  / 3
                var centerY = parent.height / 2

                ctx.beginPath()
                ctx.strokeStyle = strokeColor
                ctx.lineWidth = 4
                ctx.arc(centerX, centerY, canvas.width/4, 0, endPoint, false);
                ctx.stroke()
            }
        }

        Rectangle {

            anchors {
                left:parent.left
                leftMargin: canvas.width/12
                verticalCenter: canvas.verticalCenter
            }

            width:parent.width/2
            height: width
            radius: width/2
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    timerLabel.color = "#09A"
                    strokeColor = "#09A"
                    canvas.requestPaint()
                }
                onExited: {
                    timerLabel.color = "Black"
                    strokeColor = "Black"
                    canvas.requestPaint()
                }
                onClicked: {
                    if(!digitalClockTimer.running) {
                        timerLabel.text = maxTime
                        if(restartSwitch) {
                            endPoint = Math.PI*2
                            canvas.requestPaint()
                        }
                        digitalClockTimer.start()
                        restartSwitch = false
                    } else {
                        timerLabel.text = "Pause"
                        digitalClockTimer.stop()
                    }
                }
            }
        }
        Text {
            id:timerLabel
            anchors {
                left:parent.left
                leftMargin: canvas.width/4
                verticalCenter: canvas.verticalCenter
            }

            height:parent.height/5
            width: parent.width/5

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: parent.height/6

            text:"Start"
        }
        Item {
            anchors {
                right:parent.right
                bottom: parent.bottom
                top: parent.top
            }

            width: parent.width*0.3

            Item {
                id:timeSelector
                visible: !digitalClockTimer.running

                function dump() {
                    return minutesSpinBox.value*60 + secondsSpinBox.value
                }

                height:parent.height/3
                width: parent.width
                anchors.centerIn: parent
                Column{
                    anchors.fill: parent
                    spacing: parent.height/10
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:"Minutes:"
                        font.pixelSize: parent.height/6
                    }
                    SpinBox {
                        id:minutesSpinBox
                        anchors.horizontalCenter: parent.horizontalCenter
                        maximumValue: 59
                        minimumValue: 0
                        font.pixelSize: parent.height/6

                        onValueChanged: {
                            initialMaxTime = timeSelector.dump()
                            maxTime = timeSelector.dump()
                            restartSwitch = true
                        }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:"Seconds:"
                        font.pixelSize: parent.height/6
                    }
                    SpinBox {
                        id:secondsSpinBox
                        anchors.horizontalCenter: parent.horizontalCenter
                        maximumValue: 59
                        minimumValue: 1
                        font.pixelSize: parent.height/6

                        onValueChanged: {
                            initialMaxTime = timeSelector.dump()
                            maxTime = timeSelector.dump()
                            restartSwitch = true
                        }
                    }
                }
            }
        }
    }
}
