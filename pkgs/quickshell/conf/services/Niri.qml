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
    property bool overviewOpen: false

    readonly property var focusedWindow: root.windows.find(w => w.is_focused) ?? null

    readonly property int focusedWindowId: root.focusedWindow?.id ?? -1

    property int lastWindowId: -1
    readonly property var barWindow: root.windows.find(w => w.id === root.lastWindowId) ?? null

    onFocusedWindowIdChanged: {
        if (root.focusedWindowId !== -1)
            root.lastWindowId = root.focusedWindowId;
    }
    readonly property int activeWorkspaceId: root.workspaces.find(w => w.is_focused)?.id ?? -1

    function workspacesFor(outputName: string): var {
        return root.workspaces.filter(w => w.output === outputName).sort((a, b) => a.idx - b.idx);
    }

    function isOccupied(workspaceId): bool {
        return root.windows.some(w => w.workspace_id === workspaceId);
    }

    function focusWorkspace(index: int): void {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(index)]);
    }

    function focusWindow(id: int): void {
        Quickshell.execDetached(["niri", "msg", "action", "focus-window", "--id", String(id)]);
    }

    function action(name: string): void {
        Quickshell.execDetached(["niri", "msg", "action", name]);
    }

    function handle(line: string): void {
        if (!line.trim())
            return;

        let event;
        try {
            event = JSON.parse(line);
        } catch (error) {
            return;
        }

        if (event.WorkspacesChanged) {
            root.workspaces = event.WorkspacesChanged.workspaces;
        } else if (event.WorkspaceActivated) {
            const activated = event.WorkspaceActivated;
            const target = root.workspaces.find(w => w.id === activated.id);
            if (!target)
                return;
            root.workspaces = root.workspaces.map(w => w.output !== target.output ? w : Object.assign({}, w, {
                        is_active: w.id === activated.id,
                        is_focused: activated.focused ? w.id === activated.id : w.is_focused
                    }));
        } else if (event.WorkspaceUrgencyChanged) {
            const urgency = event.WorkspaceUrgencyChanged;
            root.workspaces = root.workspaces.map(w => w.id !== urgency.id ? w : Object.assign({}, w, {
                        is_urgent: urgency.urgent
                    }));
        } else if (event.WorkspaceActiveWindowChanged) {
            const changed = event.WorkspaceActiveWindowChanged;
            root.workspaces = root.workspaces.map(w => w.id !== changed.workspace_id ? w : Object.assign({}, w, {
                        active_window_id: changed.active_window_id
                    }));
        } else if (event.WindowsChanged) {
            root.windows = event.WindowsChanged.windows;
        } else if (event.WindowOpenedOrChanged) {
            const window = event.WindowOpenedOrChanged.window;
            const next = root.windows.filter(w => w.id !== window.id);
            next.push(window);
            root.windows = window.is_focused ? next.map(w => Object.assign({}, w, {
                        is_focused: w.id === window.id
                    })) : next;
        } else if (event.WindowClosed) {
            root.windows = root.windows.filter(w => w.id !== event.WindowClosed.id);
        } else if (event.WindowFocusChanged) {
            const focusedId = event.WindowFocusChanged.id;
            root.windows = root.windows.map(w => Object.assign({}, w, {
                        is_focused: w.id === focusedId
                    }));
        } else if (event.KeyboardLayoutsChanged) {
            root.keyboardLayouts = event.KeyboardLayoutsChanged.keyboard_layouts.names;
            root.keyboardLayoutIndex = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx;
        } else if (event.KeyboardLayoutSwitched) {
            root.keyboardLayoutIndex = event.KeyboardLayoutSwitched.idx;
        } else if (event.OverviewOpenedOrClosed) {
            root.overviewOpen = event.OverviewOpenedOrClosed.is_open;
        }
    }

    Process {
        id: stream

        running: true
        command: ["niri", "msg", "-j", "event-stream"]

        stdout: SplitParser {
            onRead: data => root.handle(data)
        }

        onExited: restart.start()
    }

    Timer {
        id: restart

        interval: 1000
        onTriggered: stream.running = true
    }
}
