import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

PanelWindow {
    id: root

    visible: ShellState.widgetShelfVisible
    aboveWindows: true
    focusable: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }

    property var weather: null
    property real volume: 0
    property bool muted: false
    property string deviceStatus: "checking"
    property string systemInfo: ""
    property var player: Mpris.players.values.find(item => item.isPlaying) ?? Mpris.players.values[0] ?? null
    property var sinks: Pipewire.nodes.values.filter(node => !node.isStream && node.isSink && node.audio)
    property var sources: Pipewire.nodes.values.filter(node => !node.isStream && !node.isSink && node.audio)

    function close() { ShellState.widgetShelfVisible = false }
    function updateVolume() { volumeQuery.running = false; volumeQuery.running = true }
    function audio(command) { Quickshell.execDetached(["sh", "-c", command + " && wvolume-osd"]); updateTimer.restart() }
    function refreshPage() {
        if (ShellState.widgetShelfPage === "weather") {
            weatherQuery.running = false
            weatherQuery.running = true
        } else if (ShellState.widgetShelfPage === "audio") {
            root.updateVolume()
        } else if (ShellState.widgetShelfPage === "system") {
            systemQuery.running = false
            systemQuery.running = true
            tabletQuery.running = false
            tabletQuery.running = true
        }
    }

    IpcHandler {
        target: "widgets"
        function open(page: string) { ShellState.widgetShelfPage = page; ShellState.widgetShelfVisible = true }
        function close() { root.close() }
    }

    Process {
        id: weatherQuery
        command: ["curl", "-fsSL", "--max-time", "8", "https://wttr.in/Belem?format=j1"]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.weather = JSON.parse(text) } catch (error) { root.weather = null }
            }
        }
    }

    Process {
        id: systemQuery
        command: ["sh", "-c", "uptime -p; df -h / | tail -n1; ip route get 1.1.1.1 | head -n1"]
        stdout: StdioCollector { onStreamFinished: root.systemInfo = text }
    }

    Process {
        id: volumeQuery
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/([0-9.]+)/)
                root.volume = match ? Number(match[1]) : 0
                root.muted = text.includes("MUTED")
            }
        }
    }

    Process {
        id: tabletQuery
        command: ["sh", "-c", "if lsusb | grep -Eqi 'XP[- ]?Pen|UGTABLET'; then printf connected; else printf waiting; fi"]
        stdout: StdioCollector { onStreamFinished: root.deviceStatus = text.trim() }
    }

    Timer { id: updateTimer; interval: 200; onTriggered: root.updateVolume() }

    PwObjectTracker { objects: [...root.sinks, ...root.sources] }

    FileView {
        id: notesFile
        path: Quickshell.statePath("scratchpad.txt")
        blockLoading: true
        printErrors: false
    }

    Timer {
        id: notesSave
        interval: 350
        onTriggered: notesFile.setText(notesInput.text)
    }

    onVisibleChanged: {
        if (!visible)
            return
        root.refreshPage()
    }

    Connections {
        target: ShellState
        function onWidgetShelfPageChanged() {
            if (root.visible)
                root.refreshPage()
        }
    }

    MouseArea { anchors.fill: parent; onClicked: root.close() }

    Item {
        anchors.fill: parent
        focus: root.visible
        Keys.onEscapePressed: root.close()
    }

    Rectangle {
        anchors { top: parent.top; right: parent.right; topMargin: 48; rightMargin: 12 }
        width: 390
        height: 430
        radius: 22
        color: Theme.background
        border.width: 1
        border.color: Theme.alternate
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: ShellState.widgetShelfPage === "weather" ? "天気 · weather" : ShellState.widgetShelfPage === "audio" ? "音 · audio" : ShellState.widgetShelfPage === "notes" ? "記録 · scratchpad" : ShellState.widgetShelfPage === "keys" ? "鍵 · key map" : "機械 · system"
                    color: Theme.primary
                    font.family: Theme.font
                    font.pixelSize: 16
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Text { text: "Esc / outside to close"; color: Theme.foreground; opacity: 0.35; font.family: Theme.uiFont; font.pixelSize: 9 }
            }

            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: ShellState.widgetShelfPage === "weather" ? weatherPage : ShellState.widgetShelfPage === "audio" ? audioPage : ShellState.widgetShelfPage === "notes" ? notesPage : ShellState.widgetShelfPage === "keys" ? keysPage : systemPage
            }
        }
    }

    Component {
        id: weatherPage
        ColumnLayout {
            spacing: 12
            property var current: root.weather?.current_condition?.[0] ?? null
            Text { Layout.alignment: Qt.AlignHCenter; text: parent.current ? parent.current.temp_C + "°" : "…"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 64; font.bold: true }
            Text { Layout.alignment: Qt.AlignHCenter; text: parent.current?.weatherDesc?.[0]?.value ?? "loading Belém weather"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 14 }
            RowLayout {
                Layout.fillWidth: true
                Repeater {
                    model: root.weather?.weather?.slice(0, 3) ?? []
                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        height: 100
                        radius: 16
                        color: Theme.black
                        Column { anchors.centerIn: parent; spacing: 5
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: new Date(parent.parent.modelData.date).toLocaleDateString(Qt.locale(), "ddd"); color: Theme.primary; font.family: Theme.font; font.pixelSize: 12 }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.modelData.mintempC + "° / " + parent.parent.modelData.maxtempC + "°"; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 14 }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: (parent.parent.modelData.hourly?.[4]?.chanceofrain ?? "0") + "% rain"; color: Theme.foreground; opacity: 0.5; font.family: Theme.uiFont; font.pixelSize: 10 }
                        }
                    }
                }
            }
            Text { Layout.alignment: Qt.AlignHCenter; text: parent.current ? "humidity " + parent.current.humidity + "%   ·   wind " + parent.current.windspeedKmph + " km/h" : ""; color: Theme.foreground; opacity: 0.6; font.family: Theme.font; font.pixelSize: 11 }
        }
    }

    Component {
        id: audioPage
        ColumnLayout {
            spacing: 10
            Rectangle {
                Layout.fillWidth: true
                height: 92
                radius: 18
                color: Theme.black
                Column { anchors.centerIn: parent; spacing: 10
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.muted ? "消音" : Math.round(root.volume * 100) + "%"; color: root.muted ? Theme.red : Theme.primary; font.family: Theme.font; font.pixelSize: 34 }
                    Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 28
                        Text { text: "−"; color: Theme.foreground; font.pixelSize: 24; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.audio("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") } }
                        Text { text: root.muted ? "○" : "●"; color: Theme.primary; font.pixelSize: 18; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.audio("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") } }
                        Text { text: "+"; color: Theme.foreground; font.pixelSize: 24; MouseArea { anchors.fill: parent; anchors.margins: -10; onClicked: root.audio("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") } }
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text { text: "出力 · output"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 11; font.bold: true }
                    Repeater {
                        model: ScriptModel { values: root.sinks }
                        Rectangle {
                            id: sinkButton
                            required property var modelData
                            Layout.fillWidth: true
                            height: 42
                            radius: 13
                            color: Pipewire.defaultAudioSink?.id === modelData.id ? Theme.primary : Theme.black
                            border.width: 1
                            border.color: Pipewire.defaultAudioSink?.id === modelData.id ? Theme.primary : Theme.alternate
                            Text { anchors.centerIn: parent; width: parent.width - 18; text: sinkButton.modelData.description || sinkButton.modelData.nickname || sinkButton.modelData.name; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter; color: Pipewire.defaultAudioSink?.id === sinkButton.modelData.id ? Theme.black : Theme.foreground; font.family: Theme.font; font.pixelSize: 10 }
                            MouseArea { anchors.fill: parent; onClicked: Pipewire.preferredDefaultAudioSink = sinkButton.modelData }
                        }
                    }
                    Item { Layout.fillHeight: true }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text { text: "入力 · input"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 11; font.bold: true }
                    Repeater {
                        model: ScriptModel { values: root.sources }
                        Rectangle {
                            id: sourceButton
                            required property var modelData
                            Layout.fillWidth: true
                            height: 42
                            radius: 13
                            color: Pipewire.defaultAudioSource?.id === modelData.id ? Theme.primary : Theme.black
                            border.width: 1
                            border.color: Pipewire.defaultAudioSource?.id === modelData.id ? Theme.primary : Theme.alternate
                            Text { anchors.centerIn: parent; width: parent.width - 18; text: sourceButton.modelData.description || sourceButton.modelData.nickname || sourceButton.modelData.name; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter; color: Pipewire.defaultAudioSource?.id === sourceButton.modelData.id ? Theme.black : Theme.foreground; font.family: Theme.font; font.pixelSize: 10 }
                            MouseArea { anchors.fill: parent; onClicked: Pipewire.preferredDefaultAudioSource = sourceButton.modelData }
                        }
                    }
                    Item { Layout.fillHeight: true }
                }
            }
        }
    }

    Component {
        id: notesPage
        Rectangle {
            color: Theme.black
            radius: 18
            border.width: 1
            border.color: Theme.alternate

            TextArea {
                id: notesInput
                anchors.fill: parent
                anchors.margins: 12
                text: notesFile.text()
                placeholderText: "考え · ideas, commands, temporary notes…"
                color: Theme.foreground
                placeholderTextColor: Theme.selection
                selectionColor: Theme.primary
                selectedTextColor: Theme.black
                background: null
                wrapMode: TextEdit.Wrap
                font.family: Theme.font
                font.pixelSize: 12
                onTextChanged: notesSave.restart()
                Keys.onEscapePressed: root.close()
            }
        }
    }

    Component {
        id: keysPage
        ColumnLayout {
            spacing: 8
            Repeater {
                model: [
                    { key: "Mod + D", action: "アプリ · launcher" },
                    { key: "Mod + Shift + D", action: "作業室 · studio" },
                    { key: "Mod + Return", action: "端末 · terminal session" },
                    { key: "Mod + A / B", action: "browser / work browser" },
                    { key: "Alt + W", action: "色 · pick colour" },
                    { key: "Print", action: "写 · screenshot" },
                    { key: "Alt + K / I", action: "keyboard layout" },
                    { key: "Mod + Shift + Z", action: "禅 · focus mode" }
                ]
                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    height: 38
                    radius: 12
                    color: Theme.black
                    RowLayout { anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12
                        Text { text: parent.parent.modelData.key; color: Theme.primary; font.family: Theme.font; font.pixelSize: 11; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Text { text: parent.parent.modelData.action; color: Theme.foreground; opacity: 0.7; font.family: Theme.font; font.pixelSize: 10 }
                    }
                }
            }
            Item { Layout.fillHeight: true }
        }
    }

    Component {
        id: systemPage
        ColumnLayout {
            spacing: 12
            RowLayout {
                Layout.fillWidth: true
                Repeater {
                    model: [{ label: "CPU", value: ResourceUsage.cpuUsage }, { label: "RAM", value: ResourceUsage.memoryUsage }]
                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        height: 100
                        radius: 18
                        color: Theme.black
                        Column { anchors.centerIn: parent; spacing: 4
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: Math.round(parent.parent.modelData.value * 100) + "%"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 30; font.bold: true }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.modelData.label; color: Theme.foreground; opacity: 0.5; font.family: Theme.font; font.pixelSize: 11 }
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 125
                radius: 18
                color: Theme.black
                Text { anchors.fill: parent; anchors.margins: 14; text: root.systemInfo; color: Theme.foreground; opacity: 0.75; font.family: Theme.font; font.pixelSize: 11; wrapMode: Text.Wrap }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 58
                radius: 18
                color: Theme.black
                Row { anchors.centerIn: parent; spacing: 12
                    Text { text: "筆"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 18; font.bold: true }
                    Text { text: "XP-Pen  " + root.deviceStatus; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 12 }
                }
                MouseArea { anchors.fill: parent; onClicked: { tabletQuery.running = false; tabletQuery.running = true } }
            }
            Item { Layout.fillHeight: true }
        }
    }
}
