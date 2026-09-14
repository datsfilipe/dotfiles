pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.state

Scope {
    id: root

    property var levels: []

    readonly property bool shown: ShellState.trayMenu !== null
    readonly property var current: root.levels.length > 0 ? root.levels[root.levels.length - 1] : null

    onShownChanged: {
        root.levels = ShellState.trayMenu === null ? [] : [ShellState.trayMenu];
    }

    function descend(handle): void {
        root.levels = root.levels.concat([handle]);
    }

    function ascend(): void {
        root.levels = root.levels.slice(0, -1);
    }

    PanelWindow {
        id: window

        visible: root.shown
        color: "transparent"
        aboveWindows: true
        focusable: false
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: ShellState.closeTrayMenu()
        }

        QsMenuOpener {
            id: opener

            menu: root.current
        }

        Card {
            id: panel

            readonly property int maxWidth: 340

            shown: root.shown
            growFrom: Item.TopLeft
            elevated: true
            implicitWidth: Math.max(180, Math.min(panel.maxWidth, layout.implicitWidth + Appearance.padding.small * 2))
            implicitHeight: layout.implicitHeight + Appearance.padding.small * 2
            x: Math.max(Appearance.sizes.barSideMargin, Math.min(ShellState.trayMenuX, window.width - panel.implicitWidth - Appearance.sizes.barSideMargin))
            y: ShellState.trayMenuY

            MouseArea {
                anchors.fill: parent
            }

            ColumnLayout {
                id: layout

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Appearance.padding.small
                spacing: 0

                Row {
                    id: back

                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? 26 : 0
                    visible: root.levels.length > 1
                    spacing: Appearance.spacing.small

                    InteractiveRect {
                        width: layout.width
                        height: 26

                        onClicked: root.ascend()

                        Label {
                            anchors.left: parent.left
                            anchors.leftMargin: Appearance.padding.small
                            anchors.verticalCenter: parent.verticalCenter
                            text: "<  back"
                            color: Appearance.colors.faint
                        }
                    }
                }

                Repeater {
                    model: opener.children

                    Item {
                        id: row

                        required property var modelData

                        readonly property bool separator: row.modelData.isSeparator
                        readonly property bool checkable: row.modelData.buttonType !== QsMenuButtonType.None

                        Layout.fillWidth: true
                        Layout.preferredHeight: row.separator ? 7 : 26

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: Appearance.elevation.borderWidth
                            visible: row.separator
                            color: Appearance.colors.outline
                        }

                        InteractiveRect {
                            anchors.fill: parent
                            visible: !row.separator
                            disabled: !row.modelData.enabled

                            onClicked: {
                                if (row.modelData.hasChildren)
                                    root.descend(row.modelData);
                                else {
                                    row.modelData.triggered();
                                    ShellState.closeTrayMenu();
                                }
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Appearance.padding.small
                                anchors.rightMargin: Appearance.padding.small
                                spacing: Appearance.spacing.small

                                Label {
                                    visible: row.checkable
                                    text: row.modelData.checkState === Qt.Checked ? "[*]" : "[ ]"
                                    color: row.modelData.checkState === Qt.Checked ? Appearance.colors.accent : Appearance.colors.faint
                                    font.letterSpacing: 0
                                }

                                StyledText {
                                    Layout.fillWidth: true
                                    text: row.modelData.text
                                    elide: Text.ElideRight
                                    color: Appearance.colors.subtext
                                    font.pixelSize: Appearance.font.size.normal
                                }

                                Label {
                                    visible: row.modelData.hasChildren
                                    text: ">"
                                    color: Appearance.colors.faint
                                    font.letterSpacing: 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
