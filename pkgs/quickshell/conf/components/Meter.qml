import QtQuick
import qs.config

Item {
    id: root

    property string label
    property string detail
    property string readout
    property real value: 0
    property color fillColor: Appearance.colors.accent
    property int labelWidth: 68
    property int detailWidth: 100
    property int readoutWidth: 44

    implicitHeight: 16

    Label {
        id: name

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: root.labelWidth
        text: root.label
        color: Appearance.colors.subtext
    }

    Label {
        id: amount

        anchors.left: name.right
        anchors.verticalCenter: parent.verticalCenter
        width: root.detailWidth
        text: root.detail
        elide: Text.ElideRight
        color: Appearance.colors.faint
        font.letterSpacing: 0
    }

    Rectangle {
        id: track

        anchors.left: amount.right
        anchors.leftMargin: Appearance.spacing.normal
        anchors.right: readoutLabel.left
        anchors.rightMargin: Appearance.spacing.normal
        anchors.verticalCenter: parent.verticalCenter
        height: 10
        color: Appearance.colors.layer1
        border.width: Appearance.elevation.borderWidth
        border.color: Appearance.colors.outline

        Rectangle {
            x: Appearance.elevation.borderWidth
            y: Appearance.elevation.borderWidth
            width: Math.max(0, (track.width - Appearance.elevation.borderWidth * 2) * Math.max(0, Math.min(1, root.value)))
            height: track.height - Appearance.elevation.borderWidth * 2
            color: root.fillColor

            Behavior on width {
                Anim {
                    speed: "slow"
                }
            }
        }
    }

    Label {
        id: readoutLabel

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: root.readoutWidth
        horizontalAlignment: Text.AlignRight
        text: root.readout
        color: Appearance.colors.faint
    }
}
