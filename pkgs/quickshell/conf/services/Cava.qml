pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int subscribers: 0
    property var values: new Array(96).fill(0)

    readonly property bool active: root.subscribers > 0

    readonly property int miniBars: 6

    readonly property var mini: {
        const size = Math.max(1, Math.floor(root.values.length / root.miniBars));
        const out = [];
        for (let b = 0; b < root.miniBars; b++) {
            let peak = 0;
            for (let i = b * size; i < (b + 1) * size && i < root.values.length; i++)
                peak = Math.max(peak, root.values[i]);
            out.push(peak);
        }
        return out;
    }

    function subscribe(): void {
        root.subscribers++;
    }

    function unsubscribe(): void {
        root.subscribers = Math.max(0, root.subscribers - 1);
        if (root.subscribers === 0)
            root.values = new Array(96).fill(0);
    }

    Process {
        running: root.active
        command: ["cava", "-p", Quickshell.shellPath("assets/cava.conf")]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(";").filter(part => part.length > 0);
                if (parts.length > 0)
                    root.values = parts.map(part => Number(part) / 100);
            }
        }
    }
}
