import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.config
import qs.services

WlSessionLockSurface {
  id: root

  required property var controller
  required property bool authenticating
  required property bool failed
  required property string message

  color: Appearance.colors.base

  onFailedChanged: {
    if (root.failed)
      face.reject();
  }

  AuthFace {
    id: face

    anchors.fill: parent
    user: Quickshell.env("USER") ?? ""
    wallpaper: Config.wallpaper
    typed: root.controller.buffer.length
    busy: root.authenticating
    failed: root.failed
    message: root.message
    caption: Players.hasTrack ? (Players.artist ? Players.title + " - " + Players.artist : Players.title) : ""
  }

  Item {
    anchors.fill: parent
    focus: true
    Keys.onPressed: event => {
      root.controller.handleKey(event);
      event.accepted = true;
    }
  }
}
