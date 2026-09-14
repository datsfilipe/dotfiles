import QtQuick
import qs.components
import qs.config
import qs.services

InteractiveRect {
  id: root

  readonly property string title: Niri.barWindow?.title ?? ""

  implicitHeight: Appearance.sizes.barItemHeight

  onClicked: Niri.action("toggle-overview")

  StyledText {
    anchors.fill: parent
    anchors.leftMargin: Appearance.padding.small
    anchors.rightMargin: Appearance.padding.small
    text: root.title
    elide: Text.ElideRight
    color: Appearance.colors.subtext
    font.pixelSize: Appearance.font.size.normal
  }
}
