pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.state

Popout {
  id: root

  shown: ShellState.notificationsOpen
  onDismissed: ShellState.notificationsOpen = false
  panelWidth: 400
  panelHeight: Math.min(560, layout.implicitHeight + Appearance.padding.large * 2)

  onShownChanged: {
    if (root.shown)
      scroll.contentY = 0;
  }

  Flickable {
    id: scroll

    anchors.fill: parent
    anchors.margins: Appearance.padding.large
    contentWidth: width
    contentHeight: layout.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    ColumnLayout {
      id: layout

      width: scroll.width
      spacing: Appearance.spacing.small

      RowLayout {
        Layout.fillWidth: true
        Layout.bottomMargin: Appearance.spacing.tiny
        spacing: Appearance.spacing.normal

        Label {
          Layout.fillWidth: true
          text: Notifs.count > 0 ? "notifications - " + Notifs.count : "notifications"
        }

        TextButton {
          visible: Notifs.silent
          implicitHeight: 22
          horizontalPadding: Appearance.padding.small
          text: "silenced"
          accentColor: Appearance.colors.error
          toggled: true
          onClicked: Notifs.silent = false
        }

        TextButton {
          visible: Notifs.count > 0
          implicitHeight: 22
          horizontalPadding: Appearance.padding.small
          text: "clear"
          onClicked: Notifs.clear()
        }
      }

      StyledText {
        Layout.fillWidth: true
        visible: Notifs.count === 0
        text: "nothing waiting"
        color: Appearance.colors.faint
        font.pixelSize: Appearance.font.size.small
      }

      Repeater {
        model: ScriptModel {
          values: Notifs.list
        }

        InteractiveRect {
          id: entry

          required property var modelData

          readonly property bool critical: entry.modelData.urgency === "critical"

          Layout.fillWidth: true
          implicitHeight: body.implicitHeight + Appearance.padding.small * 2
          idleColor: Appearance.colors.layer1
          border.width: Appearance.elevation.borderWidth
          border.color: entry.critical ? Appearance.colors.error : Appearance.colors.outline

          onClicked: Notifs.discard(entry.modelData)

          ColumnLayout {
            id: body

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Appearance.padding.normal
            anchors.rightMargin: Appearance.padding.normal
            spacing: 1

            RowLayout {
              Layout.fillWidth: true
              spacing: Appearance.spacing.small

              StyledText {
                Layout.fillWidth: true
                text: entry.modelData.summary
                elide: Text.ElideRight
                color: entry.critical ? Appearance.colors.error : Appearance.colors.text
                font.pixelSize: Appearance.font.size.small
              }

              Label {
                text: entry.modelData.appName
              }
            }

            StyledText {
              Layout.fillWidth: true
              visible: text !== ""
              text: entry.modelData.body
              elide: Text.ElideRight
              color: Appearance.colors.faint
              font.pixelSize: Appearance.font.size.small
            }
          }
        }
      }
    }
  }
}
