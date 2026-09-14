import QtQuick
import qs.config

Rectangle {
  id: root

  property bool toggled: false
  property bool disabled: false
  property alias hovered: mouse.containsMouse
  property alias pressed: mouse.pressed
  property alias acceptedButtons: mouse.acceptedButtons
  property color idleColor: "transparent"
  property color activeColor: Appearance.colors.layer2

  signal clicked(var event)
  signal rightClicked(var event)
  signal wheel(var event)

  radius: Appearance.rounding.normal
  color: root.toggled ? root.activeColor : root.idleColor
  opacity: root.disabled ? 0.35 : 1

  Behavior on color {
    ColorAnim {}
  }

  Behavior on opacity {
    Anim {
      speed: "fast"
    }
  }

  Rectangle {
    anchors.fill: parent
    radius: parent.radius
    color: mouse.pressed ? Appearance.colors.press : mouse.containsMouse ? Appearance.colors.hover : "transparent"

    Behavior on color {
      ColorAnim {}
    }
  }

  MouseArea {
    id: mouse

    anchors.fill: parent
    hoverEnabled: true
    enabled: !root.disabled
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton

    onClicked: event => {
      if (event.button === Qt.RightButton)
        root.rightClicked(event);
      else
        root.clicked(event);
    }
    onWheel: event => root.wheel(event)
  }
}
