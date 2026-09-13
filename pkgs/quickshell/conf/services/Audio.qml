pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.config

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: root.sink?.audio?.volume ?? 0
    readonly property bool muted: root.sink?.audio?.muted ?? false
    readonly property real sourceVolume: root.source?.audio?.volume ?? 0
    readonly property bool sourceMuted: root.source?.audio?.muted ?? false

    readonly property var sinks: Pipewire.nodes.values.filter(node => !node.isStream && node.isSink && node.audio)
    readonly property var sources: Pipewire.nodes.values.filter(node => !node.isStream && !node.isSink && node.audio)

    readonly property string volumeIcon: root.muted ? "volume_off" : root.volume < 0.01 ? "volume_mute" : root.volume < 0.5 ? "volume_down" : "volume_up"

    function label(node: PwNode): string {
        return node?.description || node?.nickname || node?.name || "";
    }

    function setVolume(value: real): void {
        if (!root.sink?.ready || !root.sink?.audio)
            return;
        root.sink.audio.muted = false;
        root.sink.audio.volume = Math.max(0, Math.min(1, value));
    }

    function setSourceVolume(value: real): void {
        if (!root.source?.ready || !root.source?.audio)
            return;
        root.source.audio.volume = Math.max(0, Math.min(1, value));
    }

    function toggleMute(): void {
        if (root.sink?.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }

    function toggleSourceMute(): void {
        if (root.source?.audio)
            root.source.audio.muted = !root.source.audio.muted;
    }

    function step(direction: int): void {
        root.setVolume(root.volume + direction * Config.volumeStep);
    }

    PwObjectTracker {
        objects: [...root.sinks, ...root.sources]
    }
}
