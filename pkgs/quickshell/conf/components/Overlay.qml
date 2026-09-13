import QtQuick
import Quickshell
import qs.config

PanelWindow {
    id: root

    property bool shown: false
    property bool dim: true
    property bool dismissable: true
    property bool grabsKeyboard: true
    default property alias contentData: container.data

    property real reveal: root.shown ? 1 : 0

    signal dismissed
    signal keyPressed(var event)

    visible: root.shown || root.reveal > 0.001
    color: "transparent"
    aboveWindows: true
    focusable: root.grabsKeyboard
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    function close(): void {
        if (root.dismissable)
            root.dismissed();
    }

    Behavior on reveal {
        Anim {
            speed: root.shown ? "enter" : "exit"
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.scrim
        opacity: root.dim ? root.reveal : 0
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Item {
        id: container

        anchors.fill: parent
    }

    Item {
        anchors.fill: parent
        focus: root.shown && root.grabsKeyboard

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                root.close();
                event.accepted = true;
                return;
            }
            root.keyPressed(event);
        }
    }
}
