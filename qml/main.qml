import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow
{
    id: app

    initialPage: Component { MainPage { firstTime: true } }
    cover: undefined

    property var bgColor: "black"
}
