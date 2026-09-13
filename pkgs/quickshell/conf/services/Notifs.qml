pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.config

Singleton {
    id: root

    property bool silent: false
    property var list: []

    readonly property int count: root.list.length
    readonly property var popups: root.list.filter(n => n.popup)

    function discard(wrapper): void {
        root.list = root.list.filter(n => n !== wrapper);
        wrapper.notification.dismiss();
    }

    function dismissPopup(wrapper): void {
        wrapper.popup = false;
        root.list = root.list.slice();
    }

    function clear(): void {
        const previous = root.list;
        root.list = [];
        for (const wrapper of previous)
            wrapper.notification.dismiss();
    }

    function urgencyName(urgency): string {
        if (urgency === NotificationUrgency.Critical)
            return "critical";
        if (urgency === NotificationUrgency.Low)
            return "low";
        return "normal";
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true;

            const wrapper = wrapperComponent.createObject(root, {
                notification: notification,
                popup: !root.silent
            });

            const next = root.list.slice();
            next.unshift(wrapper);
            root.list = next;
        }
    }

    Component {
        id: wrapperComponent

        QtObject {
            id: wrapper

            required property Notification notification
            property bool popup: true

            readonly property string summary: wrapper.notification.summary
            readonly property string body: wrapper.notification.body
            readonly property string appName: wrapper.notification.appName
            readonly property string image: wrapper.notification.image
            readonly property string appIcon: wrapper.notification.appIcon
            readonly property var actions: wrapper.notification.actions
            readonly property string urgency: root.urgencyName(wrapper.notification.urgency)
            readonly property date time: new Date()

            readonly property Timer timer: Timer {
                interval: wrapper.notification.expireTimeout > 0 ? wrapper.notification.expireTimeout : Config.notificationTimeout
                running: wrapper.popup && wrapper.urgency !== "critical"
                onTriggered: root.dismissPopup(wrapper)
            }

            readonly property Connections closed: Connections {
                function onClosed(): void {
                    root.list = root.list.filter(n => n !== wrapper);
                    wrapper.destroy();
                }

                target: wrapper.notification
            }
        }
    }
}
