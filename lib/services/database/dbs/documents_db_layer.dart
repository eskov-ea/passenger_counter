import 'package:sqflite/sqflite.dart';
import '../../../models/person_model.dart';
import '../db_provider.dart';


class DocumentsDBLayer {

  Future<int> addDocument(PersonDocument document) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO person_documents(name, description, id_person) VALUES(?, ?, ?)',
          [document.name, document.description, document.personId]
      );
      return id;
    });
  }

  Future<List<PersonDocument>> getPersonDocuments(int personId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM person_documents WHERE id_person= "$personId"'
      );
      return res.map((el) => PersonDocument.fromJson(el)).toList();
    });
  }

  Future<List<PersonDocument>> findPersonDocument(String name, String number) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM person_documents WHERE name = '$name', description = '$number';";

      final res = await txn.rawQuery(sql);
      return res.map((el) => PersonDocument.fromJson(el)).toList();
    });
  }

}