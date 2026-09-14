pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var usage: ({})

  function score(query: string, haystack: string): int {
    const needle = query.toLowerCase();
    const target = haystack.toLowerCase();

    const direct = target.indexOf(needle);
    if (direct >= 0)
      return 1000 - direct * 4;

    let cursor = 0;
    let total = 0;
    for (let i = 0; i < target.length && cursor < needle.length; i++) {
      if (target[i] === needle[cursor]) {
        cursor++;
        total += 10 - Math.min(i, 9);
      }
    }
    return cursor === needle.length ? total : -1;
  }

  function search(query: string, limit: int): var {
    const trimmed = query.trim();
    const matches = [];

    for (const entry of DesktopEntries.applications.values) {
      if (entry.noDisplay)
        continue;

      const haystack = [entry.name, entry.genericName ?? "", entry.comment ?? "", (entry.keywords ?? []).join(" ")].join(" ");
      const rank = trimmed === "" ? (root.usage[entry.id] ?? 0) : root.score(trimmed, haystack);
      if (rank >= 0)
        matches.push({
          entry: entry,
          rank: rank + (trimmed === "" ? 0 : (root.usage[entry.id] ?? 0) * 3)
        });
    }

    matches.sort((a, b) => b.rank - a.rank || a.entry.name.localeCompare(b.entry.name));
    return matches.slice(0, limit).map(match => match.entry);
  }

  function launch(entry): void {
    if (!entry)
      return;
    root.usage[entry.id] = (root.usage[entry.id] ?? 0) + 1;
    usageFile.setText(JSON.stringify(root.usage));
    entry.execute();
  }

  FileView {
    id: usageFile

    path: Quickshell.statePath("launcher-usage.json")
    blockLoading: true
    printErrors: false

    onLoaded: {
      try {
        root.usage = JSON.parse(text());
      } catch (error) {
        root.usage = ({});
      }
    }
  }
}
