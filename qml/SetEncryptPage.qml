import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Page {
    id: page

    // set these properties when pushing page
    property bool   encrypt
    property Device device: null

    // internal properties
    property bool   busy: false
    property bool   done: false
    property bool   success: false

    Rectangle {
        color: app.bgColor
        anchors.fill: parent
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
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

                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeLarge
                text: {
                    if (!success)
                        return qsTr("Failed to setup the filesystem. This suggests an error in the device adaptation. Please contact the porter of the device.");
                    return qsTr(""); // going to the next page in a moment
                }
                visible: page.done
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                height: implicitHeight + 2*Theme.paddingLarge
                visible: done && !success

                Button {
                    text: qsTr("Back")
                    onClicked: pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
                }
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.highlightColor
                //font.pixelSize: Theme.fontSizeLarge
                text: qsTr("It is possible to quit the setup of filesystems by pressing Quit below. " +
                           "This option is mainly for debug purposes and is expected to be used by device porters " +
                           "at the testing stage.")
                visible: done && !success
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                visible: done && !success

                Button {
                    text: "Quit"
                    onClicked: Qt.quit()
                }
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
            while(new Date().getTime() < now + 5000){ /* Do nothing */ }

            //            if (page.device.setEncryption(encrypt)) {
            //                success = true;
            //            } else {
            //                success = false;
            //            }

            success = true;

            //            if (success && !encrypt) {
            //                success = device.setInitialized();
            //            }

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

    onSuccessChanged: {
        if (success && encrypt) {
            pageStack.replace(Qt.resolvedUrl("PasswordPage.qml"),
                              {
                                  "device": device
                              });
        } else if (success) {
            pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
        }
    }
}
