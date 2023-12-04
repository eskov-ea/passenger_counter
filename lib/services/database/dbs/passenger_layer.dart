import '../../../models/passenger.dart';
import '../db_provider.dart';


class PersonDBLayer {

  Future<int> addPassenger(Passenger p) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO passenger(person_id, trip_id, seat_id, document, status, comments) VALUES(?, ?, ?, ?, ?, ?)',
          [p.personId,  p.tripId, p.seatId, p.document, p.status, p.comments]
      );
      return id;
    });
  }

  Future<List<Passenger>> getPassengers(int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger WHERE trip_id="$tripId"'
      );
      print(res);
      return res.map((el) => Passenger.fromJson(el)).toList();
    });
  }

  Future<Passenger> findPassengerById({required int id}) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM passenger WHERE id = '$id'";
      final res = await txn.rawQuery(sql);
      return Passenger.fromJson(res.first);
    });
  }

  Future<int> updatePassenger({required Passenger p}) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "UPDATE passenger SET "
          "person_id = '${p.personId}', trip_id = '${p.tripId}', "
          "seat_id = '${p.seatId}', document = '${p.document}', "
          "status = '${p.status}', comments = '${p.comments}' "
          "WHERE id = '${p.id}'";
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