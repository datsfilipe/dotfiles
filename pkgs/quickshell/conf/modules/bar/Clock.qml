import QtQuick
import Quickshell
import qs.components
import qs.config
import qs.state

InteractiveRect {
  id: root

  implicitWidth: row.implicitWidth + Appearance.padding.normal * 2
  implicitHeight: Appearance.sizes.barItemHeight
  toggled: ShellState.calendarOpen

  onClicked: ShellState.toggle("calendarOpen")

  SystemClock {
    id: clock

    precision: SystemClock.Minutes
  }

  Row {
    id: row

    anchors.centerIn: parent
    spacing: Appearance.spacing.small

    StyledText {
      anchors.verticalCenter: parent.verticalCenter
      text: Qt.formatDateTime(clock.date, "HH:mm")
      color: root.toggled ? Appearance.colors.accent : Appearance.colors.text
      font.family: Appearance.font.family.mono
      font.pixelSize: Appearance.font.size.medium
    }

    Item {
      anchors.verticalCenter: parent.verticalCenter
      width: root.hovered || root.toggled ? date.implicitWidth : 0
      height: date.implicitHeight
      clip: true

      Behavior on width {
        Anim {}
      }

      Label {
        id: date

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "ddd d MMM")
        color: Appearance.colors.faint
      }
    }
  }
}
