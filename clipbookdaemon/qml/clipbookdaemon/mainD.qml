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
            console.log("Daemon started")
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
                clippie.writeToDatabase(clippie.text)
                memory = clippie.text
            }
            if(persistSetting.value){
                if(clippie.text  === "" && memory != "")
                    clippie.setText(memory)
            }
        }
    }

}
