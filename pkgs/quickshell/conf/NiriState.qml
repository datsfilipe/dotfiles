pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var workspaces: []
    property var windows: []
    property var keyboardLayouts: []
    property int keyboardLayoutIndex: 0
    property string focusedTitle: {
        const focused = windows.find(window => window.is_focused)
        return focused?.title ?? ""
    }

    function handleEvent(line) {
        if (!line.trim())
            return
        try {
            const event = JSON.parse(line)
            if (event.WorkspacesChanged)
                root.workspaces = event.WorkspacesChanged.workspaces
            else if (event.WindowsChanged)
                root.windows = event.WindowsChanged.windows
            else if (event.WindowOpenedOrChanged) {
                const changed = event.WindowOpenedOrChanged.window
                const next = root.windows.filter(window => window.id !== changed.id)
                next.push(changed)
                root.windows = next
            } else if (event.WindowClosed)
                root.windows = root.windows.filter(window => window.id !== event.WindowClosed.id)
            else if (event.WindowFocusChanged) {
                const focusedId = event.WindowFocusChanged.id
                root.windows = root.windows.map(window => Object.assign({}, window, { is_focused: window.id === focusedId }))
            } else if (event.KeyboardLayoutsChanged) {
                root.keyboardLayouts = event.KeyboardLayoutsChanged.keyboard_layouts.names
                root.keyboardLayoutIndex = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx
            } else if (event.KeyboardLayoutSwitched)
                root.keyboardLayoutIndex = event.KeyboardLayoutSwitched.idx
        } catch (error) {
        }
    }

    Process {
        id: events
        running: true
        command: ["niri", "msg", "-j", "event-stream"]
        stdout: SplitParser {
            onRead: data => root.handleEvent(data)
        }
        onExited: restartTimer.start()
    }

    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: events.running = true
    }
}
