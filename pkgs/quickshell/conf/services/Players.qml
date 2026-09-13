pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property var all: Mpris.players.values
    readonly property MprisPlayer active: root.all.find(p => p.isPlaying) ?? root.all[0] ?? null
    readonly property bool hasActive: root.active !== null
    readonly property bool playing: root.active?.isPlaying ?? false

    readonly property string title: root.active?.trackTitle || root.active?.identity || ""
    readonly property string artist: root.active?.trackArtist ?? ""
    readonly property string artUrl: root.active?.trackArtUrl ?? ""

    readonly property real position: root.active?.position ?? 0
    readonly property real length: root.active?.length ?? 0
    readonly property real progress: root.length > 0 ? Math.max(0, Math.min(1, root.position / root.length)) : 0

    function next(): void {
        if (root.active?.canGoNext)
            root.active.next();
    }

    function previous(): void {
        if (root.active?.canGoPrevious)
            root.active.previous();
    }

    function toggle(): void {
        if (root.active?.canTogglePlaying)
            root.active.togglePlaying();
    }

    function seekRatio(ratio: real): void {
        if (root.active?.canSeek && root.length > 0)
            root.active.position = ratio * root.length;
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.playing
        onTriggered: root.active?.positionChanged()
    }
}
