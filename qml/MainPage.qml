import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Page {
    id: main

    property Device device: null

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
                title: qsTr("Encryption Setup")
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.highlightColor
                height: implicitHeight + 2*Theme.paddingLarge
                text: qsTr("Welcome! Your device supports encryption of the filesystem. " +
                           "This wizard will let you select whether to enable it " +
                           "and, if it is enabled, to set it up.")
                wrapMode: Text.WordWrap
            }

            PageHeader {
                title: main.device.name
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                color: Theme.highlightColor
                text: qsTr("Encrypt %1?").arg(main.device.name)
                visible: main.device
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                Button {
                    text: qsTr("Yes")
                    onClicked: pageStack.push(Qt.resolvedUrl("SetEncryptPage.qml"),
                                              {
                                                  "device": main.device,
                                                  "encrypt": true
                                              })
                }
                Button {
                    text: qsTr("No")
                    onClicked: pageStack.push(Qt.resolvedUrl("SetEncryptPage.qml"),
                                              {
                                                  "device": main.device,
                                                  "encrypt": false
                                              })
                }
            }
        }

        VerticalScrollDecorator { flickable: parent }
    }

    Component.onCompleted: nextDev()

    function nextDev() {
        var d = DeviceList.nextDevice();
        while (d != null) {
            if (!d.initialized)
                break;
            d = DeviceList.nextDevice();
        }
        main.device = d;
    }
}
