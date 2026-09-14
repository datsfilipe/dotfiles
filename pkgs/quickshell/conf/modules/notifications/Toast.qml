import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services

Item {
  id: root

  required property var wrapper

  property bool entered: false

  readonly property bool critical: root.wrapper.urgency === "critical"

  readonly property string image: root.wrapper.image || root.wrapper.appIcon

  readonly property string imageSource: {
    if (root.image === "")
      return "";
    if (root.image.startsWith("/"))
      return "file://" + root.image;
    if (root.image.includes("://"))
      return root.image;
    return Quickshell.iconPath(root.image, true);
  }

  readonly property bool hasImage: root.imageSource !== ""

  implicitHeight: root.entered ? card.implicitHeight : 0
  clip: true

  Component.onCompleted: root.entered = true

  Behavior on implicitHeight {
    Anim {
      speed: "fast"
    }
  }

  Card {
    id: card

    shown: root.entered
    growFrom: Item.TopRight
    width: parent.width - Appearance.elevation.offset
    implicitHeight: layout.implicitHeight + Appearance.padding.normal * 2
    border.color: root.critical ? Appearance.colors.error : Appearance.colors.outlineStrong

    x: root.entered ? 0 : width * 0.2

    Behavior on x {
      Anim {
        speed: root.entered ? "enter" : "exit"
      }
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: event => {
        if (event.button === Qt.RightButton)
          Notifs.discard(root.wrapper);
        else
          Notifs.dismissPopup(root.wrapper);
      }
    }

    RowLayout {
      id: layout

      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: Appearance.padding.normal
      spacing: Appearance.spacing.normal

      Rectangle {
        Layout.preferredWidth: 44
        Layout.preferredHeight: 44
        Layout.alignment: Qt.AlignTop
        visible: root.hasImage
        color: Appearance.colors.layer2
        border.width: Appearance.elevation.borderWidth
        border.color: Appearance.colors.outline
        clip: true

        Image {
          anchors.fill: parent
          anchors.margins: Appearance.elevation.borderWidth
          source: root.imageSource
          sourceSize.width: 88
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
          cache: true
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.tiny

        RowLayout {
          Layout.fillWidth: true
          spacing: Appearance.spacing.small

          Label {
            visible: !root.hasImage
            text: root.critical ? "!" : "*"
            color: root.critical ? Appearance.colors.error : Appearance.colors.accent
            font.letterSpacing: 0
          }

          StyledText {
            Layout.fillWidth: true
            text: root.wrapper.summary
            elide: Text.ElideRight
            color: root.critical ? Appearance.colors.error : Appearance.colors.text
            font.pixelSize: Appearance.font.size.normal
          }

          Label {
            text: root.wrapper.appName
          }
        }

        StyledText {
          Layout.fillWidth: true
          Layout.leftMargin: root.hasImage ? 0 : Appearance.spacing.large
          visible: text !== ""
          text: root.wrapper.body
          textFormat: Text.StyledText
          wrapMode: Text.Wrap
          maximumLineCount: 4
          elide: Text.ElideRight
          color: Appearance.colors.subtext
          font.pixelSize: Appearance.font.size.small
        }

        RowLayout {
          Layout.fillWidth: true
          Layout.leftMargin: root.hasImage ? 0 : Appearance.spacing.large
          Layout.topMargin: Appearance.spacing.tiny
          visible: root.wrapper.actions.length > 0
          spacing: Appearance.spacing.small

          Repeater {
            model: root.wrapper.actions

            TextButton {
              id: action

              required property var modelData

              implicitHeight: 22
              horizontalPadding: Appearance.padding.small
              text: action.modelData.text

              onClicked: {
                action.modelData.invoke();
                Notifs.dismissPopup(root.wrapper);
              }
            }
          }

          Item {
            Layout.fillWidth: true
          }
        }
      }
    }
  }
}
