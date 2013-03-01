import QtQuick 1.1
import GConf 1.0

Item {
    property string memory : ""
    property bool running : false

    Component.onCompleted: {
        if(!(autoRun.value)){
            console.log("Auto Exiting...")
            clippie.killDaemon()
        }
        else {
            initialise()
            running = true
            operate()
        }
    }

    GConfItem {
        id: persistSetting
        key: "/apps/clipbook/settings/persistSetting"
        defaultValue: 0
    }
    GConfItem {
        id: autoRun
        key: "/apps/clipbook/settings/autoRun"
        defaultValue: 0
    }
    Connections{
        target: clippie
        onTextChanged : operate()
    }

    function operate(){
        if(running){
            if(clippie.text !== "" && clippie.text !== memory){
                insert()
                memory = clippie.text
            }
            if(persistSetting.value){
                if(clippie.text  === "")
                    clippie.setText(memory)
            }
        }
    }

    function insert(){
        var _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);
        _db.transaction(
                    function(tx){
                        tx.executeSql("INSERT OR REPLACE INTO clip (title, modified, id) VALUES(?,?,?)",
                                      [clippie.text, Qt.formatDateTime(new Date(),("d MMM yyyy h:mm AP")), Qt.formatDateTime(new Date(), ("yyyyMMddhhmmss")) ]);
                    }
                    )
    }

    function initialise(){
        var _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);
        _db.transaction(
                    function(tx){
                        tx.executeSql("CREATE TABLE IF NOT EXISTS clip (title TEXT UNIQUE, modified TEXT, id TEXT)");
                    }
                    )
    }

}
