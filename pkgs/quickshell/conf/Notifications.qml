pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets

Scope {
    id: root

    NotificationServer {
        id: server
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        keepOnReload: true
        onNotification: notification => notification.tracked = true
    }

    PanelWindow {
        screen: Quickshell.screens[0]
        anchors.top: true
        anchors.right: true
        margins.top: 48
        margins.right: 10
        implicitWidth: 360
        implicitHeight: stack.implicitHeight
        color: "transparent"
        exclusiveZone: 0
        focusable: server.trackedNotifications.values.length > 0
        visible: server.trackedNotifications.values.length > 0

        Item {
            anchors.fill: parent
            focus: parent.visible
            Keys.onEscapePressed: {
                for (const notification of server.trackedNotifications.values)
                    notification.dismiss()
            }
        }

        Column {
            id: stack
            width: 360
            spacing: 8

            Repeater {
                model: server.trackedNotifications

                Rectangle {
                    id: toast
                    required property Notification modelData
                    width: 360
                    height: Math.max(96, content.implicitHeight + 24)
                    radius: 18
                    color: Theme.background
                    border.width: 1
                    border.color: Theme.alternate
                    clip: true

                    Rectangle {
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: 5
                        color: Theme.primary
                    }

                    RowLayout {
                        id: content
                        anchors.fill: parent
                        anchors.margins: 12
                        anchors.leftMargin: 16
                        spacing: 12

                        Rectangle {
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            radius: 16
                            color: Theme.black

                            Image {
                                anchors.fill: parent
                                anchors.margins: toast.modelData.image ? 0 : 10
                                source: toast.modelData.image || Quickshell.iconPath(toast.modelData.appIcon, true)
                                fillMode: Image.PreserveAspectCrop
                                visible: source !== ""
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: !parent.children[0].visible
                                text: (toast.modelData.appName || "?").slice(0, 1).toUpperCase()
                                color: Theme.primary
                                font.family: Theme.font
                                font.pixelSize: 20
                                font.bold: true
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            RowLayout {
                                Layout.fillWidth: true
                                Text { Layout.fillWidth: true; text: toast.modelData.appName || "知らせ"; color: Theme.primary; opacity: 0.8; font.family: Theme.uiFont; font.pixelSize: 10; font.bold: true }
                                Text { text: "今"; color: Theme.foreground; opacity: 0.35; font.family: Theme.font; font.pixelSize: 10 }
                            }

                            Text { Layout.fillWidth: true; text: toast.modelData.summary; color: Theme.foreground; font.family: Theme.uiFont; font.bold: true; font.pixelSize: 13; elide: Text.ElideRight }
                            Text { Layout.fillWidth: true; text: toast.modelData.body; visible: text !== ""; color: Theme.foreground; opacity: 0.72; font.family: Theme.uiFont; font.pixelSize: 11; elide: Text.ElideRight; maximumLineCount: 2 }

                            RowLayout {
                                visible: toast.modelData.actions.length > 0
                                Repeater {
                                    model: toast.modelData.actions
                                    Rectangle {
                                        required property var modelData
                                        implicitWidth: actionText.implicitWidth + 16
                                        implicitHeight: 24
                                        radius: 12
                                        color: Theme.black
                                        Text { id: actionText; anchors.centerIn: parent; text: parent.modelData.text; color: Theme.primary; font.family: Theme.uiFont; font.pixelSize: 10 }
                                        MouseArea { anchors.fill: parent; onClicked: parent.modelData.invoke() }
                                    }
                                }
                            }
                        }
                    }

                    TapHandler { onTapped: toast.modelData.dismiss() }

                    Rectangle {
                        anchors { left: parent.left; bottom: parent.bottom }
                        property real remaining: 1
                        width: parent.width * remaining
                        height: 2
                        color: Theme.primary

                        NumberAnimation on remaining {
                            from: 1
                            to: 0
                            duration: Math.max(5000, toast.modelData.expireTimeout * 1000)
                        }
                    }

                    Timer {
                        interval: Math.max(5000, toast.modelData.expireTimeout * 1000)
                        running: true
                        onTriggered: toast.modelData.expire()
                    }
                }
            }
        }
    }
}
