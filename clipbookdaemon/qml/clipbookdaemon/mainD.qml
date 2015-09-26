import QtQuick 1.1
import GConf 1.0

Item {
    property string memory : ""
    property bool running : false

    Component.onCompleted: {
        if(!(autoRun.value)){
            console.log("Auto Exiting...");
            clippie.suicide();
        }
        else {
            console.log("Daemon started");
            initialise();
            running = true;
            operate();
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
    GConfItem {
        id: feedEnabled
        key: "/apps/ControlPanel/clipbook/feed"
        defaultValue: true
     }
    Connections{
        target: clippie
        onTextChanged : operate();
    }
    WorkerScript{
        id : worker
        source: "storageD.js"
    }

    function operate(){
        if(running){
            var data = clippie.text
            if(data !== "" && data !== memory){
                worker.sendMessage(data)
                memory = data;
                if(feedEnabled.value==true)
                    clippie.publishFeed();
            }
            if(persistSetting.value){
                if(data  === "" && memory != "") {
                    console.log("Persist via daemon :: " + memory)
                    clippie.setText(memory);
                }
            }
        }
    }

    function initialise(){
        var _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);
        _db.transaction(
                    function(tx){
                        tx.executeSql("CREATE TABLE IF NOT EXISTS clip (title MEMO UNIQUE, modified TEXT, id TEXT)");
                    }
                    )
    }

//    function insert(){
//        var _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);
//        _db.transaction(
//                    function(tx){
//                        tx.executeSql("INSERT OR REPLACE INTO clip (title, modified, id) VALUES(?,?,?)",
//                                      [clippie.text, Qt.formatDateTime(new Date(),("d MMM yyyy h:mm AP")), Qt.formatDateTime(new Date(), ("yyyyMMddhhmmss")) ]);
//                    }
//                    )
//    }

}
