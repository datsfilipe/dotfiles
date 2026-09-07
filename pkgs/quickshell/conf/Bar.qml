pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Widgets

Scope {
    id: root
    required property bool visibleState

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property var modelData
            screen: modelData
            visible: root.visibleState
            implicitHeight: 42
            color: "transparent"
            exclusiveZone: visible ? implicitHeight : 0
            anchors { top: true; left: true; right: true }

            property var mediaPlayer: Mpris.players.values.find(player => player.isPlaying) ?? Mpris.players.values[0] ?? null
            property var outputWorkspaces: NiriState.workspaces.filter(workspace => workspace.output === screen.name)
            property var outputWindows: NiriState.windows.filter(client => outputWorkspaces.some(workspace => workspace.id === client.workspace_id))
            property int activeWorkspace: outputWorkspaces.find(workspace => workspace.is_active)?.idx ?? 1
            property int shownWorkspaces: Math.max(5, ...outputWorkspaces.map(workspace => workspace.idx))

            Rectangle {
                anchors { fill: parent; leftMargin: 6; rightMargin: 6; topMargin: 4; bottomMargin: 4 }
                radius: 9
                color: Theme.background
                border.width: 1
                border.color: Theme.alternate

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Rectangle {
                        implicitWidth: workspaceRow.implicitWidth + 8
                        implicitHeight: 26
                        radius: 13
                        color: Theme.black

                        Row {
                            id: workspaceRow
                            anchors.centerIn: parent
                            spacing: 2

                            Repeater {
                                model: window.shownWorkspaces

                                Rectangle {
                                    id: workspaceButton
                                    required property int index
                                    property int workspaceNumber: index + 1
                                    property bool active: workspaceNumber === window.activeWorkspace
                                    property bool occupied: window.outputWindows.some(client => window.outputWorkspaces.find(workspace => workspace.id === client.workspace_id)?.idx === workspaceNumber)
                                    width: active ? 28 : 20
                                    height: 20
                                    radius: 10
                                    color: active ? Theme.primary : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: parent.occupied ? "●" : "·"
                                        color: parent.active ? Theme.black : parent.occupied ? Theme.foreground : Theme.selection
                                        font.family: Theme.font
                                        font.pixelSize: parent.active ? 11 : 14
                                    }

                                    Behavior on width { NumberAnimation { duration: 120 } }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(workspaceButton.workspaceNumber)])
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 120
                        text: NiriState.focusedTitle
                        elide: Text.ElideRight
                        color: Theme.foreground
                        font.family: Theme.font
                        font.pixelSize: 13
                    }

                    Rectangle {
                        visible: window.mediaPlayer !== null
                        Layout.maximumWidth: 260
                        implicitWidth: Math.min(mediaRow.implicitWidth + 18, 260)
                        implicitHeight: 26
                        radius: 13
                        color: Theme.black

                        Row {
                            id: mediaRow
                            anchors.centerIn: parent
                            spacing: 7
                            Text { text: window.mediaPlayer?.isPlaying ? "Ⅱ" : "▶"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 11 }
                            Text {
                                width: Math.min(implicitWidth, 210)
                                text: window.mediaPlayer?.trackTitle || window.mediaPlayer?.identity || ""
                                elide: Text.ElideRight
                                color: Theme.foreground
                                font.family: Theme.font
                                font.pixelSize: 11
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: if (window.mediaPlayer?.canTogglePlaying) window.mediaPlayer.togglePlaying()
                            onWheel: event => {
                                if (window.mediaPlayer?.canSeek)
                                    window.mediaPlayer.seek(event.angleDelta.y > 0 ? 5000000 : -5000000)
                            }
                        }
                    }

                    Row {
                        spacing: 5

                        Repeater {
                            model: [{ label: "C", value: ResourceUsage.cpuUsage }, { label: "M", value: ResourceUsage.memoryUsage }]
                            Rectangle {
                                required property var modelData
                                width: 50
                                height: 26
                                radius: 13
                                color: Theme.black
                                Text {
                                    anchors.centerIn: parent
                                    text: parent.modelData.label + " " + Math.round(parent.modelData.value * 100)
                                    color: parent.modelData.value > 0.8 ? Theme.red : Theme.foreground
                                    font.family: Theme.font
                                    font.pixelSize: 11
                                }
                            }
                        }
                    }

                    Row {
                        spacing: 7
                        visible: SystemTray.items.values.length > 0

                        Repeater {
                            model: SystemTray.items

                            Item {
                                id: trayItem
                                required property var modelData
                                width: 18
                                height: 18
                                IconImage { anchors.fill: parent; source: trayItem.modelData.icon }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                                    onPressed: event => {
                                        if (event.button === Qt.MiddleButton) {
                                            trayItem.modelData.secondaryActivate()
                                        } else if (event.button === Qt.RightButton || trayItem.modelData.onlyMenu) {
                                            const point = trayItem.mapToItem(window.contentItem, 0, trayItem.height)
                                            trayItem.modelData.display(window, point.x, point.y)
                                        } else {
                                            trayItem.modelData.activate()
                                        }
                                        event.accepted = true
                                    }
                                    onWheel: event => trayItem.modelData.scroll(event.angleDelta.y, false)
                                }
                            }
                        }
                    }

                    Text { visible: UPower.displayDevice.isLaptopBattery; text: Math.round(UPower.displayDevice.percentage * 100) + "%"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 11 }

                    Rectangle {
                        implicitWidth: layoutText.implicitWidth + 14
                        implicitHeight: 26
                        radius: 13
                        color: Theme.black
                        Text { id: layoutText; anchors.centerIn: parent; text: NiriState.keyboardLayoutIndex === 0 ? "EN AltGr" : "EN Intl"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 11 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(NiriState.keyboardLayoutIndex === 0 ? ["switch-kb-variant", "intl"] : ["switch-kb-variant"])
                        }
                    }

                    SystemClock { id: clock; precision: SystemClock.Seconds }
                    Row {
                        spacing: 0
                        Text { text: Qt.formatDateTime(clock.date, "ddd MMM d  hh:mm:"); color: Theme.foreground; opacity: 0.72; font.family: Theme.font; font.pixelSize: 11 }
                        Text { text: Qt.formatDateTime(clock.date, "ss"); color: Theme.red; font.family: Theme.font; font.pixelSize: 11 }
                    }
                }
            }
        }
    }
}
