import QtQuick
import QtQuick.Layouts
import qs.components
import qs.config
import qs.services
import qs.state

InteractiveRect {
    id: root

    readonly property bool present: Players.hasActive && Players.title !== ""

    implicitWidth: Math.min(row.implicitWidth + Appearance.padding.normal * 2, 260)
    implicitHeight: Appearance.sizes.barItemHeight
    clip: true
    toggled: ShellState.mediaOpen

    onClicked: ShellState.mediaOpen = !ShellState.mediaOpen
    onWheel: event => event.angleDelta.y > 0 ? Players.next() : Players.previous()

    onPresentChanged: {
        if (root.present)
            Cava.subscribe();
        else
            Cava.unsubscribe();
    }

    Component.onDestruction: {
        if (root.present)
            Cava.unsubscribe();
    }

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: Appearance.padding.normal
        anchors.rightMargin: Appearance.padding.normal
        spacing: Appearance.spacing.small

        // Its own target inside the container: transport here, panel elsewhere.
        InteractiveRect {
            Layout.preferredWidth: 22
            Layout.preferredHeight: parent.height - 4
            Layout.alignment: Qt.AlignVCenter

            onClicked: Players.toggle()

            Label {
                anchors.centerIn: parent
                text: Players.playing ? "||" : "|>"
                color: Appearance.colors.accent
                font.letterSpacing: 0
            }
        }

        StyledText {
            Layout.fillWidth: true
            text: Players.title
            elide: Text.ElideRight
            color: root.toggled ? Appearance.colors.accent : Appearance.colors.subtext
            font.pixelSize: Appearance.font.size.normal
        }

        Bars {
            Layout.preferredWidth: 38
            Layout.preferredHeight: 12
            Layout.alignment: Qt.AlignVCenter
            visible: Players.playing
            values: Cava.mini
            gap: 3
            barColor: Appearance.colors.accent
        }
    }
}
