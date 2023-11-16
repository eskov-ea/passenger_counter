import 'package:intl/intl.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


String dateFormatter(DateTime date) {
  return "${date.day}.${date.month}.${date.year}";
}
final Map<String, String> tables = {
  "person_class_list" :
  'CREATE TABLE person_class_list('
        'person_class varchar(20) PRIMARY KEY NOT NULL, '
        'seq INTEGER );',

  "person" :
  'CREATE TABLE person (id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'firstname varchar(255) DEFAULT NULL, '
      'lastname varchar(255) DEFAULT NULL, '
      'middlename varchar(255) DEFAULT NULL, '
      'gender varchar(6) DEFAULT "" NOT NULL, '
      'birthdate varchar(16) DEFAULT NULL, '
      'phone varchar(100) DEFAULT NULL, '
      'email varchar(160) DEFAULT NULL, '
      'photo text DEFAULT "", '
      'citizenship varchar(100) DEFAULT NULL, '
      'class_person varchar(20) DEFAULT "Regular" REFERENCES person_class_list(person_class), '
      'comment text DEFAULT "", '
      'created_at DATE DEFAULT NULL, '
      'updated_at DATE DEFAULT NULL, '
      'deleted_at DATE DEFAULT NULL );',

};


class DBTable {
  final String name;
  const DBTable({required this.name});
  static DBTable fromJson(json) => DBTable(name: json["name"]);
}
bool checkIfTableExists(List<DBTable> existingTables, String searchingTableName) {
  final res = existingTables.where((el) =>
      el.name == searchingTableName
  );
  return res.isEmpty ?  false : true;
}



class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB();
      return _database!;
    }
  }

  Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'pleyona.db');
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await createTables(db);
      },
      onOpen: (db) async {
        final List<Object> rawTables = await db.rawQuery('SELECT * FROM sqlite_master');
        final List<DBTable> existingTables = rawTables.map((el) => DBTable.fromJson(el)).toList();
        tables.forEach((k, sql) async {
          if ( !checkIfTableExists(existingTables, k) ) {
            await db.execute(sql);
            print("TABLE CREATED ::::::");
          }
        });
      }
    );
  }

  Future<void> createTables(Database db) async {
    try {
      tables.forEach((key, sql) async {
        await db.execute(sql);
      });
    } catch (err) {
      print("ERROR:DBProvider:73:: $err");
    }
  }

  Future<int> addPerson(Person p) async {
    final db = await database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
        'INSERT INTO person(firstname, lastname, middlename, birthdate, phone, email, document, citizenship, status, created_at, updated_at) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [p.firstname, p.lastname, p.middlename, p.birthdate, p.phone, p.email, p.document, p.citizenship, p.status, p.createdAt, p.updatedAt]
      );
      return id;
    });
  }

  Future<List<Object>> getPersons() async {
    final db = await database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
        'SELECT * FROM person'
      );
      print(res);
      return res;
    });
  }

  Future<List<Map<String, Object?>>> findPerson({
    required String lastname, String? firstname, String? middlename, String? birthdate
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM person WHERE lastname = '$lastname'";
      if (firstname != null) sql += ", firstname = '$firstname'";
      if (middlename != null) sql += ", firstname = '$middlename'";
      if (birthdate != null) sql += ", firstname = '$birthdate'";

      return await txn.rawQuery(sql);
    });
  }

  Future updatePerson({
    required String id, required String document, required String phone, required String email
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      String sql = "UPDATE person SET phone = '$phone', document = '$document', email = '$email' WHERE id = '$id'";
      // String sql = "UPDATE person SET phone = '$phone', document = '$document', email = '$email' WHERE id = '$id'";
      return await txn.rawUpdate(sql);
    });
  }

  Future<void> DeveloperModeClearPersonTable() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS person");
  }


}



