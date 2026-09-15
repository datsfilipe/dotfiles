import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Services.UPower
import qs.components
import qs.config
import qs.services
import qs.state

InteractiveRect {
  id: root

  readonly property var networkDevice: Networking.devices.values.find(device => device.connected) ?? null
  readonly property bool wired: root.networkDevice?.type === DeviceType.Wired
  readonly property bool battery: UPower.displayDevice?.isLaptopBattery ?? false
  readonly property real batteryLevel: UPower.displayDevice?.percentage ?? 1
  readonly property bool charging: UPower.displayDevice?.state === UPowerDeviceState.Charging

  readonly property var parts: {
    const parts = [];

    if (Niri.keyboardLayoutIndex !== 0)
      parts.push({
        text: Config.keyboardLayouts[Niri.keyboardLayoutIndex]?.short ?? "",
        tone: "accent"
      });

    if (Audio.sourceMuted)
      parts.push({
        text: "mic off",
        tone: "error"
      });

    parts.push({
      text: Audio.muted ? "muted" : Math.round(Audio.volume * 100) + "%",
      tone: Audio.muted ? "error" : "subtext"
    });

    parts.push({
      text: !root.networkDevice ? "offline" : root.wired ? "eth" : "wifi",
      tone: root.networkDevice ? "subtext" : "error"
    });

    if (root.battery)
      parts.push({
        text: (root.charging ? "+" : "") + Math.round(root.batteryLevel * 100) + "%",
        tone: root.batteryLevel <= 0.15 && !root.charging ? "error" : "subtext"
      });

    return parts;
  }

  function tone(name: string): color {
    if (name === "accent")
      return Appearance.colors.accent;
    if (name === "error")
      return Appearance.colors.error;
    if (name === "faint")
      return Appearance.colors.faint;
    return Appearance.colors.subtext;
  }

  implicitWidth: row.implicitWidth + Appearance.padding.normal * 2
  implicitHeight: Appearance.sizes.barItemHeight
  toggled: ShellState.controlCentreOpen
  border.width: Appearance.elevation.borderWidth
  border.color: root.toggled ? Appearance.colors.accent : Appearance.colors.outline

  onClicked: ShellState.toggle("controlCentreOpen")
  wheelEnabled: true
  onWheel: event => Audio.step(event.angleDelta.y > 0 ? 1 : -1)

  Behavior on border.color {
    ColorAnim {}
  }

  Behavior on implicitWidth {
    Anim {
      speed: "fast"
    }
  }

  Row {
    id: row

    anchors.centerIn: parent
    spacing: Appearance.spacing.small

    Repeater {
      model: root.parts

      Row {
        id: part

        required property var modelData
        required property int index

        spacing: Appearance.spacing.small

        Label {
          anchors.verticalCenter: parent.verticalCenter
          visible: part.index > 0
          text: "|"
          color: Appearance.colors.outlineStrong
          font.letterSpacing: 0
        }

        Label {
          anchors.verticalCenter: parent.verticalCenter
          text: part.modelData.text
          color: root.tone(part.modelData.tone)
        }
      }
    }
  }
}
