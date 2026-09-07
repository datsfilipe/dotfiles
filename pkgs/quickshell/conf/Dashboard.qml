import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    visible: false
    aboveWindows: true
    focusable: true
    color: "#66000000"
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }

    property int remaining: 25 * 60
    property bool focusing: false
    property var player: Mpris.players.values.find(item => item.isPlaying) ?? Mpris.players.values[0] ?? null

    function toggle() { root.visible = !root.visible }

    IpcHandler {
        target: "dashboard"
        function toggle() { root.toggle() }
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.focusing
        onTriggered: {
            if (root.remaining > 0)
                root.remaining--
            else
                root.focusing = false
        }
    }

    MouseArea { anchors.fill: parent; onClicked: root.visible = false }

    Rectangle {
        anchors.centerIn: parent
        width: 440
        height: content.implicitHeight + 40
        radius: 26
        color: Theme.background
        border.width: 1
        border.color: Theme.alternate
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            id: content
            anchors.centerIn: parent
            width: parent.width - 40
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text { text: "作業室"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 22; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: "studio deck"; color: Theme.foreground; opacity: 0.45; font.family: Theme.uiFont; font.pixelSize: 11 }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 76
                radius: 18
                color: Theme.black

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    Text { text: "集中"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 14; font.bold: true }
                    Text {
                        Layout.fillWidth: true
                        text: String(Math.floor(root.remaining / 60)).padStart(2, "0") + ":" + String(root.remaining % 60).padStart(2, "0")
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.foreground
                        font.family: Theme.font
                        font.pixelSize: 28
                    }
                    Text { text: root.focusing ? "Ⅱ" : "▶"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 20
                        MouseArea { anchors.fill: parent; anchors.margins: -12; onClicked: root.focusing = !root.focusing }
                    }
                    Text { text: "↻"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 20
                        MouseArea { anchors.fill: parent; anchors.margins: -12; onClicked: { root.remaining = 25 * 60; root.focusing = false } }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: root.player ? 72 : 0
                visible: root.player !== null
                radius: 18
                color: Theme.black

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    Text { text: "音楽"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 14; font.bold: true }
                    Text { Layout.fillWidth: true; text: root.player?.trackTitle || root.player?.identity || ""; elide: Text.ElideRight; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 12 }
                    Text { text: "‹"; color: Theme.foreground; font.pixelSize: 24; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: if (root.player?.canGoPrevious) root.player.previous() } }
                    Text { text: root.player?.isPlaying ? "Ⅱ" : "▶"; color: Theme.primary; font.pixelSize: 18; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: if (root.player?.canTogglePlaying) root.player.togglePlaying() } }
                    Text { text: "›"; color: Theme.foreground; font.pixelSize: 24; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: if (root.player?.canGoNext) root.player.next() } }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: [
                        { label: "端末", detail: "terminal", command: ["alacritty"] },
                        { label: "描く", detail: "krita", command: ["krita"] },
                        { label: "見る", detail: "browser", command: ["brave"] }
                    ]

                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        height: 68
                        radius: 18
                        color: Theme.black
                        border.width: 1
                        border.color: Theme.alternate
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.modelData.label; color: Theme.primary; font.family: Theme.font; font.pixelSize: 15; font.bold: true }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.modelData.detail; color: Theme.foreground; opacity: 0.45; font.family: Theme.uiFont; font.pixelSize: 10 }
                        }
                        MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(parent.modelData.command); root.visible = false } }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "CPU  " + Math.round(ResourceUsage.cpuUsage * 100) + "%"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 11 }
                Rectangle { Layout.fillWidth: true; height: 6; radius: 3; color: Theme.alternate; Rectangle { width: parent.width * ResourceUsage.cpuUsage; height: parent.height; radius: 3; color: Theme.primary } }
                Text { text: "RAM  " + Math.round(ResourceUsage.memoryUsage * 100) + "%"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 11 }
                Rectangle { Layout.fillWidth: true; height: 6; radius: 3; color: Theme.alternate; Rectangle { width: parent.width * ResourceUsage.memoryUsage; height: parent.height; radius: 3; color: Theme.primary } }
            }
        }
    }
}
