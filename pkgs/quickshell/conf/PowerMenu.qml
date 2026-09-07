pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    visible: false
    aboveWindows: true
    focusable: true
    color: "#66000000"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    property int selectedIndex: 0
    property string selectedLabel: actions[selectedIndex].label
    property var actions: [
        { label: "Shutdown", icon: "", command: ["systemctl", "poweroff"] },
        { label: "Reboot", icon: "", command: ["systemctl", "reboot"] },
        { label: "Suspend", icon: "󰒲", command: ["systemctl", "suspend"] },
        { label: "Logout", icon: "", command: ["niri", "msg", "action", "quit", "-s"] }
    ]

    function open() {
        root.selectedIndex = 0
        root.visible = true
    }

    function close() {
        root.visible = false
    }

    function trigger(index) {
        const action = root.actions[index]
        if (!action)
            return
        root.close()
        Quickshell.execDetached(action.command)
    }

    component ActionButton: Rectangle {
        required property var action
        required property int actionIndex

        Layout.preferredWidth: 68
        Layout.preferredHeight: 68
        radius: root.selectedIndex === actionIndex ? 34 : 18
        color: root.selectedIndex === actionIndex ? Theme.black : Theme.background
        border.width: 1
        border.color: root.selectedIndex === actionIndex ? Theme.alternate : "transparent"

        Text {
            anchors.centerIn: parent
            text: parent.action.icon
            color: root.selectedIndex === parent.actionIndex ? Theme.primary : Theme.foreground
            font.family: Theme.font
            font.pixelSize: 22
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.selectedIndex = parent.actionIndex
            onClicked: root.trigger(parent.actionIndex)
        }

        Behavior on radius { NumberAnimation { duration: 120 } }
    }

    IpcHandler {
        target: "powermenu"

        function toggle() {
            root.visible ? root.close() : root.open()
        }

        function open() {
            root.open()
        }

        function close() {
            root.close()
        }
    }

    Item {
        anchors.fill: parent
        focus: root.visible
        Keys.onEscapePressed: root.close()
        Keys.onLeftPressed: root.selectedIndex = (root.selectedIndex + root.actions.length - 1) % root.actions.length
        Keys.onUpPressed: root.selectedIndex = (root.selectedIndex + root.actions.length - 1) % root.actions.length
        Keys.onRightPressed: root.selectedIndex = (root.selectedIndex + 1) % root.actions.length
        Keys.onDownPressed: root.selectedIndex = (root.selectedIndex + 1) % root.actions.length
        Keys.onReturnPressed: root.trigger(root.selectedIndex)
        Keys.onEnterPressed: root.trigger(root.selectedIndex)
        Keys.onSpacePressed: root.trigger(root.selectedIndex)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Rectangle {
        anchors.centerIn: parent
        width: menuContent.implicitWidth + 48
        height: menuContent.implicitHeight + 38
        radius: 24
        color: Theme.background
        border.width: 4
        border.color: Theme.primary

        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            id: menuContent

            anchors.centerIn: parent
            spacing: 14

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "電源"
                color: Theme.foreground
                font.family: Theme.font
                font.pixelSize: 24
                font.bold: true
            }

            RowLayout {
                spacing: 10

                ActionButton { action: root.actions[0]; actionIndex: 0 }
                ActionButton { action: root.actions[1]; actionIndex: 1 }

                Rectangle {
                    Layout.preferredWidth: 68
                    Layout.preferredHeight: 68
                    radius: 18
                    color: "transparent"

                    AnimatedImage {
                        anchors.fill: parent
                        anchors.margins: 8
                        source: "assets/gif0.gif"
                        fillMode: Image.PreserveAspectFit
                    }
                }

                ActionButton { action: root.actions[2]; actionIndex: 2 }
                ActionButton { action: root.actions[3]; actionIndex: 3 }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.selectedLabel
                color: Theme.primary
                font.family: Theme.uiFont
                font.pixelSize: 12
            }
        }
    }
}
