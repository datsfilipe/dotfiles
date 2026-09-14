import QtQuick
import qs.config

InteractiveRect {
  id: root

  property string text
  property color accentColor: Appearance.colors.accent
  property color textColor: root.toggled ? root.accentColor : Appearance.colors.subtext
  property int fontSize: Appearance.font.size.small
  property bool bordered: true
  property int horizontalPadding: Appearance.padding.normal

  implicitWidth: label.implicitWidth + root.horizontalPadding * 2
  implicitHeight: Appearance.sizes.hitArea
  border.width: root.bordered ? Appearance.elevation.borderWidth : 0
  border.color: root.toggled ? root.accentColor : Appearance.colors.outline
  activeColor: "transparent"

  Behavior on border.color {
    ColorAnim {}
  }

  Label {
    id: label

    anchors.centerIn: parent
    text: root.text
    color: root.textColor
    font.pixelSize: root.fontSize
  }
}
