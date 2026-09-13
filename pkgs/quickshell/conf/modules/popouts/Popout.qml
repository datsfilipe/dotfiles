import QtQuick
import Quickshell
import qs.components
import qs.config

Overlay {
    id: root

    property int panelWidth: Appearance.sizes.panelWidth
    property int panelHeight: 420
    property string align: "right"
    default property alias panelData: card.data

    readonly property int barOffset: Appearance.sizes.barHeight + Appearance.sizes.barMargin * 2

    dim: false
    grabsKeyboard: false

    Card {
        id: card

        shown: root.shown
        growFrom: root.align === "right" ? Item.TopRight : root.align === "left" ? Item.TopLeft : Item.Top
        implicitWidth: root.panelWidth
        implicitHeight: root.panelHeight

        anchors {
            top: parent.top
            topMargin: root.barOffset + (root.shown ? 0 : -Appearance.spacing.normal)
            right: root.align === "right" ? parent.right : undefined
            left: root.align === "left" ? parent.left : undefined
            horizontalCenter: root.align === "centre" ? parent.horizontalCenter : undefined
            rightMargin: Appearance.sizes.barSideMargin
            leftMargin: Appearance.sizes.barSideMargin
        }

        Behavior on anchors.topMargin {
            Anim {
                speed: root.shown ? "enter" : "exit"
            }
        }
    }
}
