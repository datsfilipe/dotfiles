pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.state

Overlay {
    id: root

    property string pending: ""

    shown: ShellState.wallpapersOpen
    onDismissed: root.dismiss()

    onShownChanged: {
        if (root.shown) {
            root.pending = "";
            Wallpapers.scan();
        } else if (Wallpapers.preview !== "") {
            Wallpapers.restore();
        }
    }

    function dismiss(): void {
        ShellState.wallpapersOpen = false;
    }

    Card {
        id: panel

        shown: root.shown
        growFrom: Item.Center
        color: Appearance.colors.base
        width: Math.min(940, parent.width - Appearance.spacing.huge * 2)
        height: Math.min(640, parent.height - Appearance.spacing.huge * 2)
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.normal

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1

                    Label {
                        text: "wallpaper"
                        color: Appearance.colors.subtext
                        font.pixelSize: Appearance.font.size.small
                    }

                    StyledText {
                        text: Wallpapers.scanning ? "building thumbnails…" : "hover to preview, click to select"
                        color: Appearance.colors.faint
                        font.pixelSize: Appearance.font.size.small
                    }
                }

                TextButton {
                    visible: root.pending !== ""
                    implicitHeight: 30
                    text: "apply and rebuild"
                    toggled: true
                    onClicked: {
                        Wallpapers.apply(root.pending);
                        root.dismiss();
                    }
                }
            }

            GridView {
                id: grid

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                cellWidth: Math.floor(grid.width / Math.max(1, Math.floor(grid.width / 220)))
                cellHeight: Math.round(grid.cellWidth * 0.66)
                model: Wallpapers.list

                delegate: Item {
                    id: cell

                    required property var modelData

                    width: grid.cellWidth
                    height: grid.cellHeight

                    Card {
                        anchors.fill: parent
                        anchors.margins: Appearance.spacing.tiny
                        elevated: false
                        color: Appearance.colors.layer1
                        border.color: root.pending === cell.modelData.path ? Appearance.colors.accent : mouse.containsMouse ? Appearance.colors.outlineStrong : Appearance.colors.outline
                        border.width: root.pending === cell.modelData.path ? 2 : 1
                        clip: true

                        Behavior on border.color {
                            ColorAnim {}
                        }

                        Image {
                            anchors.fill: parent
                            anchors.margins: 3
                            source: "file://" + cell.modelData.thumbnail
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 3
                            height: 26
                            color: Appearance.alpha(Appearance.colors.base, 0.85)
                            opacity: mouse.containsMouse || root.pending === cell.modelData.path ? 1 : 0

                            Behavior on opacity {
                                Anim {
                                    speed: "fast"
                                }
                            }

                            StyledText {
                                anchors.fill: parent
                                anchors.leftMargin: Appearance.padding.small
                                anchors.rightMargin: Appearance.padding.small
                                text: cell.modelData.name
                                elide: Text.ElideMiddle
                                color: Appearance.colors.subtext
                                font.family: Appearance.font.family.mono
                                font.pixelSize: Appearance.font.size.tiny
                            }
                        }

                        MouseArea {
                            id: mouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: Wallpapers.previewOne(cell.modelData.path)
                            onClicked: root.pending = cell.modelData.path
                        }
                    }
                }
            }
        }
    }
}
