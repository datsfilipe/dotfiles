pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.state

Overlay {
  id: root

  property int selected: 0

  readonly property var actions: [
    {
      label: "lock",
      hint: "return to the lock screen",
      command: ["wlock"]
    },
    {
      label: "logout",
      hint: "quit niri",
      command: ["niri", "msg", "action", "quit", "-s"]
    },
    {
      label: "suspend",
      hint: "sleep to ram",
      command: ["systemctl", "suspend"]
    },
    {
      label: "restart",
      hint: "reboot the machine",
      command: ["systemctl", "reboot"]
    },
    {
      label: "shutdown",
      hint: "power off",
      command: ["systemctl", "poweroff"]
    }
  ]

  shown: ShellState.sessionOpen
  onDismissed: ShellState.sessionOpen = false

  onShownChanged: {
    if (root.shown)
      root.selected = 0;
  }

  function move(delta: int): void {
    root.selected = (root.selected + delta + root.actions.length) % root.actions.length;
  }

  onKeyPressed: event => {
    if (event.key === Qt.Key_Left || event.key === Qt.Key_Up)
      root.move(-1);
    else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down)
      root.move(1);
    else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
      root.trigger(root.selected);
    else
      return;
    event.accepted = true;
  }

  function trigger(index: int): void {
    const action = root.actions[index];
    if (!action)
      return;
    ShellState.sessionOpen = false;
    Quickshell.execDetached(action.command);
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: Appearance.spacing.large

    AnimatedImage {
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredWidth: 48
      Layout.preferredHeight: 48
      source: "root:/assets/gif0.gif"
      fillMode: Image.PreserveAspectFit
      smooth: false
      playing: root.shown
      opacity: root.shown ? 1 : 0

      Behavior on opacity {
        Anim {
          speed: "fast"
        }
      }
    }

    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      spacing: Appearance.spacing.normal

      Repeater {
        model: root.actions

        Card {
          id: button

          required property var modelData
          required property int index

          readonly property bool current: root.selected === button.index
          readonly property bool destructive: button.index >= 3
          readonly property color accent: button.destructive ? Appearance.colors.error : Appearance.colors.accent

          shown: root.shown
          growFrom: Item.Center
          implicitWidth: 104
          implicitHeight: 68
          color: button.current ? Appearance.colors.layer1 : Appearance.colors.panel
          border.color: button.current ? button.accent : Appearance.colors.outline

          Behavior on border.color {
            ColorAnim {}
          }

          Label {
            anchors.centerIn: parent
            text: button.modelData.label
            color: button.current ? button.accent : Appearance.colors.subtext
            font.pixelSize: Appearance.font.size.small
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: root.selected = button.index
            onClicked: root.trigger(button.index)
          }
        }
      }
    }

    StyledText {
      Layout.alignment: Qt.AlignHCenter
      text: root.actions[root.selected].hint
      color: Appearance.colors.subtext
      font.pixelSize: Appearance.font.size.normal
      opacity: root.shown ? 1 : 0

      Behavior on opacity {
        Anim {
          speed: "fast"
        }
      }
    }
  }
}
