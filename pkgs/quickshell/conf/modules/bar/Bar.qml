pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.state

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData

            screen: modelData
            visible: true
            color: "transparent"
            implicitHeight: Appearance.sizes.barHeight + Appearance.sizes.barMargin * 2
            exclusiveZone: ShellState.barVisible ? Appearance.sizes.barHeight + Appearance.sizes.barMargin : 0

            anchors {
                top: true
                left: true
                right: true
            }

            mask: Region {
                item: !ShellState.barVisible ? revealStrip : ShellState.barAutohide ? slider : surface
            }

            Timer {
                id: hideTimer

                interval: 700
                onTriggered: {
                    if (ShellState.barAutohide && !barHover.hovered && !revealStrip.containsMouse)
                        ShellState.barVisible = false;
                }
            }

            Connections {
                function onBarVisibleChanged(): void {
                    if (ShellState.barAutohide && ShellState.barVisible)
                        hideTimer.restart();
                }

                target: ShellState
            }

            Item {
                id: slider

                anchors.fill: parent
                visible: opacity > 0.01
                y: ShellState.barVisible ? 0 : -window.implicitHeight
                opacity: ShellState.barVisible ? 1 : 0

                Behavior on y {
                    Anim {}
                }

                Behavior on opacity {
                    Anim {
                        speed: "fast"
                    }
                }

                HoverHandler {
                    id: barHover

                    onHoveredChanged: {
                        if (!ShellState.barAutohide)
                            return;
                        if (barHover.hovered)
                            hideTimer.stop();
                        else
                            hideTimer.restart();
                    }
                }

                Card {
                    id: surface

                    anchors {
                        fill: parent
                        topMargin: Appearance.sizes.barMargin
                        bottomMargin: Appearance.sizes.barMargin
                        leftMargin: Appearance.sizes.barSideMargin
                        rightMargin: Appearance.sizes.barSideMargin
                    }

                    elevated: false
                    color: Appearance.colors.base

                    Clock {
                        id: centreGroup

                        anchors.centerIn: parent
                    }

                    RowLayout {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            right: centreGroup.left
                            leftMargin: Appearance.padding.small
                            rightMargin: Appearance.spacing.large
                        }
                        spacing: Appearance.spacing.normal

                        Workspaces {
                            Layout.alignment: Qt.AlignVCenter
                            screenName: window.modelData.name
                        }

                        NowPlaying {
                            Layout.alignment: Qt.AlignVCenter
                            visible: present
                        }

                        ActiveWindow {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        anchors {
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                            left: centreGroup.right
                            rightMargin: Appearance.padding.small
                            leftMargin: Appearance.spacing.large
                        }
                        spacing: Appearance.spacing.normal
                        layoutDirection: Qt.RightToLeft

                        TextButton {
                            Layout.alignment: Qt.AlignVCenter
                            implicitHeight: Appearance.sizes.barItemHeight
                            text: "pwr"
                            accentColor: Appearance.colors.error
                            toggled: ShellState.sessionOpen
                            onClicked: ShellState.toggle("sessionOpen")
                        }

                        TextButton {
                            Layout.alignment: Qt.AlignVCenter
                            implicitHeight: Appearance.sizes.barItemHeight
                            text: Notifs.count > 0 ? "msg " + Notifs.count : "msg"
                            accentColor: Notifs.silent ? Appearance.colors.error : Appearance.colors.accent
                            toggled: ShellState.notificationsOpen || Notifs.count > 0 || Notifs.silent
                            onClicked: ShellState.toggle("notificationsOpen")
                        }

                        Monitor {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        StatusCluster {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Tray {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            MouseArea {
                id: revealStrip

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 4
                hoverEnabled: true
                visible: ShellState.barAutohide
                onEntered: {
                    ShellState.barVisible = true;
                    hideTimer.stop();
                }
                onExited: {
                    if (ShellState.barAutohide)
                        hideTimer.restart();
                }
            }
        }
    }
}
