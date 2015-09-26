var _db;

function openDB()
{
    _db = openDatabaseSync("ClipDB2","1.0","ClipBoard Database",1000000);
    createTable();
}

function createTable()
{
    _db.transaction(
                function(tx){
                    tx.executeSql("CREATE TABLE IF NOT EXISTS clip (title MEMO UNIQUE, modified TEXT, id TEXT)");
                }
                )
}

function readBoard()
{
    _db.readTransaction(
                function(tx){
                    var rs = tx.executeSql("SELECT * FROM clip ORDER BY id DESC");
                    for (var i=0; i< rs.rows.length; i++) {
                        itemModel1.append(rs.rows.item(i))
                    }

                }
                )
}
