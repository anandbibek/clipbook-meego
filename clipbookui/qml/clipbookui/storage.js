.pragma library

WorkerScript.onMessage = function(item)
{

            var _db;
                _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);

            if(item.arg === "insert"){
                _db.transaction(
                            function(tx){
                                tx.executeSql("INSERT OR REPLACE INTO clip (title, modified, id) VALUES(?,?,?)",
                                              [item.title, Qt.formatDateTime(new Date(),("d MMM yyyy h:mm AP")), Qt.formatDateTime(new Date(), ("yyyyMMddhhmmss")) ]);
                            }
                            )
            }

            if(item.arg === "delete"){
                _db.transaction(
                            function(tx){
                                tx.executeSql("DELETE FROM clip WHERE title = ?", [item.title]);
                            }
                            )
            }

            if(item.arg === "drop"){
                _db.transaction(
                            function(tx){
                                tx.executeSql("DROP TABLE IF EXISTS clip");
                            }
                            )
            }


    
}
