import '../../../models/person_model.dart';
import '../db_provider.dart';


class PersonDBLayer {

  Future<int> addPerson(Person p) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO person(firstname, lastname, middlename, gender, birthdate, phone, email, citizenship, class_person, parent_id, comment, photo, created_at, updated_at) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [p.firstname, p.lastname, p.middlename, p.gender, p.birthdate, p.phone, p.email, p.citizenship, p.personClass, p.parentId ?? 0, p.comment, p.photo, p.createdAt, p.updatedAt]
      );
      return id;
    });
  }

  Future<List<Person>> getPersons() async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM person'
      );
      print(res);
      return res.map((el) => Person.fromJson(el)).toList();
    });
  }

  Future<Person> getPersonById(int personId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM person WHERE id = $personId '
      );
      print(res);
      return Person.fromJson(res.first);
    });
  }

  Future<List<Person>> getPersonChildren(int personId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM person WHERE parent_id = $personId'
      );
      return res.map((el) => Person.fromJson(el)).toList();
    });
  }

  Future<List<Person>> findPerson({
    required String lastname, String? firstname, String? middlename, String? birthdate
  }) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM person WHERE lastname = '$lastname'";
      if (firstname != null) sql += "AND firstname = '$firstname'";
      if (middlename != null) sql += "AND middlename = '$middlename'";
      if (birthdate != null) sql += "AND birthdate = '$birthdate'";

      final res = await txn.rawQuery(sql);
      return res.map((el) => Person.fromJson(el)).toList();
    });
  }

  Future updatePersonsContactInformation({
    required int id, required String phone, required String email
  }) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "UPDATE person SET phone = '$phone', email = '$email' WHERE id = '$id'";
      return await txn.rawUpdate(sql);
    });
  }

  Future updatePerson({required Person p, required String? photo}) async {
    final db = await DBProvider.db.database;
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
}