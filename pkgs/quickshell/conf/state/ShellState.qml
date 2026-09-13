pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property bool barVisible: true
    property bool barAutohide: false

    property bool launcherOpen: false
    property bool dashboardOpen: false
    property bool sessionOpen: false
    property bool wallpapersOpen: false
    property bool controlCentreOpen: false
    property bool notificationsOpen: false
    property bool mediaOpen: false
    property bool calendarOpen: false
    property bool locked: false

    readonly property bool anyOpen: root.launcherOpen || root.dashboardOpen || root.sessionOpen || root.wallpapersOpen || root.controlCentreOpen || root.notificationsOpen || root.calendarOpen

    function closePopouts(): void {
        root.controlCentreOpen = false;
        root.notificationsOpen = false;
        root.calendarOpen = false;
    }

    function closeAll(): void {
        root.launcherOpen = false;
        root.dashboardOpen = false;
        root.sessionOpen = false;
        root.wallpapersOpen = false;
        root.controlCentreOpen = false;
        root.notificationsOpen = false;
        root.calendarOpen = false;
    }

    function toggle(name: string): void {
        const wasOpen = root[name];
        root.closeAll();
        root[name] = !wasOpen;
    }

    function setAutohide(enabled: bool): void {
        root.barAutohide = enabled;
        root.barVisible = !enabled;
    }
}
