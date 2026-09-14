import QtQuick
import qs.config

Text {
  id: root

  color: Appearance.colors.text
  renderType: Text.NativeRendering
  textFormat: Text.PlainText
  verticalAlignment: Text.AlignVCenter

  font.family: Appearance.font.family.sans
  font.pixelSize: Appearance.font.size.normal
  font.hintingPreference: Font.PreferNoHinting

  Behavior on color {
    ColorAnim {}
  }
}
