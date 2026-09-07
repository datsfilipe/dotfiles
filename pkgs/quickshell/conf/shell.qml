//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root

    property bool barVisible: true
    property bool barAutohide: false

    function setAutohide(enabled) {
        root.barAutohide = enabled
        root.barVisible = !enabled
    }

    IpcHandler {
        target: "shell"

        function toggleBar(): string {
            root.barVisible = !root.barVisible
            return root.barVisible ? "visible" : "hidden"
        }

        function toggleAutohide(): string {
            root.setAutohide(!root.barAutohide)
            return root.barAutohide ? "autohide-on" : "autohide-off"
        }

        function autohideOn() {
            root.setAutohide(true)
        }

        function autohideOff() {
            root.setAutohide(false)
        }
    }

    Bar {
        visibleState: root.barVisible
    }

    Dashboard {}
    WidgetShelf {}
    Launcher {}
    PowerMenu {}
    BrightnessOsd {}
    VolumeOsd {}
    Notifications {}
}
