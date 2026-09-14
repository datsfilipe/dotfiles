pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Services.Pipewire
import qs.components
import qs.config
import qs.services
import qs.state

Popout {
  id: root

  property bool addressCopied: false

  readonly property var networkDevice: Networking.devices.values.find(device => device.connected) ?? null
  readonly property bool wired: root.networkDevice?.type === DeviceType.Wired
  readonly property var activeNetwork: root.networkDevice?.networks?.values?.find(network => network.connected) ?? null

  shown: ShellState.controlCentreOpen
  onDismissed: ShellState.controlCentreOpen = false
  panelWidth: 400
  panelHeight: Math.min(700, layout.implicitHeight + Appearance.padding.large * 2)

  onShownChanged: {
    if (root.shown) {
      root.addressCopied = false;
      scroll.contentY = 0;
    }
  }

  function copyAddress(): void {
    if (!SysInfo.networkAddress)
      return;
    Quickshell.execDetached(["sh", "-c", "printf %s " + SysInfo.networkAddress + " | wl-copy"]);
    root.addressCopied = true;
    copiedReset.restart();
  }

  Timer {
    id: copiedReset

    interval: 2000
    onTriggered: root.addressCopied = false
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
      spacing: Appearance.spacing.normal

      GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: Appearance.spacing.small
        rowSpacing: Appearance.spacing.small

        Toggle {
          Layout.fillWidth: true
          label: "microphone"
          detail: Audio.sourceMuted ? "muted" : "live"
          active: !Audio.sourceMuted
          onClicked: Audio.toggleSourceMute()
        }

        Toggle {
          Layout.fillWidth: true
          label: "notifications"
          detail: Notifs.silent ? "silenced" : "allowed"
          active: !Notifs.silent
          onClicked: Notifs.silent = !Notifs.silent
        }

        Toggle {
          Layout.fillWidth: true
          label: "wallpaper"
          detail: "pick a new one"
          active: ShellState.wallpapersOpen
          onClicked: ShellState.toggle("wallpapersOpen")
        }

        Toggle {
          Layout.fillWidth: true
          label: "auto-hide bar"
          detail: ShellState.barAutohide ? "on" : "off"
          active: ShellState.barAutohide
          onClicked: ShellState.setAutohide(!ShellState.barAutohide)
        }
      }

      Slider {
        Layout.fillWidth: true
        Layout.topMargin: Appearance.spacing.small
        label: "volume"
        readout: Audio.muted ? "muted" : Math.round(Audio.volume * 100) + "%"
        value: Audio.volume
        fillColor: Audio.muted ? Appearance.colors.layer2 : Appearance.colors.accent
        onMoved: value => Audio.setVolume(value)
      }

      Slider {
        Layout.fillWidth: true
        visible: Brightness.available
        label: "screen"
        value: Brightness.value
        fillColor: Appearance.colors.warning
        onMoved: value => Brightness.set(value)
      }

      Label {
        Layout.fillWidth: true
        Layout.topMargin: Appearance.spacing.small
        text: "output"
      }

      Repeater {
        model: ScriptModel {
          values: Audio.sinks
        }

        DeviceRow {
          required property var modelData

          Layout.fillWidth: true
          node: modelData
          current: Pipewire.defaultAudioSink?.id === modelData.id
          onClicked: Pipewire.preferredDefaultAudioSink = modelData
        }
      }

      Label {
        Layout.fillWidth: true
        Layout.topMargin: Appearance.spacing.small
        text: "input"
      }

      Repeater {
        model: ScriptModel {
          values: Audio.sources
        }

        DeviceRow {
          required property var modelData

          Layout.fillWidth: true
          node: modelData
          current: Pipewire.defaultAudioSource?.id === modelData.id
          onClicked: Pipewire.preferredDefaultAudioSource = modelData
        }
      }

      Label {
        Layout.fillWidth: true
        Layout.topMargin: Appearance.spacing.small
        text: "network"
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 2

          StyledText {
            Layout.fillWidth: true
            text: !root.networkDevice ? "offline" : root.wired ? "wired" : (root.activeNetwork?.name ?? "wi-fi")
            elide: Text.ElideRight
            color: root.networkDevice ? Appearance.colors.text : Appearance.colors.error
            font.pixelSize: Appearance.font.size.normal
          }

          StyledText {
            Layout.fillWidth: true
            text: SysInfo.networkAddress ? SysInfo.networkAddress + " on " + SysInfo.networkInterface : "no route"
            elide: Text.ElideRight
            color: Appearance.colors.faint
            font.family: Appearance.font.family.mono
            font.pixelSize: Appearance.font.size.small
          }
        }

        TextButton {
          Layout.alignment: Qt.AlignVCenter
          text: root.addressCopied ? "copied" : "copy ip"
          disabled: !SysInfo.networkAddress
          toggled: root.addressCopied
          accentColor: Appearance.colors.success
          onClicked: root.copyAddress()
        }
      }
    }
  }

  component Toggle: InteractiveRect {
    id: toggle

    property string label
    property string detail
    property bool active: false

    implicitHeight: 46
    border.width: Appearance.elevation.borderWidth
    border.color: toggle.active ? Appearance.colors.accent : Appearance.colors.outline
    idleColor: Appearance.colors.layer1

    Behavior on border.color {
      ColorAnim {}
    }

    ColumnLayout {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: Appearance.padding.normal
      anchors.rightMargin: Appearance.padding.normal
      spacing: 1

      Label {
        Layout.fillWidth: true
        text: toggle.label
        elide: Text.ElideRight
        color: toggle.active ? Appearance.colors.accent : Appearance.colors.subtext
        font.pixelSize: Appearance.font.size.small
      }

      StyledText {
        Layout.fillWidth: true
        text: toggle.detail
        elide: Text.ElideRight
        color: Appearance.colors.faint
        font.pixelSize: Appearance.font.size.tiny
      }
    }
  }

  component DeviceRow: InteractiveRect {
    id: device

    property var node
    property bool current: false

    implicitHeight: 28

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: Appearance.padding.small
      anchors.rightMargin: Appearance.padding.small
      spacing: Appearance.spacing.normal

      Label {
        text: device.current ? "[*]" : "[ ]"
        color: device.current ? Appearance.colors.accent : Appearance.colors.faint
        font.letterSpacing: 0
      }

      StyledText {
        Layout.fillWidth: true
        text: Audio.label(device.node)
        elide: Text.ElideRight
        color: device.current ? Appearance.colors.text : Appearance.colors.subtext
        font.pixelSize: Appearance.font.size.small
      }
    }
  }
}
