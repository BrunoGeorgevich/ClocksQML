import QtQuick 2.5
import QtQuick.Controls 1.3

ApplicationWindow {
    id:root
    title: qsTr("Clocks")
    width: 640
    height: 480
    visible: true

    TabView {
        anchors.fill: parent

        DigitalAlarmTab { title:"Digital Alarm" }
        AnalogClockTab { title:"Analog Clock" }
    }
}
