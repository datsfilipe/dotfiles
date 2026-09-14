pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
  id: root

  property var list: []
  property string preview: ""
  property bool scanning: false

  readonly property string cacheDir: (Quickshell.env("XDG_CACHE_HOME") || Quickshell.env("HOME") + "/.cache") + "/dats-quickshell/wallpapers"

  function scan(): void {
    if (root.scanning)
      return;
    root.scanning = true;
    thumbnails.running = true;
  }

  function previewOne(path: string): void {
    root.preview = path;
    Quickshell.execDetached(["wwallpaper-preview", path]);
  }

  function restore(): void {
    root.preview = "";
    Quickshell.execDetached(["wwallpaper-restore"]);
  }

  function apply(path: string): void {
    Quickshell.execDetached(["wwallpaper-apply", path]);
  }

  Process {
    id: thumbnails

    command: ["wwallpaper-thumbnails"]
    onExited: listing.running = true
  }

  Process {
    id: listing

    command: ["sh", "-c", "find " + Config.wallpaperDir + " -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) | sort"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.list = text.trim().split("\n").filter(line => line.length > 0).map(path => ({
              path: path,
              name: path.split("/").pop(),
              thumbnail: root.cacheDir + "/" + path.split("/").pop()
            }));
        root.scanning = false;
      }
    }
  }
}
