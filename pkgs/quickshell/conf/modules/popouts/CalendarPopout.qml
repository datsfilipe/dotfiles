pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.state

Popout {
    id: root

    property date viewed: new Date()

    readonly property int firstWeekday: Qt.locale().firstDayOfWeek
    readonly property date today: clock.date

    readonly property var cells: {
        const first = new Date(root.viewed.getFullYear(), root.viewed.getMonth(), 1);
        const lead = (first.getDay() - root.firstWeekday + 7) % 7;
        const start = new Date(first);
        start.setDate(1 - lead);

        const days = [];
        for (let i = 0; i < 42; i++) {
            const day = new Date(start);
            day.setDate(start.getDate() + i);
            days.push({
                day: day.getDate(),
                inMonth: day.getMonth() === root.viewed.getMonth(),
                today: day.toDateString() === root.today.toDateString()
            });
        }
        return days;
    }

    shown: ShellState.calendarOpen
    onDismissed: ShellState.calendarOpen = false
    align: "centre"
    panelWidth: 300
    panelHeight: layout.implicitHeight + Appearance.padding.large * 2

    onShownChanged: {
        if (root.shown)
            root.viewed = new Date();
    }

    function shift(months: int): void {
        const next = new Date(root.viewed);
        next.setDate(1);
        next.setMonth(next.getMonth() + months);
        root.viewed = next;
    }

    SystemClock {
        id: clock

        precision: SystemClock.Hours
    }

    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.normal

        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.small

            TextButton {
                implicitWidth: 24
                implicitHeight: 24
                horizontalPadding: 0
                text: "<"
                onClicked: root.shift(-1)
            }

            StyledText {
                Layout.fillWidth: true
                text: Qt.formatDate(root.viewed, "MMMM yyyy")
                horizontalAlignment: Text.AlignHCenter
                color: Appearance.colors.text
                font.pixelSize: Appearance.font.size.medium
            }

            TextButton {
                implicitWidth: 24
                implicitHeight: 24
                horizontalPadding: 0
                text: ">"
                onClicked: root.shift(1)
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 7
            columnSpacing: 0
            rowSpacing: Appearance.spacing.tiny

            Repeater {
                model: 7

                Label {
                    required property int index

                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.locale().dayName((root.firstWeekday + index) % 7, Locale.ShortFormat).replace(".", "").slice(0, 3)
                    color: Appearance.colors.faint
                }
            }

            Repeater {
                model: root.cells

                Item {
                    id: cell

                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 26

                    Rectangle {
                        anchors.centerIn: parent
                        width: 24
                        height: 22
                        visible: cell.modelData.today
                        color: "transparent"
                        border.width: Appearance.elevation.borderWidth
                        border.color: Appearance.colors.accent
                    }

                    StyledText {
                        anchors.centerIn: parent
                        text: cell.modelData.day
                        color: cell.modelData.today ? Appearance.colors.accent : cell.modelData.inMonth ? Appearance.colors.subtext : Appearance.colors.faint
                        opacity: cell.modelData.inMonth ? 1 : 0.5
                        font.family: Appearance.font.family.mono
                        font.pixelSize: Appearance.font.size.small
                    }
                }
            }
        }
    }
}
