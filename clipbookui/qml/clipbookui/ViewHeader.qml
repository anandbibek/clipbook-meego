import QtQuick 1.1

Item{
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: (showStatusBar)
            ? 72
            : 64

    Rectangle {
        color: "#0076bc"
        anchors.fill: parent
    }
    //Rectangle { width: parent.width; height: 2; anchors.bottom: parent.bottom; color: "#000000"; visible: !theme.inverted; opacity: 0.5 }
    Rectangle { width: parent.width; height: 1; anchors.bottom: parent.bottom; color: "#ffffff"; opacity: !theme.inverted }

    Text{
        id: text2
        color: "#ffffff"
        text: "Clipboard history"
        anchors {
            top: parent.top
            bottom: parent.bottom
            topMargin: (showStatusBar)
                            ? 16
                            : 12
            bottomMargin: (showStatusBar)
                            ? 24
                            : 20
            left: parent.left
            right: parent.right
            leftMargin: 16
            rightMargin: 16
        }

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 32
        elide: Text.ElideRight
    }

    Image {
        id: image1
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "icon-m-content-clipart-inverse.png"
    }
}
