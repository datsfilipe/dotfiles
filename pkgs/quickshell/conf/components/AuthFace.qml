pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import qs.config

Item {
  id: root

  property string user: ""
  property int typed: 0
  property bool busy: false
  property bool failed: false
  property string message: ""
  property string caption: ""
  property string wallpaper: ""

  function reject(): void {
    shakeAnim.restart();
  }

  SystemClock {
    id: clock

    precision: SystemClock.Seconds
  }

  Image {
    id: backdrop

    anchors.fill: parent
    source: root.wallpaper === "" ? "" : "file://" + root.wallpaper
    sourceSize.width: 480
    fillMode: Image.PreserveAspectCrop
    visible: false
    asynchronous: false
    cache: true
  }

  MultiEffect {
    anchors.fill: parent
    source: backdrop
    visible: backdrop.status === Image.Ready
    blurEnabled: true
    blur: 1
    blurMax: 32
    brightness: -0.4
    saturation: -0.3
  }

  Rectangle {
    anchors.fill: parent
    color: Appearance.alpha(Appearance.colors.base, backdrop.status === Image.Ready ? 0.5 : 1)
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: Appearance.spacing.huge

    ColumnLayout {
      Layout.alignment: Qt.AlignHCenter
      spacing: Appearance.spacing.tiny

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: Appearance.colors.text
        font.family: Appearance.font.family.mono
        font.pixelSize: 96
      }

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDate(clock.date, "dddd - MMMM d")
        color: Appearance.colors.subtext
        font.pixelSize: Appearance.font.size.large
      }
    }

    Card {
      id: box

      property real shake: 0

      Layout.alignment: Qt.AlignHCenter
      implicitWidth: 320
      implicitHeight: form.implicitHeight + Appearance.padding.normal * 2
      color: Appearance.alpha(Appearance.colors.panel, 0.94)
      border.color: root.failed ? Appearance.colors.error : root.busy ? Appearance.colors.accent : Appearance.colors.outlineStrong

      transform: Translate {
        x: box.shake
      }

      Behavior on border.color {
        ColorAnim {}
      }

      SequentialAnimation {
        id: shakeAnim

        loops: 3

        NumberAnimation {
          target: box
          property: "shake"
          to: 7
          duration: 45
        }
        NumberAnimation {
          target: box
          property: "shake"
          to: -7
          duration: 45
        }
        NumberAnimation {
          target: box
          property: "shake"
          to: 0
          duration: 45
        }
      }

      ColumnLayout {
        id: form

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Appearance.padding.normal
        spacing: Appearance.spacing.normal

        StyledText {
          Layout.alignment: Qt.AlignHCenter
          text: root.user
          color: Appearance.colors.text
          font.family: Appearance.font.family.mono
          font.pixelSize: Appearance.font.size.large
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 34
          color: Appearance.colors.layer1
          border.width: Appearance.elevation.borderWidth
          border.color: Appearance.colors.outline

          Row {
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.normal
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Repeater {
              model: root.typed

              StyledText {
                id: star

                text: "*"
                color: Appearance.colors.accent
                font.family: Appearance.font.family.mono
                font.pixelSize: Appearance.font.size.xlarge
                scale: 0

                Component.onCompleted: pop.start()

                NumberAnimation {
                  id: pop

                  target: star
                  property: "scale"
                  to: 1
                  duration: Appearance.anim.fast.duration
                  easing.type: Easing.BezierSpline
                  easing.bezierCurve: Appearance.anim.fast.curve
                }
              }
            }
          }

          StyledText {
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.normal
            anchors.verticalCenter: parent.verticalCenter
            visible: root.typed === 0
            text: root.busy ? "checking…" : "password for " + root.user
            color: Appearance.colors.faint
            font.pixelSize: Appearance.font.size.normal
          }
        }
      }
    }

    StyledText {
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredHeight: Appearance.font.size.medium + 4
      text: root.message || root.caption
      color: root.message ? Appearance.colors.error : Appearance.colors.faint
      font.pixelSize: Appearance.font.size.small
      opacity: text === "" ? 0 : 1

      Behavior on opacity {
        Anim {
          speed: "fast"
        }
      }
    }
  }
}
