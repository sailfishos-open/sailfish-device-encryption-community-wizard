import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Page {
    id: page

    // set these properties when pushing page
    property Device device: null

    // internal properties
    property bool   failed: false
    property string type

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
                title: qsTr("Password for %1").arg(page.device.name)
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.highlightColor
                height: implicitHeight + Theme.paddingLarge
                text: qsTr("Set password for encrypted filesystem. Note that only one password is needed at this stage. " +
                           "Addition, removal, and changes of passwords are supported through Sailfish OS Settings.")
                wrapMode: Text.WordWrap
            }

            SectionHeader {
                text: qsTr("Add password")
            }

            Repeater {
                id: pwd

                delegate: ListItem {
                    contentHeight: Theme.itemSizeSmall

                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.horizontalPageMargin
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.horizontalPageMargin
                        anchors.verticalCenter: parent.verticalCenter
                        text: PasswordMaker.description(pwd.types[index])
                    }

                    onClicked: {
                        page.type = pwd.types[index];
                        pageStack.animatorPush(firstEntryPage);
                    }
                }

                height: implicitHeight + Theme.paddingLarge
                model: types.length

                property var types: PasswordMaker.types()
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

                color: Theme.primaryColor
                height: implicitHeight + Theme.paddingLarge
                text: qsTr("Failed to add password to the filesystem. This suggests an error in the device adaptation. Please contact the porter of the device.");
                visible: failed
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                height: implicitHeight + 2*Theme.paddingLarge
                visible: failed

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
                visible: failed
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                visible: failed
                Button {
                    text: "Quit"
                    onClicked: Qt.quit()
                }
            }

        }

        VerticalScrollDecorator { flickable: parent }
    }

    Component {
        id: firstEntryPage

        PasswordEntryDialog {
            acceptDestination: secondEntryPage
            onAcceptPendingChanged: {
                if (acceptPending) {
                    acceptDestinationInstance.previousPassword = password
                }
            }
        }
    }

    Component {
        id: secondEntryPage

        PasswordEntryDialog {
            acceptDestination: page
            acceptDestinationAction: PageStackAction.Pop
            onAccepted: page.set(password)
        }
    }

    function set(password) {
        var p = PasswordMaker.newPassword(type);
        p.password = password;
        if (device.addPassword(password) &&
                device.setInitialized())
            pageStack.replace(Qt.resolvedUrl("MainPage.qml"));
        else
            failed = true;
    }
}
