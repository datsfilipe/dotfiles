import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.state

Popout {
    id: root

    shown: ShellState.dashboardOpen
    onDismissed: ShellState.dashboardOpen = false
    panelWidth: 460
    panelHeight: 280

    onShownChanged: {
        if (root.shown)
            SysInfo.refreshSlow();
    }

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.normal

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.normal

                StyledText {
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    color: Appearance.colors.text
                    font.family: Appearance.font.family.mono
                    font.pixelSize: Appearance.font.size.display
                }

                StyledText {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 4
                    text: Qt.formatDate(clock.date, "MMMM d").toLowerCase()
                    elide: Text.ElideRight
                    color: Appearance.colors.subtext
                    font.pixelSize: Appearance.font.size.medium
                }
            }

            Label {
                text: SysInfo.uptime === "" ? "" : "uptime - " + SysInfo.uptime
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: Appearance.spacing.small
            spacing: Appearance.spacing.small

            Meter {
                Layout.fillWidth: true
                label: "cpu"
                value: SysInfo.cpu
                detail: SysInfo.load.toFixed(2) + " load"
                readout: Math.round(SysInfo.cpu * 100) + "%"
                fillColor: Appearance.colors.accent
            }

            Meter {
                Layout.fillWidth: true
                label: "memory"
                value: SysInfo.memory
                detail: SysInfo.memoryLabel
                readout: Math.round(SysInfo.memory * 100) + "%"
                fillColor: Appearance.colors.info
            }

            Meter {
                Layout.fillWidth: true
                label: "storage"
                value: SysInfo.diskUsed
                detail: SysInfo.diskLabel
                readout: Math.round(SysInfo.diskUsed * 100) + "%"
                fillColor: Appearance.colors.success
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: Appearance.spacing.small
            spacing: Appearance.spacing.normal

            Item {
                Layout.fillWidth: true
            }

            Legend {
                tint: Appearance.colors.accent
                text: "cpu"
            }

            Legend {
                tint: Appearance.colors.info
                text: "memory"
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 60

            Graph {
                anchors.fill: parent
                samples: SysInfo.memoryHistory
                lineColor: Appearance.colors.info
                fillOpacity: 0.08
            }

            Graph {
                anchors.fill: parent
                samples: SysInfo.cpuHistory
                lineColor: Appearance.colors.accent
                fillOpacity: 0.12
            }
        }
    }

    component Legend: RowLayout {
        id: legend

        property color tint
        property string text

        spacing: Appearance.spacing.small

        Rectangle {
            Layout.preferredWidth: 12
            Layout.preferredHeight: 3
            color: legend.tint
        }

        Label {
            text: legend.text
            color: Appearance.colors.subtext
        }
    }
}
