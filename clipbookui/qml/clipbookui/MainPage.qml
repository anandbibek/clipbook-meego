import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
//import "reader.js" as Reader

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
            if(clippie.text !== "" && clippie.text !== memory){

                var item = defaultItem()
                item.title = clippie.text

                itemModel1.insert(0,item)
                //console.log("inserted " + item.title)

                if(!autoRun.value)
                    clippie.writeToDatabase(clippie.text)

                memory = clippie.text
            }
            if(persistSetting.value){
                if(clippie.text  === "" && memory !== "")
                    clippie.setText(memory)
            }
        }
    }

    function initializer(){

        if(itemView1.count>0)
        memory = itemModel1.get(0).title

        running = true
        operate()
    }

    Connections{
        target: clippie
        onTextChanged : operate()
        onReadFinished : initializer()
        onEntryChanged : {
            itemModel1.append({"title" : clippie.entry, "modified" : clippie.date})
        }
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
                    clippie.writeToFile(contextMenu.title, filePath.value)
                    banner.text = "written to Documents/Clipbook.txt" //+ filePath.value
                    banner.show()
                }
            }
            MenuItem {
                text: "Delete"
                onClicked: {
                    itemModel1.remove(contextMenu.index1)
                    clippie.deleteDB(contextMenu.title)
                }
            }
        }
    }

    Menu {
        onStatusChanged: {
            switch2.checked = themeSetting.value
            switch3.checked = persistSetting.value
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
                    clippie.dropDB()
                    itemModel1.clear()
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
                    itemModel1.remove(index)
                    clippie.deleteDB(model.title)
                }

                onPressAndHold: {
                    memory = model.title
                    clippie.setText(model.title)

                    banner.text = "Copied to Clipboard"
                    banner.show()
                }
            }
        }

        ViewHeader{
            id : listheading1
        }
        InfoBanner {
            id:banner
        }
    }
}
