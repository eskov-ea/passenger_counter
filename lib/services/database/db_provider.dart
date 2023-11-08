import 'package:pleyona_app/models/passanger_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


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
        await db.execute(
          'CREATE TABLE person (id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'firstname varchar(255) DEFAULT NULL, '
          'lastname varchar(255) DEFAULT NULL, '
          'middlename varchar(255) DEFAULT NULL,'
          'birthdate varchar(16) DEFAULT NULL,'
          'phone varchar(100) DEFAULT NULL,'
          'email varchar(160) DEFAULT NULL,'
          'passport varchar(255) DEFAULT NULL,'
          'citizenship varchar(100) DEFAULT NULL,'
          'status TINYINT(1) DEFAULT NULL,'
          'created_at DATE DEFAULT (datetime(${DateTime.now()})),'
          'updated_at DATE DEFAULT (datetime(${DateTime.now()})),'
          'deleted_at DATE DEFAULT NULL)'
        );
      },
      onOpen: (db) {  }
    );
  }

  addPerson(Person p) async {
    await _database!.transaction((txn) async {
      int id = await txn.rawInsert(
        'INSERT INTO person(firstname, lastname, middlename, birthdate, phone, email, passport, citizenship, status)'
        'VALUES(${p.firstname}, ${p.lastname}, ${p.middlename}, ${p.birthdate}, ${p.phone}, ${p.email}, '
        '${p.passportSerialNumber}${p.passportNumber}, ${p.citizenship}, ${p.status})'
      );
      return id;
    });
  }
}