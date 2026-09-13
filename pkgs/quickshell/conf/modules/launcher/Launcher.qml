pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services
import qs.state

Overlay {
    id: root

    readonly property string query: input.text
    readonly property string mode: root.query.startsWith(">") ? "run" : root.query.startsWith("?") ? "web" : root.query.startsWith("=") ? "calc" : "apps"
    readonly property string argument: root.mode === "apps" ? root.query : root.query.slice(1).trim()

    property var results: []
    property int selected: 0

    readonly property string calculation: {
        if (root.mode !== "calc" || root.argument === "")
            return "";
        if (!/^[0-9+\-*/%.()\s]+$/.test(root.argument))
            return "not a sum";
        try {
            const value = Function("return (" + root.argument + ")")();
            return Number.isFinite(value) ? String(value) : "undefined";
        } catch (error) {
            return "incomplete";
        }
    }

    shown: ShellState.launcherOpen
    onDismissed: ShellState.launcherOpen = false

    onShownChanged: {
        if (root.shown) {
            input.text = "";
            root.refresh();
            Qt.callLater(() => input.forceActiveFocus());
        }
    }

    Connections {
        function onValuesChanged(): void {
            if (root.shown)
                root.refresh();
        }

        target: DesktopEntries.applications
    }

    function refresh(): void {
        root.results = root.mode === "apps" ? Apps.search(root.argument, root.argument === "" ? 6 : 8) : [];
        root.selected = 0;
    }

    function move(delta: int): void {
        if (root.results.length === 0)
            return;
        root.selected = (root.selected + delta + root.results.length) % root.results.length;
    }

    function submit(): void {
        if (root.mode === "run") {
            if (root.argument)
                Quickshell.execDetached([Config.terminal, "-e", "sh", "-lc", root.argument + "; exec $SHELL"]);
        } else if (root.mode === "web") {
            if (root.argument)
                Quickshell.execDetached(["xdg-open", "https://duckduckgo.com/?q=" + encodeURIComponent(root.argument)]);
        } else if (root.mode === "calc") {
            return;
        } else {
            Apps.launch(root.results[root.selected]);
        }
        ShellState.launcherOpen = false;
    }

    Card {
        id: panel

        shown: root.shown
        growFrom: Item.Top
        color: Appearance.colors.base
        width: Math.min(560, parent.width - Appearance.spacing.huge * 2)
        implicitHeight: layout.implicitHeight + Appearance.padding.normal * 2

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Math.max(90, parent.height * 0.16) + (root.shown ? 0 : -Appearance.spacing.normal)
        }

        Behavior on anchors.topMargin {
            Anim {
                speed: root.shown ? "enter" : "exit"
            }
        }

        ColumnLayout {
            id: layout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Appearance.padding.normal
            spacing: Appearance.spacing.small

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: Appearance.colors.layer1
                border.width: Appearance.elevation.borderWidth
                border.color: Appearance.colors.outlineStrong

                TextInput {
                    id: input

                    anchors.fill: parent
                    anchors.leftMargin: Appearance.padding.normal
                    anchors.rightMargin: Appearance.padding.normal
                    verticalAlignment: TextInput.AlignVCenter
                    color: Appearance.colors.text
                    selectionColor: Appearance.colors.accent
                    selectedTextColor: Appearance.colors.onAccent
                    font.family: Appearance.font.family.mono
                    font.pixelSize: Appearance.font.size.medium
                    clip: true

                    onTextChanged: root.refresh()
                    onAccepted: root.submit()
                    Keys.onEscapePressed: ShellState.launcherOpen = false
                    Keys.onUpPressed: root.move(-1)
                    Keys.onDownPressed: root.move(1)
                    Keys.onTabPressed: root.move(1)

                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: input.text === ""
                        text: "search / ? web / = calculator"
                        color: Appearance.colors.faint
                        font: input.font
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: visible ? 40 : 0
                visible: root.mode === "calc" && root.calculation !== ""
                color: Appearance.colors.layer1
                border.width: Appearance.elevation.borderWidth
                border.color: Appearance.colors.outline

                StyledText {
                    anchors.centerIn: parent
                    text: root.calculation
                    color: Appearance.colors.accent
                    font.family: Appearance.font.family.mono
                    font.pixelSize: Appearance.font.size.xlarge
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.margins: Appearance.padding.small
                visible: root.mode === "run" || root.mode === "web"
                text: root.mode === "run" ? "enter runs this in " + Config.terminal : "enter searches the web"
            }

            Repeater {
                model: root.results

                InteractiveRect {
                    id: result

                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    implicitHeight: 42
                    toggled: root.selected === result.index
                    idleColor: "transparent"
                    activeColor: Appearance.colors.layer1
                    border.width: Appearance.elevation.borderWidth
                    border.color: toggled ? Appearance.colors.outlineStrong : "transparent"

                    onClicked: {
                        root.selected = result.index;
                        root.submit();
                    }

                    onHoveredChanged: {
                        if (hovered)
                            root.selected = result.index;
                    }

                    Behavior on border.color {
                        ColorAnim {}
                    }

                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Appearance.padding.normal
                        anchors.rightMargin: Appearance.padding.normal
                        spacing: 0

                        StyledText {
                            Layout.fillWidth: true
                            text: result.modelData.name
                            elide: Text.ElideRight
                            color: result.toggled ? Appearance.colors.accent : Appearance.colors.text
                            font.pixelSize: Appearance.font.size.medium
                        }

                        StyledText {
                            Layout.fillWidth: true
                            visible: text !== ""
                            text: result.modelData.comment ?? ""
                            elide: Text.ElideRight
                            color: Appearance.colors.faint
                            font.pixelSize: Appearance.font.size.small
                        }
                    }
                }
            }
        }
    }
}
