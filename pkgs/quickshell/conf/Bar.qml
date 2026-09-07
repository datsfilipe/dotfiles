pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
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
            implicitHeight: 40
            color: "transparent"
            exclusiveZone: visible ? implicitHeight : 0

            anchors {
                top: true
                left: true
                right: true
            }

            property var workspaces: []
            property string focusedTitle: ""
            property int cpuUsage: 0
            property int ramUsage: 0
            property string networkIcon: "󰈃"
            property string keyboardLayout: "EN"
            property int previousIdle: 0
            property int previousTotal: 0

            Process {
                id: niriState
                command: ["sh", "-c", "niri msg -j workspaces && printf '\\n---\\n' && niri msg -j focused-window"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        try {
                            const parts = text.split("\n---\n")
                            const all = JSON.parse(parts[0])
                            window.workspaces = all.filter(ws => ws.output === window.screen.name).sort((a, b) => a.idx - b.idx)
                            const focused = JSON.parse(parts[1])
                            window.focusedTitle = focused?.title ?? ""
                        } catch (error) {
                            window.workspaces = []
                            window.focusedTitle = ""
                        }
                    }
                }
            }

            Process {
                id: stats
                command: ["sh", "-c", "head -n1 /proc/stat; grep -E 'MemTotal|MemAvailable' /proc/meminfo; ip -brief address show up; niri msg keyboard-layouts"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        const lines = text.split("\n")
                        const cpu = lines[0].trim().split(/\\s+/).slice(1).map(Number)
                        const idle = cpu[3] + (cpu[4] || 0)
                        const total = cpu.reduce((sum, value) => sum + value, 0)
                        if (window.previousTotal > 0 && total > window.previousTotal)
                            window.cpuUsage = Math.round((1 - (idle - window.previousIdle) / (total - window.previousTotal)) * 100)
                        window.previousIdle = idle
                        window.previousTotal = total
                        const totalLine = lines.find(line => line.startsWith("MemTotal:"))
                        const availableLine = lines.find(line => line.startsWith("MemAvailable:"))
                        if (totalLine && availableLine) {
                            const memoryTotal = Number(totalLine.trim().split(/\\s+/)[1])
                            const memoryAvailable = Number(availableLine.trim().split(/\\s+/)[1])
                            window.ramUsage = Math.round((memoryTotal - memoryAvailable) / memoryTotal * 100)
                        }
                        const ethernet = lines.find(line => /^(en|eth)/.test(line.trim()))
                        window.networkIcon = ethernet ? "󰈀" : "󰈃"
                        const activeLayout = lines.find(line => line.trim().startsWith("*")) ?? ""
                        window.keyboardLayout = activeLayout.includes("intl") ? "EN (intl)" : "EN"
                    }
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: true
                triggeredOnStart: true
                onTriggered: {
                    if (!niriState.running)
                        niriState.running = true
                    if (!stats.running)
                        stats.running = true
                }
            }

            Rectangle {
                anchors {
                    fill: parent
                    leftMargin: 6
                    rightMargin: 6
                    topMargin: 4
                    bottomMargin: 4
                }
                radius: 6
                color: Theme.background

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 12

                    Row {
                        spacing: 7

                        Repeater {
                            model: window.workspaces

                            Rectangle {
                                required property var modelData
                                anchors.verticalCenter: parent.verticalCenter
                                width: modelData.is_active ? 20 : 7
                                height: 7
                                radius: 4
                                color: modelData.is_active ? Theme.foreground : Theme.selection

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(modelData.idx)])
                                }
                            }
                        }

                    }

                    Text {
                        Layout.maximumWidth: 650
                        Layout.fillWidth: true
                        text: window.focusedTitle
                        elide: Text.ElideRight
                        color: Theme.foreground
                        font.family: Theme.font
                        font.pixelSize: 13
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "CPU " + String(window.cpuUsage).padStart(2, "0") + "%"
                        color: Theme.foreground
                        opacity: 0.64
                        font.family: Theme.font
                        font.pixelSize: 12
                    }

                    Text {
                        text: "RAM " + window.ramUsage + "%"
                        color: Theme.foreground
                        opacity: 0.64
                        font.family: Theme.font
                        font.pixelSize: 12
                    }

                    Row {
                        spacing: 10
                        visible: SystemTray.items.values.length > 0

                        Repeater {
                            model: SystemTray.items.values

                            IconImage {
                                required property var modelData
                                width: 16
                                height: 16
                                source: modelData.icon

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                                    onClicked: mouse => {
                                        if (mouse.button === Qt.LeftButton)
                                            modelData.activate()
                                        else
                                            modelData.secondaryActivate()
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        text: window.networkIcon
                        color: window.networkIcon === "󰈀" ? Theme.primary : Theme.foreground
                        opacity: window.networkIcon === "󰈀" ? 1 : 0.4
                        font.family: Theme.font
                        font.pixelSize: 16
                    }

                    Text {
                        visible: UPower.displayDevice.isLaptopBattery
                        text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                        color: Theme.foreground
                        font.family: Theme.font
                        font.pixelSize: 12
                    }

                    Text {
                        text: window.keyboardLayout
                        color: Theme.primary
                        font.family: Theme.font
                        font.pixelSize: 12

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(window.keyboardLayout === "EN (intl)" ? ["switch-kb-variant"] : ["switch-kb-variant", "intl"])
                        }
                    }

                    SystemClock {
                        id: clock
                        precision: SystemClock.Seconds
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "ddd. MMM d - hh:mm:")
                        color: Theme.foreground
                        opacity: 0.72
                        font.family: Theme.font
                        font.pixelSize: 12
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "ss")
                        color: Theme.red
                        font.family: Theme.font
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
