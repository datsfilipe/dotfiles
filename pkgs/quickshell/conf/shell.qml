//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.bar
import qs.modules.launcher
import qs.modules.media
import qs.modules.lock
import qs.modules.notifications
import qs.modules.osd
import qs.modules.popouts
import qs.modules.session
import qs.modules.wallpaper
import qs.services
import qs.state

ShellRoot {
  id: root

  Bar {}
  TrayMenu {}

  ControlCentre {}
  NotificationCentre {}
  MediaDock {}
  CalendarPopout {}

  Dashboard {}
  Launcher {}
  SessionMenu {}
  WallpaperPicker {}

  Notifications {}
  Osd {
    id: osd
  }

  Lock {
    id: lockScreen
  }

  Connections {
    function onFocusedWindowIdChanged(): void {
      if (!ShellState.locked)
        ShellState.closePopouts();
    }

    function onActiveWorkspaceIdChanged(): void {
      if (!ShellState.locked)
        ShellState.closeAll();
    }

    target: Niri
  }

  IpcHandler {
    target: "shell"

    function toggleBar(): string {
      ShellState.barVisible = !ShellState.barVisible;
      return ShellState.barVisible ? "visible" : "hidden";
    }

    function toggleAutohide(): string {
      ShellState.setAutohide(!ShellState.barAutohide);
      return ShellState.barAutohide ? "autohide-on" : "autohide-off";
    }

    function autohideOn(): void {
      ShellState.setAutohide(true);
    }

    function autohideOff(): void {
      ShellState.setAutohide(false);
    }
  }

  IpcHandler {
    target: "launcher"

    function toggle(): void {
      ShellState.toggle("launcherOpen");
    }

    function open(): void {
      ShellState.closeAll();
      ShellState.launcherOpen = true;
    }

    function close(): void {
      ShellState.launcherOpen = false;
    }
  }

  IpcHandler {
    target: "dashboard"

    function toggle(): void {
      ShellState.toggle("dashboardOpen");
    }
  }

  IpcHandler {
    target: "session"

    function toggle(): void {
      ShellState.toggle("sessionOpen");
    }
  }

  IpcHandler {
    target: "control"

    function toggle(): void {
      ShellState.toggle("controlCentreOpen");
    }
  }

  IpcHandler {
    target: "media"

    function toggle(): void {
      ShellState.mediaOpen = !ShellState.mediaOpen;
    }
  }

  IpcHandler {
    target: "notifications"

    function toggle(): void {
      ShellState.toggle("notificationsOpen");
    }
  }

  IpcHandler {
    target: "wallpapers"

    function toggle(): void {
      ShellState.toggle("wallpapersOpen");
    }
  }

  IpcHandler {
    target: "osd"

    function volume(): void {
      osd.show("volume");
    }

    function brightness(): void {
      osd.show("brightness");
    }
  }

  IpcHandler {
    target: "lock"

    function lock(): void {
      lockScreen.locked = true;
    }

    function isLocked(): bool {
      return lockScreen.locked;
    }
  }
}
