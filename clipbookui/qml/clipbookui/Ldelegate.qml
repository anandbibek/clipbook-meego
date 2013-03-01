// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

MouseArea {
    id: listItem
    clip: true

    property alias itemTitle: todoTitle.text
    property alias lineCount: todoTitle.maximumLineCount
    property alias date: customdate.text
    property bool newItem
    signal dragged()

    width: parent.width
    height: row.height + 32

    drag.target: listItem
    drag.axis: Drag.XAxis
    onReleased: {
        if(x>width/2) {
            x = width
            dragged()
        }
        else if(x<(-width/2)){
            x = -width
            dragged()
        }
        else
            x = 0
    }
    Behavior on x{NumberAnimation{ id : anim; easing.type: Easing.OutBack; duration: 250}}
    opacity: Math.min(1,(width-Math.abs(x))/width)

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: listItem; property: "ListView.delayRemove"; value: true }
        ParallelAnimation {
            SequentialAnimation {
                PauseAnimation { duration: 50 }
                NumberAnimation {
                    target: listItem
                    property: "height"
                    to: 0
                    duration: 200
                    easing.type: Easing.Linear
                }
            }
            NumberAnimation {
                target: listItem
                property: "opacity"
                from: 1
                to: 0
                duration: 200
                easing.type: Easing.Linear
            }
        }
        PropertyAction { target: listItem; property: "ListView.delayRemove"; value: false }
    }

    ListView.onAdd: SequentialAnimation {
        PropertyAction { target: listItem; property: "height"; value: 0 }
        ParallelAnimation {
            NumberAnimation {
                target: listItem
                property: "height"
                to: listItem.height
                duration: 200
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                target: listItem
                property: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.Linear
            }
        }
    }



    BorderImage {
        id: background
        anchors.fill: parent
        border { left: 22; top: 22; bottom: 22; right: 22 }
        visible: pressed
        source: "image://theme/meegotouch-list-fullwidth"+(theme.inverted?"-inverted":"")+"-background-pressed-center"
    }

    Image {
        width: parent.width
        anchors.bottom: parent.bottom
        opacity: theme.inverted? 0.25 : 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        source: "image://theme/meegotouch-groupheader"+(theme.inverted?"-inverted":"")+"-background"
    }

    Item{
        id: row;
        height: customcolumn.height
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16

        Image {
            id: img;
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: "icon-m-content-clipart" + (theme.inverted?"-inverse.png":".png")
        }

        Column{
            id:customcolumn
            anchors.leftMargin: 13
            spacing: 4
            anchors.right: parent.right
            anchors.left: img.right

            Label {
                id : todoTitle
                width: parent.width
                clip: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.family: "Nokia Pure Text Light"
                elide: Text.ElideRight
                maximumLineCount: 2
                font.pixelSize: 27

            }
            Label {
                id : customdate
                width: parent.width
                opacity: 0.50
                font.pixelSize: 20
                font.family: "Nokia Pure Text Light"
            }
        }

    }
}

