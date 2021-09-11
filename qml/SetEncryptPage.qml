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

            Rectangle {
                color: "transparent"
                height: Theme.paddingLarge*2
                width: parent.width
            }

            TextSwitch {
                id: devSwitch
                checked: false
                text: qsTr("Developer options")
                visible: done
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.highlightColor
                text: qsTr("It is possible to proceed with the boot by pressing Quit button below. " +
                           "This will allow you to study logs and find out why the setup wizard did not work.")
                visible: devSwitch.checked
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                visible: devSwitch.checked
                Button {
                    text: qsTr("Quit")
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
            if (page.device.setEncryption(encrypt)) {
                success = true;
            } else {
                success = false;
            }

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
