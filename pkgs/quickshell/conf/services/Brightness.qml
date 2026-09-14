pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property real value: 1
  property bool available: false

  function refresh(): void {
    query.running = false;
    query.running = true;
  }

  function set(target: real): void {
    const clamped = Math.max(0.01, Math.min(1, target));
    root.value = clamped;
    Quickshell.execDetached(["brightnessctl", "-c", "backlight", "set", Math.round(clamped * 100) + "%"]);
  }

  function step(direction: int): void {
    root.set(root.value + direction * 0.05);
  }

  Process {
    id: query

    running: true
    command: ["sh", "-c", "brightnessctl -m -c backlight 2>/dev/null | head -1"]

    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.trim().split(",");
        if (parts.length < 5) {
          root.available = false;
          return;
        }
        const current = Number(parts[2]);
        const max = Number(parts[4]);
        root.available = max > 0;
        if (max > 0)
          root.value = current / max;
      }
    }
  }

  Timer {
    interval: 10000
    repeat: true
    running: root.available
    onTriggered: root.refresh()
  }
}
