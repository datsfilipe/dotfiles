pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.components
import qs.config
import qs.services

Row {
    id: root

    required property string screenName

    readonly property var items: Niri.workspacesFor(root.screenName)
    readonly property int cell: 22

    spacing: 0

    Repeater {
        model: root.items

        InteractiveRect {
            id: slot

            required property var modelData

            readonly property bool active: slot.modelData.is_active
            readonly property bool occupied: Niri.isOccupied(slot.modelData.id)

            width: root.cell
            height: Appearance.sizes.barItemHeight
            idleColor: slot.active ? Appearance.colors.layer2 : "transparent"
            border.width: Appearance.elevation.borderWidth
            border.color: slot.active ? Appearance.colors.accent : Appearance.colors.outline

            onClicked: Niri.focusWorkspace(slot.modelData.idx)

            Behavior on border.color {
                ColorAnim {}
            }

            Label {
                anchors.centerIn: parent
                text: slot.modelData.name || slot.modelData.idx
                font.pixelSize: Appearance.font.size.small
                font.letterSpacing: 0
                color: slot.active ? Appearance.colors.accent : slot.modelData.is_urgent ? Appearance.colors.error : slot.occupied ? Appearance.colors.subtext : Appearance.colors.faint
            }
        }
    }
}
