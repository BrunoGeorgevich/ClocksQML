import QtQuick 2.5
import QtQml 2.2
import QtQuick.Controls 1.2

Tab {

    Rectangle {
        anchors.fill: parent

        property double hourRotationGrade : 0
        property double minuteRotationGrade : 0
        property double secondRotationGrade : 0
        property date currentDate: new Date()
        property int hour : currentDate.getHours()
        property int minute : currentDate.getMinutes()
        property int second : currentDate.getSeconds()


        Component.onCompleted: {
            hourRotationGrade += (3600*hour + 60*minute + second)*(4*Math.PI)/86400
            minuteRotationGrade += (60*minute + second)*(2*Math.PI)/3600
            secondRotationGrade += second*(2*Math.PI)/60
        }

        Timer {
            interval:1000
            repeat: true
            running: true
            onTriggered: {
                if(second <= 59 && second >= 0) {
                    second += 1
                    secondRotationGrade += (2*Math.PI)/60
                    minuteRotationGrade += (2*Math.PI)/3600
                    hourRotationGrade += (4*Math.PI)/86400
                } else if(second > 59) {
                    second = 0
                    minute += 1
                    secondRotationGrade = 0

                    if(minute > 59) {
                        hour += 1
                        minute = 0
                        minuteRotationGrade = 0

                        if(hour > 23) {
                            hour = 0
                            hourRotationGrade = 0
                        }
                    }
                }
                canvas.requestPaint()
            }
        }

        Canvas {
            id:canvas
            anchors.fill: parent

            onPaint: {
                var ctx = canvas.getContext("2d")
                ctx.reset()

                var centerX = canvas.width  / 2
                var centerY = canvas.height / 2

                //Ring
                ctx.beginPath()
                ctx.strokeStyle = "black"
                ctx.fillStyle = "#BBB"
                ctx.lineWidth = 15
                ctx.arc(centerX, centerY, canvas.width / 4, 0, Math.PI*2, true)
                ctx.stroke()
                ctx.fill()

                //Big Pointer
                ctx.beginPath()
                ctx.strokeStyle = "darkgray"
                ctx.lineWidth = 10
                ctx.moveTo(centerX,centerY)
                ctx.lineTo(centerX + canvas.width*(0.23)*Math.sin(hourRotationGrade) ,
                           (centerY - canvas.width*(0.23)*Math.cos(hourRotationGrade)))
                ctx.stroke()

                //Med Pointer
                ctx.beginPath()
                ctx.strokeStyle = "gray"
                ctx.lineWidth = 9
                ctx.moveTo(centerX,centerY)
                ctx.lineTo(centerX + canvas.width*(0.20)*Math.sin(minuteRotationGrade) ,
                           (centerY - canvas.width*(0.20)*Math.cos(minuteRotationGrade)))
                ctx.stroke()

                //Med Pointer
                ctx.beginPath()
                ctx.strokeStyle = "green"
                ctx.lineWidth = 8
                ctx.moveTo(centerX,centerY)
                ctx.lineTo(centerX + canvas.width*(0.17)*Math.sin(secondRotationGrade) ,
                           (centerY - canvas.width*(0.17)*Math.cos(secondRotationGrade)))
                ctx.stroke()

                //Center Clock
                ctx.beginPath()
                ctx.fillStyle = "black"
                ctx.arc(centerX,centerY,canvas.width/80,0, Math.PI*2, true)
                ctx.fill()

            }
        }
    }
}
