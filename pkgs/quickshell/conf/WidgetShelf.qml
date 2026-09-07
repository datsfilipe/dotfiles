import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    visible: ShellState.widgetShelfVisible
    aboveWindows: true
    focusable: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 390
    implicitHeight: 430
    margins { top: 48; right: 12 }
    anchors { top: true; right: true }

    property date calendarDate: new Date()
    property var weather: null
    property real volume: 0
    property bool muted: false
    property string audioStatus: ""
    property string deviceStatus: "checking"
    property var player: Mpris.players.values.find(item => item.isPlaying) ?? Mpris.players.values[0] ?? null

    function close() { ShellState.widgetShelfVisible = false }
    function updateVolume() { volumeQuery.running = false; volumeQuery.running = true }
    function audio(command) { Quickshell.execDetached(["sh", "-c", command + " && wvolume-osd"]); updateTimer.restart() }
    function refreshPage() {
        if (ShellState.widgetShelfPage === "weather") {
            weatherQuery.running = false
            weatherQuery.running = true
        } else if (ShellState.widgetShelfPage === "audio") {
            root.updateVolume()
            audioDevices.running = false
            audioDevices.running = true
        } else if (ShellState.widgetShelfPage === "tools") {
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
        id: audioDevices
        command: ["sh", "-c", "wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -m1 'node.description' | cut -d '\"' -f2"]
        stdout: StdioCollector { onStreamFinished: root.audioStatus = text }
    }

    Process {
        id: tabletQuery
        command: ["sh", "-c", "if lsusb | grep -Eqi 'XP[- ]?Pen|UGTABLET'; then printf connected; else printf waiting; fi"]
        stdout: StdioCollector { onStreamFinished: root.deviceStatus = text.trim() }
    }

    Timer { id: updateTimer; interval: 200; onTriggered: { root.updateVolume(); audioDevices.running = false; audioDevices.running = true } }

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

    Rectangle {
        anchors.fill: parent
        radius: 22
        color: Theme.background
        border.width: 1
        border.color: Theme.alternate

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: ShellState.widgetShelfPage === "calendar" ? "暦 · calendar" : ShellState.widgetShelfPage === "weather" ? "天気 · weather" : ShellState.widgetShelfPage === "audio" ? "音 · audio" : "道具 · tools"
                    color: Theme.primary
                    font.family: Theme.font
                    font.pixelSize: 16
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Text { text: "×"; color: Theme.foreground; font.pixelSize: 20; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: root.close() } }
            }

            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: ShellState.widgetShelfPage === "calendar" ? calendarPage : ShellState.widgetShelfPage === "weather" ? weatherPage : ShellState.widgetShelfPage === "audio" ? audioPage : toolsPage
            }
        }
    }

    Component {
        id: calendarPage
        ColumnLayout {
            spacing: 8
            RowLayout {
                Layout.fillWidth: true
                Text { text: "‹"; color: Theme.foreground; font.pixelSize: 24; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: root.calendarDate = new Date(root.calendarDate.getFullYear(), root.calendarDate.getMonth() - 1, 1) } }
                Text { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: root.calendarDate.toLocaleDateString(Qt.locale(), "MMMM yyyy"); color: Theme.foreground; font.family: Theme.font; font.pixelSize: 18 }
                Text { text: "›"; color: Theme.foreground; font.pixelSize: 24; MouseArea { anchors.fill: parent; anchors.margins: -8; onClicked: root.calendarDate = new Date(root.calendarDate.getFullYear(), root.calendarDate.getMonth() + 1, 1) } }
            }
            DayOfWeekRow { Layout.fillWidth: true; locale: grid.locale; delegate: Text { required property var model; text: model.shortName; horizontalAlignment: Text.AlignHCenter; color: model.day === 0 || model.day === 6 ? Theme.primary : Theme.foreground; font.family: Theme.font; font.pixelSize: 11 } }
            MonthGrid {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                month: root.calendarDate.getMonth()
                year: root.calendarDate.getFullYear()
                locale: Qt.locale()
                delegate: Rectangle {
                    required property var model
                    color: model.today ? Theme.primary : "transparent"
                    radius: height / 2
                    Text { anchors.centerIn: parent; text: model.day; color: parent.model.today ? Theme.black : parent.model.month === grid.month ? Theme.foreground : Theme.selection; font.family: Theme.font; font.pixelSize: 12 }
                }
            }
            Text { Layout.alignment: Qt.AlignHCenter; text: "middle click resets to today"; color: Theme.foreground; opacity: 0.4; font.family: Theme.uiFont; font.pixelSize: 10; MouseArea { anchors.fill: parent; onClicked: root.calendarDate = new Date() } }
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
            spacing: 12
            Rectangle {
                Layout.fillWidth: true
                height: 110
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
            Text { text: "output device"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 12; font.bold: true }
            Rectangle {
                Layout.fillWidth: true
                height: 58
                radius: 16
                color: Theme.black
                Text { anchors.centerIn: parent; width: parent.width - 24; text: root.audioStatus || "default sink"; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight; color: Theme.foreground; opacity: 0.7; font.family: Theme.font; font.pixelSize: 11 }
            }
            Item { Layout.fillHeight: true }
        }
    }

    Component {
        id: toolsPage
        ColumnLayout {
            spacing: 10
            Repeater {
                model: [
                    { jp: "色", title: "pick colour", command: ["sh", "-c", "niri msg pick-color | sed -n 's/^Hex: //p' | tr -d '\\n' | wl-copy"] },
                    { jp: "写", title: "screenshot", command: ["niri", "msg", "action", "screenshot"] },
                    { jp: "鍵", title: "lock screen", command: ["swaylock"] },
                    { jp: "禅", title: "focus mode", command: ["focus-mode"] }
                ]
                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    height: 56
                    radius: 16
                    color: Theme.black
                    Row { anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 16; spacing: 14
                        Text { text: parent.parent.modelData.jp; color: Theme.primary; font.family: Theme.font; font.pixelSize: 18; font.bold: true }
                        Text { text: parent.parent.modelData.title; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 13 }
                    }
                    MouseArea { anchors.fill: parent; onClicked: { Quickshell.execDetached(parent.modelData.command); root.close() } }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 58
                radius: 16
                color: Theme.black
                Row { anchors.centerIn: parent; spacing: 12
                    Text { text: "筆"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 18; font.bold: true }
                    Text { text: "XP-Pen  " + root.deviceStatus; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 13 }
                }
            }
        }
    }
}
