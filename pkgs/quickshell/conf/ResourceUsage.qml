pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real memoryUsage: 0
    property real cpuUsage: 0
    property var previousCpu: null

    function refresh() {
        memoryFile.reload()
        cpuFile.reload()
        const memory = memoryFile.text()
        const total = Number(memory.match(/MemTotal:\s+(\d+)/)?.[1] ?? 1)
        const available = Number(memory.match(/MemAvailable:\s+(\d+)/)?.[1] ?? total)
        root.memoryUsage = 1 - available / total
        const match = cpuFile.text().match(/^cpu\s+(.+)$/m)
        if (!match)
            return
        const values = match[1].trim().split(/\s+/).map(Number)
        const idle = values[3] + (values[4] ?? 0)
        const totalCpu = values.reduce((sum, value) => sum + value, 0)
        if (root.previousCpu) {
            const elapsed = totalCpu - root.previousCpu.total
            root.cpuUsage = elapsed > 0 ? 1 - (idle - root.previousCpu.idle) / elapsed : 0
        }
        root.previousCpu = { idle: idle, total: totalCpu }
    }

    FileView {
        id: memoryFile
        path: "/proc/meminfo"
        blockLoading: true
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        blockLoading: true
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
