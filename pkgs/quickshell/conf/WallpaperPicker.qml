import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    visible: ShellState.wallpaperPickerVisible
    aboveWindows: true
    focusable: true
    color: "#99000000"
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }

    property string selectedPath: ""
    property bool previewing: false

    onVisibleChanged: if (visible) Quickshell.execDetached(["wwallpaper-thumbnails"])

    function close() {
        if (previewing)
            Quickshell.execDetached(["wwallpaper-restore"])
        previewing = false
        ShellState.wallpaperPickerVisible = false
    }

    function preview(path) {
        selectedPath = path
        previewing = true
        Quickshell.execDetached(["wwallpaper-preview", path])
    }

    IpcHandler {
        target: "wallpapers"
        function toggle() { ShellState.wallpaperPickerVisible ? root.close() : ShellState.wallpaperPickerVisible = true }
    }

    MouseArea { anchors.fill: parent; onClicked: root.close() }

    Item {
        anchors.fill: parent
        focus: root.visible
        Keys.onEscapePressed: root.close()
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(1120, parent.width - 80)
        height: Math.min(760, parent.height - 100)
        radius: 28
        color: Theme.background
        border.width: 1
        border.color: Theme.alternate
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text { text: "壁紙 · wallpaper gallery"; color: Theme.primary; font.family: Theme.font; font.pixelSize: 22; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: root.previewing ? "previewing — Esc restores" : wallpapers.count + " images"; color: Theme.foreground; opacity: 0.5; font.family: Theme.font; font.pixelSize: 11 }
            }

            GridView {
                id: gallery
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                cellWidth: 210
                cellHeight: 140
                model: FolderListModel {
                    id: wallpapers
                    folder: "file:///home/dtsf/.cache/dats-quickshell/wallpapers"
                    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
                    showDirs: false
                    sortField: FolderListModel.Name
                }

                delegate: Item {
                    id: tile
                    required property string fileUrl
                    required property string fileName
                    property string path: "/home/dtsf/gdrive/walls/" + fileName
                    width: gallery.cellWidth
                    height: gallery.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 6
                        radius: 16
                        color: Theme.black
                        border.width: root.selectedPath === tile.path ? 3 : 1
                        border.color: root.selectedPath === tile.path ? Theme.primary : Theme.alternate
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: tile.fileUrl
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true
                            sourceSize.width: 420
                            sourceSize.height: 260
                        }

                        Rectangle {
                            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                            height: 28
                            color: "#bb000000"
                            Text { anchors.centerIn: parent; text: tile.fileName; color: Theme.foreground; font.family: Theme.font; font.pixelSize: 10; elide: Text.ElideMiddle; width: parent.width - 16; horizontalAlignment: Text.AlignHCenter }
                        }

                        MouseArea { anchors.fill: parent; onClicked: root.preview(tile.path) }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { Layout.fillWidth: true; text: root.selectedPath || "select an image to preview it on the desktop"; elide: Text.ElideMiddle; color: Theme.foreground; opacity: 0.6; font.family: Theme.font; font.pixelSize: 11 }
                Rectangle {
                    width: 150
                    height: 42
                    radius: 16
                    color: root.selectedPath ? Theme.primary : Theme.alternate
                    opacity: root.selectedPath ? 1 : 0.4
                    Text { anchors.centerIn: parent; text: "適用 · apply"; color: Theme.black; font.family: Theme.font; font.pixelSize: 13; font.bold: true }
                    MouseArea {
                        anchors.fill: parent
                        enabled: root.selectedPath !== ""
                        onClicked: {
                            root.previewing = false
                            ShellState.wallpaperPickerVisible = false
                            Quickshell.execDetached(["wwallpaper-apply", root.selectedPath])
                        }
                    }
                }
            }
        }
    }
}
