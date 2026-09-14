import QtQuick
import qs.config

Rectangle {
  id: root

  property bool shown: true
  property bool outlined: true
  property bool elevated: true
  property int growFrom: Item.Center

  color: Appearance.colors.panel
  radius: Appearance.rounding.normal
  border.width: root.outlined ? Appearance.elevation.borderWidth : 0
  border.color: Appearance.colors.outline

  transformOrigin: root.growFrom
  scale: root.shown ? 1 : 0.96
  opacity: root.shown ? 1 : 0

  Rectangle {
    z: -1
    x: Appearance.elevation.offset
    y: Appearance.elevation.offset
    width: parent.width
    height: parent.height
    visible: root.elevated
    color: Appearance.colors.shadow
  }

  Behavior on scale {
    Anim {
      speed: root.shown ? "enter" : "exit"
    }
  }

  Behavior on opacity {
    Anim {
      speed: root.shown ? "enter" : "exit"
    }
  }
}
