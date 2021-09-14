import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Page {
    id: page

    // set these properties when pushing page
    property Device device: null

    // internal properties
    property bool   busy:   false
    property bool   done:   false
    property bool   failed: false
    property string type

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
            visible: !done
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
                text: qsTr("Set password for the encrypted filesystem. Note that only one password is needed at this stage. " +
                           "Addition, removal, and changes to passwords is performed through Sailfish OS Settings.")
                visible: !page.busy
                wrapMode: Text.WordWrap
            }

            SectionHeader {
                text: qsTr("Add password")
                visible: !page.busy
            }

            Repeater {
                id: pwd

                delegate: ListItem {
                    contentHeight: Theme.itemSizeSmall
                    visible: !page.busy

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
                visible: failed && !busy
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                height: implicitHeight + 2*Theme.paddingLarge
                visible: failed && !busy

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
                visible: failed && !busy
                wrapMode: Text.WordWrap
            }

            ButtonLayout {
                visible: failed && !busy
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

    BusyLabel {
        text: qsTr("Setting password")
        running: page.busy
    }

    Timer {
        id: pauseBeforeAction
        interval: 250
        repeat: false

        property string password

        onTriggered: {
            var p = PasswordMaker.newPassword(type);
            p.password = password;
            if (device.addPassword(p) &&
                    device.setInitialized())
                pageStack.replace(Qt.resolvedUrl("MainPage.qml"));
            else
                failed = true;

            // reset
            password = "";
            busy = false;
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active && busy && pauseBeforeAction.password ) {
            pauseBeforeAction.start();
        }
    }

    function set(password) {
        busy = true;
        pauseBeforeAction.password = password;
    }
}
