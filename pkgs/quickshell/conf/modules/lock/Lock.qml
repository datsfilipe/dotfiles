pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.state

Scope {
  id: root

  property alias locked: lock.locked

  property string buffer: ""
  property string message: ""
  property bool failed: false

  function submit(): void {
    if (pam.active || root.buffer === "")
      return;
    root.message = "";
    pam.start();
  }

  function handleKey(event): void {
    if (pam.active)
      return;

    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
      root.submit();
    } else if (event.key === Qt.Key_Backspace) {
      root.buffer = event.modifiers & Qt.ControlModifier ? "" : root.buffer.slice(0, -1);
    } else if (event.key === Qt.Key_Escape) {
      root.buffer = "";
    } else if (/^[^\x00-\x1F\x7F-\x9F]+$/.test(event.text)) {
      root.buffer += event.text;
    }

    if (root.failed && root.buffer.length > 0)
      root.failed = false;
  }

  WlSessionLock {
    id: lock

    onLockedChanged: {
      ShellState.locked = lock.locked;
      if (lock.locked) {
        root.buffer = "";
        root.message = "";
        root.failed = false;
      }
    }

    LockSurface {
      controller: root
      authenticating: pam.active
      failed: root.failed
      message: root.message
    }
  }

  PamContext {
    id: pam

    config: "dats-lock"
    configDirectory: "/etc/pam.d"

    onResponseRequiredChanged: {
      if (!pam.responseRequired)
        return;
      pam.respond(root.buffer);
      root.buffer = "";
    }

    onCompleted: result => {
      if (result === PamResult.Success) {
        lock.locked = false;
        return;
      }

      root.buffer = "";
      root.failed = true;
      root.message = result === PamResult.MaxTries ? "Too many attempts" : result === PamResult.Error ? "Authentication error" : "Wrong password";
      reset.restart();
    }
  }

  Timer {
    id: reset

    interval: 4000
    onTriggered: {
      root.failed = false;
      root.message = "";
    }
  }
}
