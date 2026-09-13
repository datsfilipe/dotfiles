import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.state

Scope {
    id: root

    readonly property int dockHeight: 130
    readonly property int blockInset: 56
    readonly property bool shown: ShellState.mediaOpen

    property real reveal: root.shown ? 1 : 0

    Behavior on reveal {
        Anim {
            speed: root.shown ? "enter" : "exit"
        }
    }

    onShownChanged: {
        if (root.shown)
            Cava.subscribe();
        else
            Cava.unsubscribe();
    }

    PanelWindow {
        id: window

        visible: root.shown || root.reveal > 0.001
        color: "transparent"
        focusable: false
        implicitHeight: root.dockHeight + Appearance.elevation.offset
        exclusiveZone: Math.round(root.dockHeight * root.reveal)

        anchors {
            bottom: true
            left: true
            right: true
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: dock.top
            anchors.leftMargin: root.blockInset
            anchors.rightMargin: root.blockInset
            height: Appearance.elevation.offset
            color: Appearance.colors.shadow
        }

        Item {
            id: dock

            height: root.dockHeight
            y: parent.height - root.dockHeight * root.reveal

            anchors {
                left: parent.left
                right: parent.right
            }

            MouseArea {
                anchors.fill: parent
            }

            Rectangle {
                anchors.fill: parent
                color: Appearance.colors.base
            }

            Item {
                anchors.fill: parent
                anchors.topMargin: Appearance.elevation.borderWidth
                clip: true

                Bars {
                    anchors.fill: parent
                    values: Cava.values
                    gap: 2
                    barColor: Appearance.colors.accent
                }

                Rectangle {
                    anchors.fill: parent
                    color: Appearance.alpha(Appearance.colors.base, 0.62)
                }
            }

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Appearance.elevation.borderWidth
                color: Appearance.colors.outline
            }

            Rectangle {
                id: progress

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: Appearance.elevation.borderWidth
                height: 2
                color: "transparent"
                visible: Players.length > 0

                Rectangle {
                    width: parent.width * Players.progress
                    height: parent.height
                    color: Appearance.colors.accentDim

                    Behavior on width {
                        Anim {
                            speed: "fast"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.topMargin: -2
                    anchors.bottomMargin: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: event => Players.seekRatio(event.x / width)
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Appearance.sizes.barSideMargin
                anchors.rightMargin: Appearance.sizes.barSideMargin
                anchors.topMargin: Appearance.padding.normal
                anchors.bottomMargin: Appearance.padding.normal
                spacing: Appearance.spacing.large

                Rectangle {
                    Layout.preferredWidth: 76
                    Layout.preferredHeight: 76
                    Layout.alignment: Qt.AlignVCenter
                    color: Appearance.colors.layer2
                    border.width: Appearance.elevation.borderWidth
                    border.color: Appearance.colors.outline
                    clip: true

                    Image {
                        anchors.fill: parent
                        anchors.margins: Appearance.elevation.borderWidth
                        visible: Players.artUrl !== ""
                        source: Players.artUrl
                        sourceSize.width: 152
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: true
                    }

                    Label {
                        anchors.centerIn: parent
                        visible: Players.artUrl === ""
                        text: "~"
                        color: Appearance.colors.faint
                        font.pixelSize: Appearance.font.size.large
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    StyledText {
                        Layout.fillWidth: true
                        text: Players.hasActive ? Players.title : "nothing playing"
                        elide: Text.ElideRight
                        color: Players.hasActive ? Appearance.colors.text : Appearance.colors.faint
                        font.pixelSize: Appearance.font.size.large
                    }

                    StyledText {
                        Layout.fillWidth: true
                        visible: text !== ""
                        text: Players.hasActive ? (Players.artist || Players.active?.identity || "") : ""
                        elide: Text.ElideRight
                        color: Appearance.colors.subtext
                        font.pixelSize: Appearance.font.size.normal
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: Appearance.spacing.small

                    TextButton {
                        implicitWidth: 38
                        implicitHeight: 30
                        horizontalPadding: 0
                        text: "|<"
                        disabled: !Players.hasActive
                        onClicked: Players.previous()
                    }

                    TextButton {
                        implicitWidth: 46
                        implicitHeight: 30
                        horizontalPadding: 0
                        text: Players.playing ? "||" : "|>"
                        textColor: Appearance.colors.accent
                        disabled: !Players.hasActive
                        onClicked: Players.toggle()
                    }

                    TextButton {
                        implicitWidth: 38
                        implicitHeight: 30
                        horizontalPadding: 0
                        text: ">|"
                        disabled: !Players.hasActive
                        onClicked: Players.next()
                    }

                    TextButton {
                        Layout.leftMargin: Appearance.spacing.large
                        implicitWidth: 38
                        implicitHeight: 30
                        horizontalPadding: 0
                        text: "x"
                        accentColor: Appearance.colors.error
                        onClicked: ShellState.mediaOpen = false
                    }
                }
            }
        }
    }
}
