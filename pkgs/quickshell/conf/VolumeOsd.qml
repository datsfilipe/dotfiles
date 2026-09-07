import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    property bool shown: false
    property bool muted: false
    property real value: 0

    IpcHandler {
        target: "volumeOsd"

        function volume() {
            volumeQuery.running = false
            volumeQuery.running = true
        }
    }

    Process {
        id: volumeQuery
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/([0-9.]+)/)
                root.value = match ? Math.min(Number(match[1]), 1) : 0
                root.muted = text.includes("MUTED")
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
                border.color: root.muted ? Theme.red : Theme.primary

                Row {
                    anchors.centerIn: parent
                    spacing: 14

                    Text {
                        text: root.muted ? "󰝟" : root.value > 0.5 ? "󰕾" : "󰖀"
                        color: root.muted ? Theme.red : Theme.primary
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
                            color: root.muted ? Theme.red : Theme.primary
                        }
                    }
                }
            }
        }
    }
}
