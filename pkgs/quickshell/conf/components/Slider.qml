import QtQuick
import qs.config

Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 1
    property string label
    property string readout: Math.round((root.value - root.from) / (root.to - root.from) * 100) + "%"
    property color fillColor: Appearance.colors.accent
    property bool disabled: false

    signal moved(real value)

    implicitHeight: 30
    implicitWidth: 200
    opacity: root.disabled ? 0.35 : 1

    function valueAt(x: real): real {
        const ratio = Math.max(0, Math.min(1, x / track.width));
        return root.from + ratio * (root.to - root.from);
    }

    Behavior on opacity {
        Anim {
            speed: "fast"
        }
    }

    Rectangle {
        id: track

        anchors.fill: parent
        color: Appearance.colors.layer1
        border.width: Appearance.elevation.borderWidth
        border.color: mouse.containsMouse ? Appearance.colors.outlineStrong : Appearance.colors.outline

        Behavior on border.color {
            ColorAnim {}
        }

        Rectangle {
            id: fillBar

            x: Appearance.elevation.borderWidth
            y: Appearance.elevation.borderWidth
            width: Math.max(0, (track.width - Appearance.elevation.borderWidth * 2) * Math.max(0, Math.min(1, (root.value - root.from) / (root.to - root.from))))
            height: track.height - Appearance.elevation.borderWidth * 2
            color: root.fillColor
            opacity: 0.32

            Behavior on width {
                enabled: !mouse.pressed

                Anim {
                    speed: "fast"
                }
            }
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.normal
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            color: Appearance.colors.subtext
        }

        Label {
            anchors.right: parent.right
            anchors.rightMargin: Appearance.padding.normal
            anchors.verticalCenter: parent.verticalCenter
            text: root.readout
            color: Appearance.colors.text
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true
            enabled: !root.disabled
            cursorShape: Qt.PointingHandCursor

            onPressed: event => root.moved(root.valueAt(event.x))
            onPositionChanged: event => {
                if (pressed)
                    root.moved(root.valueAt(event.x));
            }
            onWheel: event => root.moved(root.value + (event.angleDelta.y > 0 ? 1 : -1) * (root.to - root.from) * 0.05)
        }
    }
}
