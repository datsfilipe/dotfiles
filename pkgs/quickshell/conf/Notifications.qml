pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    ListModel {
        id: notifications
    }

    NotificationServer {
        bodySupported: true
        imageSupported: true
        actionsSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true
            notifications.insert(0, {
                appName: notification.appName || "Notification",
                summary: notification.summary || "",
                body: notification.body || "",
                notificationId: notification.id
            })
            while (notifications.count > 4)
                notifications.remove(notifications.count - 1)
        }
    }

    PanelWindow {
        screen: Quickshell.screens[0]
        anchors.top: true
        anchors.right: true
        margins.top: 48
        margins.right: 10
        implicitWidth: 340
        implicitHeight: stack.implicitHeight
        color: "transparent"
        exclusiveZone: 0
        visible: notifications.count > 0

        Column {
            id: stack

            width: 340
            spacing: 8

            Repeater {
                model: notifications

                Rectangle {
                    id: toast

                    required property string appName
                    required property string summary
                    required property string body
                    required property int index
                    width: 340
                    height: Math.max(86, notificationContent.implicitHeight + 22)
                    radius: 6
                    color: Theme.background
                    border.width: 3
                    border.color: Theme.primary

                    ColumnLayout {
                        id: notificationContent

                        anchors {
                            fill: parent
                            margins: 11
                        }
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                Layout.fillWidth: true
                                text: toast.appName
                                color: Theme.foreground
                                opacity: 0.65
                                font.family: Theme.uiFont
                                font.pixelSize: 11
                            }

                            Text {
                                text: "×"
                                color: Theme.foreground
                                font.pixelSize: 15

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: notifications.remove(toast.index)
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: toast.summary
                            color: Theme.foreground
                            font.family: Theme.uiFont
                            font.bold: true
                            font.pixelSize: 14
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            text: toast.body
                            visible: text !== ""
                            color: Theme.foreground
                            opacity: 0.8
                            font.family: Theme.uiFont
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    Timer {
                        interval: 5000
                        running: true
                        onTriggered: {
                            if (toast.index >= 0 && toast.index < notifications.count)
                                notifications.remove(toast.index)
                        }
                    }
                }
            }
        }
    }
}
