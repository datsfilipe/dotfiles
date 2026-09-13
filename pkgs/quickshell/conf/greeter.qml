//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Services.Greetd
import qs.components
import qs.config

ShellRoot {
    id: root

    property string buffer: ""
    property string message: ""
    property bool failed: false
    property bool awaitingResponse: false

    readonly property string user: Config.greeterUser

    function submit(): void {
        if (Greetd.state === GreetdState.Inactive) {
            root.message = "";
            Greetd.createSession(root.user);
        } else if (root.awaitingResponse) {
            root.awaitingResponse = false;
            Greetd.respond(root.buffer);
            root.buffer = "";
        }
    }

    function handleKey(event): void {
        if (Greetd.state === GreetdState.ReadyToLaunch)
            return;

        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.submit();
        } else if (event.key === Qt.Key_Backspace) {
            root.buffer = event.modifiers & Qt.ControlModifier ? "" : root.buffer.slice(0, -1);
        } else if (event.key === Qt.Key_Escape) {
            root.buffer = "";
        } else if (/^[^\x00-\x1F\x7F-\x9F]+$/.test(event.text)) {
            root.buffer += event.text;
        }

        if (root.failed && root.buffer.length > 0) {
            root.failed = false;
            root.message = "";
        }
    }

    Connections {
        function onAuthMessage(message: string, error: bool, responseRequired: bool, echoResponse: bool): void {
            if (responseRequired) {
                root.awaitingResponse = true;
                root.submit();
            } else if (error) {
                root.message = message;
            }
        }

        function onAuthFailure(message: string): void {
            root.buffer = "";
            root.failed = true;
            root.message = message || "wrong password";
            reset.restart();
        }

        function onReadyToLaunch(): void {
            Greetd.launch(Config.greeterSession, [], false);
            Quickshell.execDetached(["niri", "msg", "action", "quit", "-s"]);
        }

        function onError(error: string): void {
            root.buffer = "";
            root.failed = true;
            root.message = error;
            reset.restart();
        }

        target: Greetd
    }

    Timer {
        id: reset

        interval: 4000
        onTriggered: {
            root.failed = false;
            root.message = "";
        }
    }

    PanelWindow {
        id: window

        color: Appearance.colors.base
        focusable: true
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        AuthFace {
            id: face

            anchors.fill: parent
            user: root.user
            typed: root.buffer.length
            busy: Greetd.state === GreetdState.Authenticating && !root.awaitingResponse
            failed: root.failed
            message: root.message
            caption: Greetd.state === GreetdState.ReadyToLaunch ? "starting session…" : ""
        }

        Connections {
            function onFailedChanged(): void {
                if (root.failed)
                    face.reject();
            }

            target: root
        }

        Item {
            anchors.fill: parent
            focus: true
            Keys.onPressed: event => {
                root.handleKey(event);
                event.accepted = true;
            }
        }
    }
}
