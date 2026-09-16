pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property real cpu: 0
  property real load: 0
  property real memory: 0
  property real memoryUsedKb: 0
  property real memoryTotalKb: 0
  property real swap: 0
  property real cpuTemp: 0
  property real memoryTemp: 0
  property real diskTemp: 0
  property real ambientTemp: 0
  property real diskUsed: 0
  property string diskLabel: ""
  property string uptime: ""
  property string networkInterface: ""
  property string networkAddress: ""
  property var cpuHistory: []
  property var memoryHistory: []

  property var previousCpu: null
  property bool sensorsAvailable: true

  readonly property int historySize: 60

  readonly property string memoryLabel: root.memoryTotalKb > 0 ? root.human(root.memoryUsedKb) + " / " + root.human(root.memoryTotalKb) : ""

  function human(kb: real): string {
    const mb = kb / 1024;
    if (mb >= 1048576)
      return (mb / 1048576).toFixed(1) + "T";
    if (mb >= 1024) {
      const gb = mb / 1024;
      return (gb >= 10 ? Math.round(gb) : gb.toFixed(1)) + "G";
    }
    return Math.round(mb) + "M";
  }

  function pushHistory(list: var, sample: real): var {
    const next = list.slice(Math.max(0, list.length - root.historySize + 1));
    next.push(sample);
    return next;
  }

  function formatUptime(seconds: real): string {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor(seconds % 86400 / 3600);
    const minutes = Math.floor(seconds % 3600 / 60);
    if (days > 0)
      return days + "d " + hours + "h";
    if (hours > 0)
      return hours + "h " + minutes + "m";
    return minutes + "m";
  }

  function percent(fraction: real): string {
    const value = Math.round(Math.max(0, fraction) * 100);
    return (value < 10 ? "0" : "") + value + "%";
  }

  function degrees(celsius: real): string {
    const value = Math.round(celsius);
    return (value < 10 ? "0" : "") + value + "°";
  }

  function readout(fraction: real, celsius: real): string {
    return celsius > 0 ? root.percent(fraction) + "/" + root.degrees(celsius) : root.percent(fraction);
  }

  function cpuTempRank(chip: string, feature: string): int {
    if (chip.startsWith("k10temp") && feature === "tctl")
      return 100;
    if (chip.startsWith("zenpower") && feature === "tdie")
      return 95;
    if (chip.startsWith("coretemp") && feature.startsWith("package id"))
      return 90;
    if (feature === "cpu" || feature.startsWith("cpu@"))
      return 80;
    if (feature.startsWith("cpu") || feature.startsWith("tdie") || feature.startsWith("tctl"))
      return 60;
    if (chip.startsWith("acpitz"))
      return 10;
    return 0;
  }

  function memoryTempRank(chip: string, feature: string): int {
    if (chip.startsWith("spd5118"))
      return 100;
    if (feature.includes("memory") || feature.includes("dimm"))
      return 90;
    return 0;
  }

  function diskTempRank(chip: string, feature: string): int {
    if (chip.startsWith("nvme") && feature === "composite")
      return 100;
    if (chip.startsWith("nvme"))
      return 80;
    if (chip.startsWith("drivetemp"))
      return 70;
    return 0;
  }

  function ambientTempRank(chip: string, feature: string): int {
    if (feature.includes("ambient"))
      return 100;
    if (feature === "systin")
      return 90;
    if (feature.includes("mainboard") || feature.includes("motherboard") || feature.includes("board"))
      return 70;
    return 0;
  }

  function applyTemps(payload: string): void {
    let chips;
    try {
      chips = JSON.parse(payload);
    } catch (error) {
      return;
    }

    const empty = {
      rank: 0,
      value: 0
    };
    const better = (slot, rank, value) => rank > slot.rank ? {
        rank: rank,
        value: value
      } : slot;

    let cpu = empty;
    let memory = empty;
    let disk = empty;
    let ambient = empty;

    for (const chipName in chips) {
      const chip = chipName.toLowerCase();
      const features = chips[chipName];
      for (const featureName in features) {
        const readings = features[featureName];
        if (typeof readings !== "object")
          continue;

        let value = null;
        for (const key in readings)
          if (key.startsWith("temp") && key.endsWith("_input"))
            value = readings[key];
        if (value === null || value <= 0 || value > 150)
          continue;

        const feature = featureName.toLowerCase();
        cpu = better(cpu, root.cpuTempRank(chip, feature), value);
        memory = better(memory, root.memoryTempRank(chip, feature), value);
        disk = better(disk, root.diskTempRank(chip, feature), value);
        ambient = better(ambient, root.ambientTempRank(chip, feature), value);
      }
    }

    root.cpuTemp = cpu.value;
    root.memoryTemp = memory.value;
    root.diskTemp = disk.value;
    root.ambientTemp = ambient.value;
  }

  function sample(): void {
    meminfo.reload();
    stat.reload();
    uptimeFile.reload();
    loadavg.reload();
    if (root.sensorsAvailable && !temps.running)
      temps.running = true;

    root.load = Number(loadavg.text().split(" ")[0] ?? 0);

    const memory = meminfo.text();
    const total = Number(memory.match(/MemTotal:\s+(\d+)/)?.[1] ?? 1);
    const available = Number(memory.match(/MemAvailable:\s+(\d+)/)?.[1] ?? total);
    root.memory = 1 - available / total;
    root.memoryTotalKb = total;
    root.memoryUsedKb = total - available;

    const swapTotal = Number(memory.match(/SwapTotal:\s+(\d+)/)?.[1] ?? 0);
    const swapFree = Number(memory.match(/SwapFree:\s+(\d+)/)?.[1] ?? 0);
    root.swap = swapTotal > 0 ? 1 - swapFree / swapTotal : 0;

    root.uptime = root.formatUptime(Number(uptimeFile.text().split(" ")[0] ?? 0));

    const cpuLine = stat.text().match(/^cpu\s+(.+)$/m);
    if (cpuLine) {
      const values = cpuLine[1].trim().split(/\s+/).map(Number);
      const idle = values[3] + (values[4] ?? 0);
      const busy = values.reduce((sum, value) => sum + value, 0);
      if (root.previousCpu) {
        const elapsed = busy - root.previousCpu.total;
        root.cpu = elapsed > 0 ? 1 - (idle - root.previousCpu.idle) / elapsed : 0;
      }
      root.previousCpu = {
        idle: idle,
        total: busy
      };
    }

    root.cpuHistory = root.pushHistory(root.cpuHistory, root.cpu);
    root.memoryHistory = root.pushHistory(root.memoryHistory, root.memory);
  }

  function refreshSlow(): void {
    details.running = false;
    details.running = true;
  }

  FileView {
    id: meminfo

    path: "/proc/meminfo"
    blockLoading: true
    printErrors: false
  }

  FileView {
    id: stat

    path: "/proc/stat"
    blockLoading: true
    printErrors: false
  }

  FileView {
    id: uptimeFile

    path: "/proc/uptime"
    blockLoading: true
    printErrors: false
  }

  FileView {
    id: loadavg

    path: "/proc/loadavg"
    blockLoading: true
    printErrors: false
  }

  Process {
    id: details

    command: ["sh", "-c", "df -Ph / | awk 'NR == 2 { printf \"%s|%s / %s\\n\", $5, $3, $2 }'; ip route get 1.1.1.1 2>/dev/null | awk 'NR == 1 { for (i = 1; i <= NF; i++) { if ($i == \"dev\") dev = $(i + 1); if ($i == \"src\") src = $(i + 1) } printf \"%s|%s\\n\", dev, src }'"]

    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        const disk = (lines[0] ?? "").split("|");
        root.diskUsed = Number((disk[0] ?? "0%").replace("%", "")) / 100;
        root.diskLabel = disk[1] ?? "";
        const network = (lines[1] ?? "").split("|");
        root.networkInterface = network[0] ?? "";
        root.networkAddress = network[1] ?? "";
      }
    }
  }

  Process {
    id: temps

    command: ["sensors", "-j"]

    onExited: exitCode => {
      if (exitCode !== 0)
        root.sensorsAvailable = false;
    }

    stdout: StdioCollector {
      onStreamFinished: root.applyTemps(text)
    }
  }

  Timer {
    interval: 2000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.sample()
  }

  Timer {
    interval: 30000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.refreshSlow()
  }
}
