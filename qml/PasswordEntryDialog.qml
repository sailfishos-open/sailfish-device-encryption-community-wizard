import QtQuick 2.0
import Sailfish.Silica 1.0

import org.devenc 1.0

Dialog {
    id: page

    canNavigateForward: password.length > 1 && (previousPassword == password || !previousPassword)

    property string previousPassword
    property alias  password: input.text
    property string type

    Rectangle {
        color: app.bgColor
        anchors.fill: parent
    }

    Column {
        id: column
        anchors.top: page.top
        spacing: Theme.paddingLarge
        width: page.width

        DialogHeader {
            title: previousPassword ? qsTr("Enter password again") : qsTr("Enter password")
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin

            color: Theme.highlightColor
            height: implicitHeight + 2*Theme.paddingLarge
            text: qsTr("Set password for encrypted filesystem.")
            wrapMode: Text.WordWrap
        }

        PasswordField {
            id: input
            focus: true
            label: {
                if (!previousPassword || !text) return qsTr("Password")
                if (previousPassword != text)
                    return qsTr("Passwords do not match")
                return qsTr("Passwords match")
            }
            text: ""
            onActiveFocusChanged: focus = true
        }
    }

    Keyboard {
        id: kbd
        anchors.bottom: parent.bottom
        keyHeight: Math.min(input.height * 2, Theme.itemSizeMedium,
                            (page.height - column.y - column.height - Theme.paddingLarge) / 5)
        width: parent.width

        onBackspace: {
            var position = input.cursorPosition;
            if (position < 1) return;
            input.text = input.text.substring(0, position-1) +
                    input.text.substring(position, input.text.length);
            input.cursorPosition = position - 1;
        }

        onClicked: {
            var position = input.cursorPosition;
            input.text = input.text.substring(0, position) + txt +
                    input.text.substring(position, input.text.length);
            input.cursorPosition = position + 1;
        }

        onEnter: accept()
    }

}
