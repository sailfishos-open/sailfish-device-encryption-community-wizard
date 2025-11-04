import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Page {
    id: main

    property Device device: null
    property bool   firstTime: false

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
                title: qsTr("Encryption Setup")
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeLarge
                height: implicitHeight + 2*Theme.paddingLarge
                text: {
                    if (firstTime) {
                        if (device && device.encryptionRequired) {
                            return qsTr("Welcome! Your device requires encryption of the filesystem. " +
                            "This wizard will let you set it up.");
                        }
                        return qsTr("Welcome! Your device supports encryption of the filesystem. " +
                                    "This wizard will let you select whether to enable it " +
                                    "and, if it is enabled, to set it up.");
                    }
                    if (device) {
                        if (device.encryptionRequired) {
                            return qsTr("This device requires encryption for correct operation. " +
                                        "Continue by setting up the following filesystem.");
                        }
                        return qsTr("Continue by setting up the following filesystem.")
                    }

                    return qsTr("Congratulations! You are all set.\n\nContinue with the setup of Sailfish OS by rebooting your device.")
                }
                wrapMode: Text.WordWrap
            }

            PageHeader {
                title: main.device ? main.device.name : ""
                visible: main.device
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
                text: main.device ? qsTr("Encrypt %1?").arg(main.device.name) : ""
                visible: main.device
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                visible: main.device
                Button {
                    text: qsTr("Yes")
                    onClicked: pageStack.replace(Qt.resolvedUrl("SetEncryptPage.qml"),
                                                 {
                                                     "device": main.device,
                                                     "encrypt": true
                                                 })
                }
                Button {
                    text: qsTr("No")
                    visible: !main.device.encryptionRequired
                    onClicked: pageStack.replace(Qt.resolvedUrl("SetEncryptPage.qml"),
                                                 {
                                                     "device": main.device,
                                                     "encrypt": false
                                                 })
                }
            }

            ButtonLayout {
                visible: !device
                Button {
                    text: qsTr("Reboot")
                    onClicked: system.reboot()
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
                visible: device && device.developer
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

    Component.onCompleted: nextDev()

    function nextDev() {
        DeviceList.resetNextDevice();
        var d = DeviceList.nextDevice();
        while (d != null) {
            if (!d.initialized)
                break;
            d = DeviceList.nextDevice();
        }
        main.device = d;
    }
}
