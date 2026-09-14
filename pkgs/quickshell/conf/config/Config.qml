pragma Singleton

import QtQuick
import Quickshell

Singleton {
  readonly property string terminal: "@terminal@"
  readonly property string browser: "@browser@"
  readonly property string wallpaperDir: "@wallpaperDir@"
  readonly property string wallpaper: "@wallpaper@"

  readonly property string greeterUser: Quickshell.env("DATS_GREET_USER") ?? ""
  readonly property var greeterSession: [Quickshell.env("DATS_GREET_SESSION") ?? ""]

  readonly property var keyboardLayouts: [
    {
      short: "altgr",
      label: "US AltGr"
    },
    {
      short: "intl",
      label: "US Intl"
    }
  ]

  readonly property int notificationTimeout: 6000
  readonly property int maxNotifications: 6
  readonly property real volumeStep: 0.05
  readonly property var mprisProxies: ["playerctld"]
}
