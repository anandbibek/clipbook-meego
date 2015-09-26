.pragma library

WorkerScript.onMessage = function(item) {

            var _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);
            var dateTime = new Date()
            _db.transaction(
                        function(tx){
                            tx.executeSql("INSERT OR REPLACE INTO clip (title, modified, id) VALUES(?,?,?)",
                                          [item, Qt.formatDateTime(dateTime,("d MMM yyyy h:mm AP")), Qt.formatDateTime(dateTime, ("yyyyMMddhhmmss")) ]);
                        }
                        )

       }
