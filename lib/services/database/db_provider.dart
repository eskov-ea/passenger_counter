import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/route_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dbs/tables.dart';


String dateFormatter(DateTime date) {
  return "${date.day}.${date.month}.${date.year}";
}



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
        'INSERT INTO person(firstname, lastname, middlename, gender, birthdate, phone, email, citizenship, class_person, comment, photo, created_at, updated_at) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [p.firstname, p.lastname, p.middlename, p.gender, p.birthdate, p.phone, p.email, p.citizenship, p.personClass, p.comment, p.photo, p.createdAt, p.updatedAt]
      );
      return id;
    });
  }

  Future<List<Person>> getPersons() async {
    final db = await database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
        'SELECT * FROM person'
      );
      print(res);
      return res.map((el) => Person.fromJson(el)).toList();
    });
  }

  Future<List<Person>> findPerson({
    required String lastname, String? firstname, String? middlename, String? birthdate
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM person WHERE lastname = '$lastname'";
      if (firstname != null) sql += ", firstname = '$firstname'";
      if (middlename != null) sql += ", firstname = '$middlename'";
      if (birthdate != null) sql += ", firstname = '$birthdate'";

      final res = await txn.rawQuery(sql);
      return res.map((el) => Person.fromJson(el)).toList();
    });
  }

  Future updatePersonsContactInformation({
    required int id, required String phone, required String email
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      String sql = "UPDATE person SET phone = '$phone', email = '$email' WHERE id = '$id'";
      return await txn.rawUpdate(sql);
    });
  }

  Future updatePerson({required Person p, required String? photo}) async {
    final db = await database;
    return await db.transaction((txn) async {
      final String baseField = "UPDATE person SET "
          "lastname = '${p.lastname}', firstname = '${p.firstname}',"
          "middlename = '${p.middlename}', gender = '${p.gender}',"
          "birthdate = '${p.birthdate}', citizenship = '${p.citizenship}',"
          "phone = '${p.phone}', email = '${p.email}', comment = '${p.comment}',"
          "class_person = '${p.personClass}'";
      final String photoField = photo == null ? "" : ", photo = '$photo'";
      final String where = "WHERE id = '${p.id}';";
      final String sql = baseField + photoField + where;
      return await txn.rawUpdate(sql);
    });
  }

  /// DOCUMENTS//

  Future<int> addDocument({required PersonDocument document}) async {
    final db = await database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
        'INSERT INTO person_documents(name, description, id_person) VALUES(?, ?, ?)',
        [document.name, document.description, document.personId]
      );
      return id;
    });
  }

  Future<List<PersonDocument>> getPersonDocuments({required int personId}) async {
    final db = await database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM person_documents WHERE id_person= "$personId"'
      );
      print(res);
      return res.map((el) => PersonDocument.fromJson(el)).toList();
    });
  }

  Future<List<PersonDocument>> findPersonDocument({
    required String name, required String number
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM person_documents WHERE name = '$name', description = '$number';";

      final res = await txn.rawQuery(sql);
      return res.map((el) => PersonDocument.fromJson(el)).toList();
    });
  }


  /// TRIPS

  Future<List<TripModel>> getTrips() async {
    final db = await database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip'
      );
      print(res);
      return res.map((el) => TripModel.fromJson(el)).toList();
    });
  }

  Future<int> addTrip({required TripModel trip}) async {
    final db = await database;
    print("ADD_TRIP:::: ${trip.comment}");
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO trip(name, start_trip, end_trip, status, comments) VALUES(?, ?, ?, ?, ?)',
          [trip.tripName, trip.tripStartDate.toString(), trip.tripEndDate.toString(), trip.status, trip.comment]
      );
      return id;
    });
  }

  Future<List<TripModel>> searchTripsByDate(DateTime date) async {
    final db = await database;
    final DateTime dateRange = date.add(Duration(days: 1));
    print("SEARCH:::::: \r\n $date \r\n $dateRange");
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip WHERE start_trip BETWEEN "$date" and "$dateRange"'
      );
      print(res);
      return res.map((el) => TripModel.fromJson(el)).toList();
    });
  }

  Future updateTrip({
    required int id, required String tripName, required DateTime tripStartDate, required DateTime tripEndDate, int? status, String? comment,
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      String sqlGeneral = "UPDATE trip SET name = '$tripName', start_trip = '$tripStartDate', end_trip = '$tripEndDate'";
      String sqlStatus = status == null ? "" : ", status = '$status'";
      String sqlComment = comment == null ? "" : ", comments = '$comment'";
      String sqlWhere = " WHERE id = '$id';";
      final sql = sqlGeneral + sqlStatus + sqlComment + sqlWhere;
      return await txn.rawUpdate(sql);
    });
  }












  Future<void> DeveloperModeClearPersonTable() async {
    final db = await database;
    // await db.execute("DROP TABLE IF EXISTS person");
    await db.execute("DROP TABLE IF EXISTS trip");
    // await db.execute("DROP TABLE IF EXISTS person_documents");
  }


}



