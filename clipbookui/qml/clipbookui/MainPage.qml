import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import "reader.js" as Reader

Page {
    id: mainPage
    property string memory : ""
    property bool running : false

    function defaultItem(){
        return {
            title: "",
            modified: Qt.formatDateTime(new Date(),("d MMM yyyy h:mm AP")),
            arg: ""
        }
    }

    function operate(){
        if(running){
            var data = clippie.text;
            if(data !== "" && data !== memory){

                var item = defaultItem();
                item.title = data;
                item.arg = "insert";

                itemModel1.insert(0,item);

                if(!autoRun.value) {
                    worker1.sendMessage(item);

                    if(feedEnabled.value==true) {
                        clippie.publishFeed();
                    }
                }

                memory = data
            }
            if(persistSetting.value && !autoRun.value){
                if(data  === "" && memory !== "") {
                    console.log("Ping")
                    clippie.setText(memory);
                    if(clippie.text===""){
                        console.log("STUCK")
                        //clippie.setText("...");
                        //clippie.setText(memory);
                    }
                }
            }
        }
    }

    function initializer(){

        Reader.openDB();
        Reader.readBoard();

        if(itemView1.count>0)
            memory = itemModel1.get(0).title

        running = true
        operate()
    }

    Connections{
        target: clippie
        onTextChanged : operate()
    }


    QueryDialog{
        id:dialog
        titleText: "ClipBook 2.1"
        acceptButtonText: "Copy"
        rejectButtonText: "Close"
        onAccepted: {
            memory = message

            banner.text = "Copied to Clipboard"
            banner.show()

            clippie.setText(message)
        }
    }


    tools: ToolBarLayout {
        id: toolBarLayout
        TabButton{
            text : checked? "Background ON" : "Background OFF"
            checkable: true
            style: TabButtonStyle{
                checkedBackground: background
            }

            checked: autoRun.value
            iconSource: "image://theme/icon-m-toolbar-mediacontrol-" + (checked? "pause" : "play") + (theme.inverted? "-white" : "")
            onClicked: {
                privatePressed()
                autoRun.value = (checked)*1

                if(checked)
                    clippie.startDaemon()
                else
                    clippie.killDaemon()
            }
        }
        ToolIcon{
            iconId: "toolbar-view-menu"
            onClicked: mainMenu.open()
        }
    }

    ContextMenu {
        id: contextMenu
        property string title
        property string id
        property int index1


        MenuLayout {
            MenuItem {
                id: mitem
                text: "View"
                onClicked: {
                    dialog.message = contextMenu.title
                    dialog.open()
                }
            }
            MenuItem {
                text: "Copy"
                onClicked: {
                    memory = contextMenu.title

                    clippie.setText(contextMenu.title)

                    banner.text = "Copied to Clipboard"
                    banner.show()
                }
            }
            MenuItem {
                text: "Write to text file"
                onClicked: {
                    clippie.writeToFile(contextMenu.title, "/home/user/MyDocs/Documents/clipbook.txt")
                    banner.text = "written to Documents/Clipbook.txt"
                    banner.show()
                }
            }
            MenuItem {
                text: "Delete"
                onClicked: {
                    itemModel1.remove(contextMenu.index1)
                    var item = defaultItem()
                    item.title = contextMenu.title
                    item.arg = "delete"
                    if(memory === contextMenu.title)
                        memory = ""
                    worker1.sendMessage(item)
                }
            }
        }
    }

    Menu {
        onStatusChanged: {
            switch2.checked = themeSetting.value
            switch3.checked = persistSetting.value
            switch4.checked = feedEnabled.value
        }
        id: mainMenu
        content: MenuLayout {

            MenuItem {
                CheckBox {
                    id: switch2
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        themeSetting.value = (switch2.checked)*1
                        theme.inverted = switch2.checked
                    }
                }
                text: "Dark theme"
                onClicked: {
                    switch2.checked=!switch2.checked
                    themeSetting.value = (switch2.checked)*1
                    theme.inverted = switch2.checked
                }
            }
            MenuItem {
                CheckBox {
                    id: switch4
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        feedEnabled.value = (switch4.checked)
                    }
                }
                text: "Publish to feed"
                onClicked: {
                    switch4.checked=!switch4.checked
                    feedEnabled.value = (switch4.checked)
                }
            }
            MenuItem {
                CheckBox {
                    id: switch3
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        persistSetting.value = (switch3.checked)*1
                    }
                }
                text: "Persist data in clipboard"
                onClicked: {
                    switch3.checked=!switch3.checked
                    persistSetting.value = (switch3.checked)*1
                }
            }

            MenuItem {
                text: "Clear all cache"
                onClicked: {
                    itemModel1.clear()
                    var item = defaultItem()
                    item.arg = "drop"
                    worker1.sendMessage(item)
                }
            }
            MenuItem {
                text: "About"
                onClicked: {
                    dialog.message = "A clipboard history manager.\n"
                            + "Clipbook stores all the text items you cut and "
                            + "copied by your phone's default clipboard"
                            + "\n\nItem actions:\nCopy : Long press\nDelete : Swipe."
                            + "\n\nKeeping \"Background ON\" will allow app to autostart"
                            + " on device boot and monitor changes in clipboard even when app is not running"
                            + "\n\nDeveloped by @Anand_Bibek\nhttp://theweekendcoder.blogspot.com"
                    dialog.open()
                }
            }
        }
    }

    Item {
        id: item1
        anchors.fill: parent


        ListModel {
            id: itemModel1
        }

        ListView {
            id:  itemView1
            anchors.top: listheading1.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            clip: true

            model: itemModel1
            delegate: Ldelegate{
                id: todoItemDelegate1
                itemTitle: model.title
                date: model.modified

                onClicked: {

                    itemView1.currentIndex = index

                    contextMenu.index1 = itemView1.currentIndex
                    contextMenu.title = model.title
                    contextMenu.open()
                }

                onDragged: {
                    var item = defaultItem()
                    item.title = model.title
                    item.arg = "delete"
                    worker1.sendMessage(item)
                    if(memory === model.title)
                        memory = ""
                    itemModel1.remove(index)
                }

                onPressAndHold: {
                    memory = model.title
                    clippie.setText(model.title)

                    banner.text = "Copied to Clipboard"
                    banner.show()
                }


            }

            Label{
                visible: itemView1.count==0
                opacity: 0.30
                text: "No entries yet"
                anchors.centerIn: parent
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 50
            }
        }

        ViewHeader{
            id : listheading1
        }
        InfoBanner {
            id:banner
            iconSource: "icon-m-content-clipart-inverse.png"
        }
    }
}
