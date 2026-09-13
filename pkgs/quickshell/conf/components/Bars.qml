import QtQuick
import qs.config

Item {
    id: root

    property var values: []
    property color barColor: Appearance.colors.accent
    property int gap: 3

    readonly property int count: root.values.length

    implicitHeight: 40
    clip: true

    Row {
        anchors.fill: parent
        spacing: root.gap

        Repeater {
            model: root.count

            Item {
                id: slot

                required property int index

                readonly property real level: Math.max(0, Math.min(1, root.values[slot.index] ?? 0))

                width: Math.max(1, (root.width - root.gap * (root.count - 1)) / root.count)
                height: root.height

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: Math.max(2, parent.height * slot.level)
                    color: root.barColor
                    opacity: 0.3 + slot.level * 0.7

                    Behavior on height {
                        Anim {
                            speed: "fast"
                        }
                    }
                }
            }
        }
    }
}
