import QtQuick 2.0
import Sailfish.Silica 1.0

// from https://github.com/g7/sailfishos-patch-maths-in-alarm/blob/master/data/unified_diff.patch#L225

BackgroundItem {
    id: button

    property string text
    property bool isImage: text.lastIndexOf('icon-', 0) === 0

    height: Theme.itemSizeMedium

    Loader {
        active: isImage
        width: parent.width
        height: parent.height
        visible: button.text
        sourceComponent: Item { Image {
            source: button.text ?
                        "image://theme/%1?%2".arg(button.text).arg(button.down
                                                                   ? Theme.highlightColor
                                                                   : Theme.primaryColor) :
                        "image://theme/icon-m-up"
            anchors.centerIn: parent
        }}
    }

    Loader {
        active: !isImage
        width: parent.width
        height: parent.height
        sourceComponent: Label {
            font {
                pixelSize: Theme.fontSizeLarge
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            anchors.centerIn: parent
            text: button.text
            color: button.down ? Theme.highlightColor : Theme.primaryColor
        }
    }

}
