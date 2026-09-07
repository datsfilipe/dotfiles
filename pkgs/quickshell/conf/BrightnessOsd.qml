import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    property bool shown: false
    property real value: 0

    IpcHandler {
        target: "osd"

        function brightness() {
            brightnessQuery.running = false
            brightnessQuery.running = true
        }
    }

    Process {
        id: brightnessQuery
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/(\\d+)%/)
                if (match)
                    root.value = Number(match[1]) / 100
                root.shown = true
                hideTimer.restart()
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 1400
        onTriggered: root.shown = false
    }

    LazyLoader {
        active: root.shown

        PanelWindow {
            anchors.bottom: true
            margins.bottom: screen.height / 10
            implicitWidth: 280
            implicitHeight: 54
            color: "transparent"
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: Theme.background
                border.width: 3
                border.color: Theme.primary

                Row {
                    anchors.centerIn: parent
                    spacing: 14

                    Text {
                        text: "󰃠"
                        color: Theme.primary
                        font.family: Theme.font
                        font.pixelSize: 26
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 190
                        height: 10
                        radius: 5
                        color: Theme.alternate

                        Rectangle {
                            width: parent.width * root.value
                            height: parent.height
                            radius: parent.radius
                            color: Theme.primary
                        }
                    }
                }
            }
        }
    }
}
