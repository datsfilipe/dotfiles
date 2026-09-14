pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.config
import qs.services

PanelWindow {
  id: root

  visible: Notifs.popups.length > 0
  color: "transparent"
  aboveWindows: true
  focusable: false
  exclusionMode: ExclusionMode.Ignore
  implicitWidth: 400
  implicitHeight: Math.max(1, stack.implicitHeight + Appearance.spacing.normal)

  anchors {
    top: true
    right: true
  }

  margins {
    top: Appearance.sizes.barHeight + Appearance.sizes.barMargin * 2
    right: Appearance.sizes.barSideMargin
  }

  mask: Region {
    item: stack
  }

  ColumnLayout {
    id: stack

    anchors.right: parent.right
    anchors.top: parent.top
    width: parent.width
    spacing: Appearance.spacing.normal

    Repeater {
      model: ScriptModel {
        values: Notifs.popups.slice(0, Config.maxNotifications)
      }

      Toast {
        required property var modelData

        Layout.fillWidth: true
        wrapper: modelData
      }
    }
  }
}
