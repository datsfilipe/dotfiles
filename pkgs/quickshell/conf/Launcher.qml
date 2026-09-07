pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

PanelWindow {
    id: root

    visible: false
    aboveWindows: true
    focusable: true
    color: "#66000000"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    property var results: []
    property int selectedIndex: 0

    function score(query, value) {
        const needle = query.toLowerCase()
        const haystack = value.toLowerCase()
        const direct = haystack.indexOf(needle)
        if (direct >= 0)
            return 1000 - direct
        let cursor = 0
        let scoreValue = 0
        for (let index = 0; index < haystack.length && cursor < needle.length; index++) {
            if (haystack[index] === needle[cursor]) {
                cursor++
                scoreValue += 10 - Math.min(index, 9)
            }
        }
        return cursor === needle.length ? scoreValue : -1
    }

    function updateResults() {
        const query = search.text.trim()
        if (query === "") {
            root.results = []
            root.selectedIndex = 0
            return
        }
        const matches = []
        const applications = DesktopEntries.applications.values
        for (let index = 0; index < applications.length; index++) {
            const app = applications[index]
            const searchable = app.name + " " + (app.comment ?? "") + " " + (app.keywords ?? []).join(" ")
            const appScore = root.score(query, searchable)
            if (appScore >= 0)
                matches.push({ entry: app, score: appScore })
        }
        matches.sort((left, right) => right.score - left.score || left.entry.name.localeCompare(right.entry.name))
        root.results = matches.slice(0, 8).map(match => match.entry)
        root.selectedIndex = 0
    }

    function open() {
        root.visible = true
        search.text = ""
        root.results = []
        root.selectedIndex = 0
        Qt.callLater(() => search.forceActiveFocus())
    }

    function close() {
        root.visible = false
        search.text = ""
    }

    function launch(index) {
        const entry = root.results[index]
        if (!entry)
            return
        root.close()
        entry.execute()
    }

    IpcHandler {
        target: "launcher"

        function toggle() {
            root.visible ? root.close() : root.open()
        }

        function open() {
            root.open()
        }

        function close() {
            root.close()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Rectangle {
        id: panel

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Math.max(80, parent.height * 0.18)
        width: Math.min(540, parent.width - 32)
        height: content.implicitHeight + 24
        radius: 6
        color: Theme.background
        border.width: 4
        border.color: Theme.primary

        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            id: content

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 8

            TextInput {
                id: search

                Layout.fillWidth: true
                color: Theme.primary
                selectionColor: Theme.primary
                selectedTextColor: Theme.black
                font.family: Theme.font
                font.pixelSize: 16
                font.bold: true
                clip: true
                onTextChanged: root.updateResults()
                onAccepted: root.launch(root.selectedIndex)
                Keys.onEscapePressed: root.close()
                Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                Keys.onDownPressed: root.selectedIndex = Math.min(root.results.length - 1, root.selectedIndex + 1)

                Text {
                    visible: search.text === ""
                    text: "Search applications"
                    color: Theme.foreground
                    opacity: 0.45
                    font: search.font
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: root.results.length > 0 ? 1 : 0
                color: Theme.alternate
            }

            Repeater {
                model: root.results

                Rectangle {
                    id: result

                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    height: 42
                    radius: 4
                    color: root.selectedIndex === index ? Theme.black : "transparent"
                    border.width: root.selectedIndex === index ? 1 : 0
                    border.color: Theme.alternate

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 10

                        IconImage {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            source: Quickshell.iconPath(result.modelData.icon)
                        }

                        Text {
                            Layout.fillWidth: true
                            text: result.modelData.name
                            elide: Text.ElideRight
                            color: root.selectedIndex === result.index ? Theme.primary : Theme.foreground
                            font.family: Theme.font
                            font.pixelSize: 14
                        }

                        Text {
                            Layout.maximumWidth: 220
                            text: result.modelData.comment ?? ""
                            elide: Text.ElideRight
                            color: Theme.foreground
                            opacity: 0.55
                            font.family: Theme.font
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.selectedIndex = result.index
                        onClicked: root.launch(result.index)
                    }
                }
            }
        }
    }
}
