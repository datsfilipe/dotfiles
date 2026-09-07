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
    property var usage: ({})
    property int selectedIndex: 0
    property string mode: search.text.startsWith(">") ? "端末" : search.text.startsWith("?") ? "ウェブ" : "アプリ"

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
        if (query.startsWith(">") || query.startsWith("?")) {
            root.results = []
            root.selectedIndex = 0
            return
        }
        const matches = []
        const applications = DesktopEntries.applications.values
        for (let index = 0; index < applications.length; index++) {
            const app = applications[index]
            const searchable = app.name + " " + (app.comment ?? "") + " " + (app.keywords ?? []).join(" ")
            const appScore = query === "" ? (root.usage[app.id] ?? 0) : root.score(query, searchable)
            if (appScore >= 0)
                matches.push({ entry: app, score: appScore })
        }
        matches.sort((left, right) => right.score - left.score || left.entry.name.localeCompare(right.entry.name))
        root.results = matches.slice(0, query === "" ? 6 : 8).map(match => match.entry)
        root.selectedIndex = 0
    }

    function open() {
        root.visible = true
        search.text = ""
        root.updateResults()
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
        root.usage[entry.id] = (root.usage[entry.id] ?? 0) + 1
        usageFile.setText(JSON.stringify(root.usage))
        root.close()
        entry.execute()
    }

    function submit() {
        const query = search.text.trim()
        if (query.startsWith(">")) {
            const command = query.slice(1).trim()
            if (command)
                Quickshell.execDetached(["alacritty", "-e", "sh", "-lc", command + "; exec $SHELL"])
            root.close()
        } else if (query.startsWith("?")) {
            const terms = query.slice(1).trim()
            if (terms)
                Quickshell.execDetached(["xdg-open", "https://www.google.com/search?q=" + encodeURIComponent(terms)])
            root.close()
        } else {
            root.launch(root.selectedIndex)
        }
    }

    FileView {
        id: usageFile
        path: Quickshell.statePath("launcher-usage.json")
        blockLoading: true
        printErrors: false
        onLoaded: {
            try {
                root.usage = JSON.parse(text())
            } catch (error) {
                root.usage = ({})
            }
            root.updateResults()
        }
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
        width: Math.min(680, parent.width - 32)
        height: content.implicitHeight + 24
        radius: 22
        color: Theme.background
        border.width: 1
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

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: root.mode
                    color: Theme.primary
                    font.family: Theme.font
                    font.pixelSize: 13
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: search.text === "" ? "よく使う" : "> 端末   ? ウェブ"
                    color: Theme.foreground
                    opacity: 0.45
                    font.family: Theme.uiFont
                    font.pixelSize: 11
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                radius: 15
                color: Theme.black
                border.width: search.activeFocus ? 2 : 1
                border.color: search.activeFocus ? Theme.primary : Theme.alternate

                TextInput {
                    id: search

                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    verticalAlignment: TextInput.AlignVCenter
                    color: Theme.primary
                    selectionColor: Theme.primary
                    selectedTextColor: Theme.black
                    font.family: Theme.font
                    font.pixelSize: 16
                    font.bold: true
                    clip: true
                    onTextChanged: root.updateResults()
                    onAccepted: root.submit()
                    Keys.onEscapePressed: root.close()
                    Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                    Keys.onDownPressed: root.selectedIndex = Math.min(root.results.length - 1, root.selectedIndex + 1)

                    Text {
                        visible: search.text === ""
                        text: "検索 — apps, commands, web"
                        color: Theme.foreground
                        opacity: 0.45
                        font: search.font
                        anchors.verticalCenter: parent.verticalCenter
                    }
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
                    height: 48
                    radius: 13
                    color: root.selectedIndex === index ? Theme.black : "transparent"
                    border.width: root.selectedIndex === index ? 2 : 0
                    border.color: Theme.alternate

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 10

                        Text {
                            Layout.preferredWidth: 24
                            text: result.index === root.selectedIndex ? "●" : "○"
                            color: root.selectedIndex === result.index ? Theme.primary : Theme.selection
                            font.family: Theme.font
                            font.pixelSize: 17
                            horizontalAlignment: Text.AlignHCenter
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
