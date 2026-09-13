import QtQuick
import qs.config

Text {
    id: root

    color: Appearance.colors.faint
    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    verticalAlignment: Text.AlignVCenter

    font.family: Appearance.font.family.mono
    font.pixelSize: Appearance.font.size.small
    font.capitalization: Font.AllUppercase
    font.letterSpacing: Appearance.font.labelSpacing
    font.hintingPreference: Font.PreferNoHinting

    Behavior on color {
        ColorAnim {}
    }
}
