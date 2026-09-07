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
        width: actionsRow.implicitWidth + 24
        height: actionsRow.implicitHeight + 24
        radius: 6
        color: Theme.background
        border.width: 4
        border.color: Theme.primary

        MouseArea {
            anchors.fill: parent
        }

        RowLayout {
            id: actionsRow

            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: root.actions

                Rectangle {
                    id: button

                    required property var modelData
                    required property int index
                    width: 72
                    height: 72
                    radius: 6
                    color: root.selectedIndex === index ? Theme.black : Theme.background
                    border.width: 1
                    border.color: root.selectedIndex === index ? Theme.alternate : "transparent"

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: button.modelData.icon
                            color: root.selectedIndex === button.index ? Theme.primary : Theme.foreground
                            font.family: Theme.font
                            font.pixelSize: 22
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: button.modelData.label
                            color: Theme.foreground
                            opacity: 0.7
                            font.family: Theme.uiFont
                            font.pixelSize: 10
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.selectedIndex = button.index
                        onClicked: root.trigger(button.index)
                    }
                }
            }
        }
    }
}
