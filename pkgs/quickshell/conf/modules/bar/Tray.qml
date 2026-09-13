pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.components
import qs.config

Item {
    id: root

    readonly property var items: SystemTray.items.values

    property bool expanded: false

    implicitWidth: root.items.length === 0 ? 0 : content.implicitWidth
    implicitHeight: Appearance.sizes.barItemHeight
    visible: root.items.length > 0

    Behavior on implicitWidth {
        Anim {
            speed: "fast"
        }
    }

    HoverHandler {
        id: hover

        onHoveredChanged: {
            if (hover.hovered) {
                collapse.stop();
                root.expanded = true;
            } else {
                collapse.restart();
            }
        }
    }

    Timer {
        id: collapse

        interval: 400
        onTriggered: root.expanded = false
    }

    Row {
        id: content

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        spacing: Appearance.spacing.small

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: "[" + root.items.length + "]"
            color: root.expanded ? Appearance.colors.accent : Appearance.colors.faint
            font.letterSpacing: 0
        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: root.expanded ? icons.implicitWidth : 0
            height: Appearance.sizes.barItemHeight
            clip: true

            Behavior on width {
                Anim {
                    speed: "fast"
                }
            }

            Row {
                id: icons

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: Appearance.spacing.normal

                Repeater {
                    model: root.items

                    Item {
                        id: entry

                        required property var modelData

                        width: 14
                        height: Appearance.sizes.barItemHeight

                        IconImage {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            source: entry.modelData.icon
                            opacity: mouse.containsMouse ? 1 : 0.75

                            Behavior on opacity {
                                Anim {
                                    speed: "fast"
                                }
                            }
                        }

                        MouseArea {
                            id: mouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                            onPressed: event => {
                                if (event.button === Qt.MiddleButton) {
                                    entry.modelData.secondaryActivate();
                                } else if (event.button === Qt.RightButton || entry.modelData.onlyMenu) {
                                    menuAnchor.anchor.rect = Qt.rect(0, entry.height, entry.width, 1);
                                    menuAnchor.open();
                                } else {
                                    entry.modelData.activate();
                                }
                                event.accepted = true;
                            }
                            onWheel: event => entry.modelData.scroll(event.angleDelta.y, false)
                        }

                        QsMenuAnchor {
                            id: menuAnchor

                            menu: entry.modelData.menu
                            anchor.item: entry
                        }
                    }
                }
            }
        }
    }
}
