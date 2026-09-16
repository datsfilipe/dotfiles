import QtQuick
import qs.components
import qs.config
import qs.services
import qs.state

InteractiveRect {
  id: root

  implicitWidth: row.implicitWidth + Appearance.padding.normal * 2
  implicitHeight: Appearance.sizes.barItemHeight
  toggled: ShellState.dashboardOpen
  border.width: Appearance.elevation.borderWidth
  border.color: root.toggled ? Appearance.colors.accent : Appearance.colors.outline

  onClicked: ShellState.toggle("dashboardOpen")

  Behavior on border.color {
    ColorAnim {}
  }

  Row {
    id: row

    anchors.centerIn: parent
    spacing: Appearance.spacing.small

    Label {
      anchors.verticalCenter: parent.verticalCenter
      text: "sys"
      color: root.toggled ? Appearance.colors.accent : Appearance.colors.faint
    }

    Row {
      anchors.verticalCenter: parent.verticalCenter
      spacing: 3

      Column_ {
        level: SysInfo.cpu
        tint: Appearance.colors.accent
      }

      Column_ {
        level: SysInfo.memory
        tint: Appearance.colors.info
      }

      Column_ {
        level: SysInfo.diskUsed
        tint: Appearance.colors.success
      }
    }

    Label {
      anchors.verticalCenter: parent.verticalCenter
      visible: SysInfo.cpuTemp > 0
      text: SysInfo.degrees(SysInfo.cpuTemp)
      color: SysInfo.cpuTemp >= 85 ? Appearance.colors.error : Appearance.colors.faint
    }
  }

  component Column_: Rectangle {
    id: column

    required property real level
    required property color tint

    width: 5
    height: 14
    color: Appearance.colors.layer1

    Rectangle {
      width: parent.width
      height: Math.max(1, parent.height * Math.max(0, Math.min(1, column.level)))
      y: parent.height - height
      color: column.level > 0.85 ? Appearance.colors.error : column.tint

      Behavior on height {
        Anim {
          speed: "slow"
        }
      }
    }
  }
}
