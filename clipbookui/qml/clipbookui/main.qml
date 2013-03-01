import QtQuick 1.1
import com.nokia.meego 1.1
import GConf 1.0

PageStackWindow {

    id: window
    showToolBar: true
    showStatusBar: screen.currentOrientation === Screen.Portrait ||
                   screen.currentOrientation === Screen.InvertedPortrait
    Component.onCompleted: {
        if(autoRun.value) {
            clippie.startDaemon()
        }
        else
            clippie.killDaemon()
        theme.inverted = themeSetting.value
        pageStack.push(mainPage)
    }


    MainPage{
        id : mainPage
    }

    WorkerScript{
        id: worker1
        source: "storage.js"
    }

    GConfItem {
       id: themeSetting
       key: "/apps/clipbook/settings/themeSetting"
       defaultValue: 0
    }
    GConfItem {
       id: filePath
       key: "/apps/clipbook/settings/filePath"
       defaultValue: "/home/user/MyDocs/Documents/clipbook.txt"
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

}
