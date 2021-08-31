import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Page {
    id: page
    backNavigation: !busy

    // setup when pushing page
    property bool   encrypt
    property Device device: null

    property bool   busy: false
    property bool   done: false
    property bool   success: false

    Rectangle {
        color: app.bgColor
        anchors.fill: parent
    }

    SilicaFlickable {
        anchors.fill: parent

        Column {
            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader {
                title: page.device.name
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.highlightColor
                text: {
                    if (!success) return qsTr("Failed to setup the filesystem.");
                    if (encrypt)
                        return qsTr("Filesystem encryption successful. Proceed with setting passwords");
                    return qsTr("Filesystem is ready to use")
                }
                visible: page.done
                wrapMode: Text.WordWrap
            }

            Button {
                text: "Quit"
                onClicked: Qt.quit()
            }

        }

        VerticalScrollDecorator { flickable: parent }
    }

    BusyLabel {
        text: encrypt ? qsTr("Encrypting") : qsTr("Preparing")
        running: page.busy
    }

    Timer {
        id: pauseBeforeAction
        interval: 100
        repeat: false
        onTriggered: {
            var now = new Date().getTime();
            while(new Date().getTime() < now + 20000){ /* Do nothing */ }

//            if (page.device.setEncryption(encrypt)) {
//                success = true;
//            } else {
//                success = false;
//            }

            success = true;

            if (success && !encrypt) {
                success = device.setInitialized();
            }

            busy = false;
            done = true;
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active ) {
            busy = true;
            pauseBeforeAction.start();
        }
    }
}
