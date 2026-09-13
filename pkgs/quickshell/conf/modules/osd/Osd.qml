import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services

PanelWindow {
    id: root

    property string kind: "volume"
    property bool active: false

    readonly property real value: root.kind === "volume" ? Audio.volume : Brightness.value
    readonly property bool off: root.kind === "volume" && Audio.muted
    readonly property string label: root.kind === "volume" ? "volume" : "brightness"

    function show(which: string): void {
        root.kind = which;
        if (which === "brightness")
            Brightness.refresh();
        root.active = true;
        hide.restart();
    }

    visible: root.active || card.opacity > 0.01
    color: "transparent"
    aboveWindows: true
    focusable: false
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 240
    implicitHeight: 110

    anchors {
        bottom: true
    }

    margins {
        bottom: 90
    }

    mask: Region {
        item: card
    }

    Timer {
        id: hide

        interval: 1600
        onTriggered: root.active = false
    }

    Card {
        id: card

        anchors.centerIn: parent
        shown: root.active
        width: parent.width - Appearance.elevation.offset
        implicitHeight: layout.implicitHeight + Appearance.padding.large * 2
        color: Appearance.colors.base

        ColumnLayout {
            id: layout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    text: root.label
                    color: Appearance.colors.subtext
                }

                StyledText {
                    text: root.off ? "muted" : Math.round(root.value * 100) + "%"
                    color: root.off ? Appearance.colors.error : Appearance.colors.text
                    font.family: Appearance.font.family.mono
                    font.pixelSize: Appearance.font.size.medium
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 8
                color: Appearance.colors.layer1
                border.width: Appearance.elevation.borderWidth
                border.color: Appearance.colors.outline

                Rectangle {
                    x: Appearance.elevation.borderWidth
                    y: Appearance.elevation.borderWidth
                    width: Math.max(0, (parent.width - Appearance.elevation.borderWidth * 2) * (root.off ? 0 : Math.max(0, Math.min(1, root.value))))
                    height: parent.height - Appearance.elevation.borderWidth * 2
                    color: root.kind === "volume" ? Appearance.colors.accent : Appearance.colors.warning

                    Behavior on width {
                        Anim {
                            speed: "fast"
                        }
                    }
                }
            }
        }
    }
}
