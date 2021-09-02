import QtQuick 2.0

Item {
    id: kbd

    height: column.height
    width: parent.width

    property double keyHeight: keyWidth / 2 * 3
    property double keyWidth: width / _nKeysPerRow

    // public signals
    signal backspace()         // on backspace
    signal clicked(string txt) // on accepted key
    signal enter()             // on Enter

    // private properties
    property int    _nKeysPerRow: 10 // max keys per row
    property int    _shift:       0  // tri-state: lower, autocaps, capslock
    property bool   _symbols:     false

    Column {
        id: column
        anchors.bottom: kbd.bottom
        width: parent.width

        Row { // 1234567890
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: [
                    {text: '1'},
                    {text: '2'},
                    {text: '3'},
                    {text: '4'},
                    {text: '5'},
                    {text: '6'},
                    {text: '7'},
                    {text: '8'},
                    {text: '9'},
                    {text: '0'},
                ]

                delegate: Key {
                    height: keyHeight
                    width: keyWidth
                    text: modelData.text
                    onClicked: kbd.process(text)
                }
            }
        }

        Row { // qwertyuiop
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: [
                    {text: 'q', symbol: '!'},
                    {text: 'w', symbol: '@'},
                    {text: 'e', symbol: '#'},
                    {text: 'r', symbol: '$'},
                    {text: 't', symbol: '%'},
                    {text: 'y', symbol: '^'},
                    {text: 'u', symbol: '&'},
                    {text: 'i', symbol: '*'},
                    {text: 'o', symbol: '('},
                    {text: 'p', symbol: ')'},
                ]

                delegate: Key {
                    height: keyHeight
                    width: keyWidth
                    text: _symbols? modelData.symbol: _shift? modelData.text.toUpperCase():  modelData.text
                    onClicked: kbd.process(text)
                }
            }
        }

        Row { // asdfghjkl
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: [
                    {text: 'a', symbol: '~'},
                    {text: 's', symbol: '['},
                    {text: 'd', symbol: ']'},
                    {text: 'f', symbol: '|'},
                    {text: 'g', symbol: '-'},
                    {text: 'h', symbol: '+'},
                    {text: 'j', symbol: '_'},
                    {text: 'k', symbol: '='},
                    {text: 'l', symbol: '\\'},
                ]

                delegate: Key {
                    height: keyHeight
                    width: keyWidth
                    text: _symbols? modelData.symbol: _shift? modelData.text.toUpperCase():  modelData.text
                    onClicked: kbd.process(text)
                }
            }
        }

        Row { // zxcvbnm
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: [
                    {text: _shift === 0 ? 'icon-m-autocaps' : _shift === 1 ? 'icon-m-autocaps' : 'icon-m-capslock',
                        symbol:  '', width: 1.5},
                    {text: 'z', symbol: '`', width: 1},
                    {text: 'x', symbol: "'", width: 1},
                    {text: 'c', symbol: '"', width: 1},
                    {text: 'v', symbol: ':', width: 1},
                    {text: 'b', symbol: ';', width: 1},
                    {text: 'n', symbol: '<', width: 1},
                    {text: 'm', symbol: '>', width: 1},
                    {text: 'icon-m-backspace', symbol: 'icon-m-backspace', width: 1.5},
                ]

                delegate: Key {
                    height: keyHeight
                    width: keyWidth * modelData.width
                    text: _symbols? modelData.symbol: _shift && modelData.width === 1 ? modelData.text.toUpperCase():  modelData.text
                    onClicked: kbd.process(text)
                }
            }
        }

        Row { // space and special
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: [
                    {text: _symbols? 'ABC': '@#', width: 2.5},
                    {text: _symbols?  '/':  ',', width: 1},
                    {text: ' ', width: 3}, // space
                    {text: _symbols?  '?':  '.', width: 1},
                    {text: 'icon-m-enter', width: 2.5},
                ]

                delegate: Key {
                    height: keyHeight
                    width: keyWidth * modelData.width
                    text: modelData.text
                    onClicked: kbd.process(text)
                }
            }
        }
    }

    function process(text) {
        if (text === 'icon-m-backspace')
            kbd.backspace()
        else if (text === 'icon-m-autocaps' || text === 'icon-m-autocaps' || text === 'icon-m-capslock')
            _shift = (_shift + 1) % 3;
        else if (text === '@#' )
            _symbols = true;
        else if (text === 'ABC'   )
            _symbols = false;
        else if (text === 'icon-m-enter')
            kbd.enter();
        else { // insert text
            kbd.clicked(text);
            if (_shift === 1)
                _shift = 0;
        }
    }
}
