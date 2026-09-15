pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  function mix(a: color, b: color, t: real): color {
    return Qt.rgba(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t, a.a + (b.a - a.a) * t);
  }

  function alpha(c: color, a: real): color {
    return Qt.rgba(c.r, c.g, c.b, a);
  }

  readonly property QtObject term: QtObject {
    readonly property color primary: "@primary@"
    readonly property color background: "@background@"
    readonly property color alternate: "@alternate@"
    readonly property color selection: "@selection@"
    readonly property color foreground: "@foreground@"
    readonly property color black: "@black@"
    readonly property color red: "@red@"
    readonly property color green: "@green@"
    readonly property color yellow: "@yellow@"
    readonly property color blue: "@blue@"
    readonly property color magenta: "@magenta@"
    readonly property color cyan: "@cyan@"
    readonly property color white: "@white@"
  }

  readonly property QtObject colors: QtObject {
    readonly property color base: root.term.background
    readonly property color panel: root.mix(root.term.background, root.term.foreground, 0.06)
    readonly property color layer1: root.mix(root.term.background, root.term.foreground, 0.11)
    readonly property color layer2: root.mix(root.term.background, root.term.foreground, 0.17)

    readonly property color hover: root.alpha(root.term.foreground, 0.08)
    readonly property color press: root.alpha(root.term.foreground, 0.14)

    readonly property color outline: root.mix(root.term.background, root.term.foreground, 0.24)
    readonly property color outlineStrong: root.mix(root.term.background, root.term.foreground, 0.45)

    readonly property color text: root.term.foreground
    readonly property color subtext: root.mix(root.term.foreground, root.term.background, 0.14)
    readonly property color faint: root.mix(root.term.foreground, root.term.background, 0.34)

    readonly property color accent: root.term.primary
    readonly property color accentDim: root.mix(root.term.primary, root.term.background, 0.45)
    readonly property color onAccent: root.term.background

    readonly property color error: root.mix(root.term.red, root.term.foreground, 0.25)
    readonly property color warning: root.term.yellow
    readonly property color success: root.mix(root.term.green, root.term.foreground, 0.2)
    readonly property color info: root.mix(root.term.cyan, root.term.foreground, 0.2)

    readonly property color scrim: root.alpha("#000000", 0.55)
    readonly property color shadow: root.alpha("#000000", 0.62)
  }

  readonly property QtObject rounding: QtObject {
    readonly property int none: 0
    readonly property int small: 0
    readonly property int normal: 0
    readonly property int large: 0
  }

  readonly property QtObject elevation: QtObject {
    readonly property int offset: 5
    readonly property int borderWidth: 1
  }

  readonly property QtObject spacing: QtObject {
    readonly property int tiny: 4
    readonly property int small: 6
    readonly property int normal: 10
    readonly property int large: 16
    readonly property int huge: 24
  }

  readonly property QtObject padding: QtObject {
    readonly property int tiny: 4
    readonly property int small: 8
    readonly property int normal: 12
    readonly property int large: 18
    readonly property int huge: 26
  }

  readonly property QtObject font: QtObject {
    readonly property QtObject family: QtObject {
      readonly property string sans: "Inter"
      readonly property string mono: "JetBrainsMono Nerd Font"
    }
    readonly property QtObject size: QtObject {
      readonly property int tiny: 11
      readonly property int small: 12
      readonly property int normal: 13
      readonly property int medium: 14
      readonly property int large: 16
      readonly property int xlarge: 19
      readonly property int title: 23
      readonly property int display: 32
      readonly property int hero: 46
    }
    readonly property real labelSpacing: 1.6
  }

  readonly property QtObject sizes: QtObject {
    readonly property int barHeight: 34
    readonly property int barMargin: 6
    readonly property int barSideMargin: 20
    readonly property int barItemHeight: 26
    readonly property int panelWidth: 400
    readonly property int hitArea: 28
    readonly property int mascotSize: 96
  }

  readonly property QtObject anim: QtObject {
    readonly property QtObject fast: QtObject {
      readonly property int duration: 200
      readonly property list<real> curve: [0.34, 0.80, 0.34, 1.00, 1, 1]
    }
    readonly property QtObject std: QtObject {
      readonly property int duration: 350
      readonly property list<real> curve: [0.42, 1.67, 0.21, 0.90, 1, 1]
    }
    readonly property QtObject slow: QtObject {
      readonly property int duration: 500
      readonly property list<real> curve: [0.38, 1.21, 0.22, 1.00, 1, 1]
    }
    readonly property QtObject enter: QtObject {
      readonly property int duration: 400
      readonly property list<real> curve: [0.05, 0.7, 0.1, 1, 1, 1]
    }
    readonly property QtObject exit: QtObject {
      readonly property int duration: 200
      readonly property list<real> curve: [0.3, 0, 0.8, 0.15, 1, 1]
    }
  }
}
