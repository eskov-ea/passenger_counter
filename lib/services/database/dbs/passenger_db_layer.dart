import '../../../models/passenger/passenger.dart';
import '../db_provider.dart';


class PassengerDBLayer {

  Future<int> addPassenger(Passenger p) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO passenger(person_id, trip_id, seat_id, person_document_id, status, comments) VALUES(?, ?, ?, ?, ?, ?)',
          [p.personId,  p.tripId, p.seatId, p.personDocumentId, p.status, p.comments]
      );
      return id;
    });
  }

  Future<List<Passenger>> getPassengers(int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger WHERE trip_id="$tripId" AND deleted_at IS NULL '
      );
      return res.map((el) => Passenger.fromJson(el)).toList();
    });
  }

  Future<Passenger> findPassengerById(int id) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "SELECT * FROM passenger WHERE id = $id AND deleted_at IS NULL";
      final res = await txn.rawQuery(sql);
      return Passenger.fromJson(res.first);
    });
  }

  Future<int> updatePassenger({required Passenger p}) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "UPDATE passenger SET "
          "person_id = '${p.personId}', trip_id = '${p.tripId}', "
          "seat_id = '${p.seatId}', document = '${p.personDocumentId}', "
          "status = '${p.status}', comments = '${p.comments}' "
          "WHERE id = '${p.id}'";
      return await txn.rawUpdate(sql);
    });
  }

  Future<int> changePassengerSeat(int passengerId, int seatId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sql = "UPDATE passenger SET "
          "seat_id = '$seatId', "
          "updated_at = CURRENT_TIMESTAMP "
          "WHERE id = '$passengerId' AND deleted_at IS NULL;";
      return await txn.rawUpdate(sql);
    });
  }

  Future<Passenger?> checkIfPersonRegisteredOnTrip(int personId, int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      final res = await txn.rawQuery(
          "SELECT * FROM passenger WHERE "
          "person_id = '$personId' AND trip_id = '$tripId' AND deleted_at IS NULL;"
      );
      return res.isEmpty ? null : Passenger.fromJson(res.first);
    });
  }

  Future<Passenger?> getPassengerByBarcode(String barcode, int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      final res = await txn.rawQuery(
          "SELECT * FROM passenger WHERE "
              "trip_id = '$tripId' AND "
              "seat_id = ( SELECT id FROM seat WHERE id IN (SELECT seat_id FROM trip "
              "WHERE id = '$tripId') AND barcode = '$barcode' ); "
      );
      return res.isEmpty ? null : Passenger.fromJson(res.first);
    });
  }


  Future<void> deletePassenger(int passengerId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE passenger SET deleted_at = CURRENT_TIMESTAMP WHERE id = $passengerId '
      );
      await txn.rawUpdate(
          'UPDATE passenger_status SET deleted_at = CURRENT_TIMESTAMP WHERE passenger_id = $passengerId '
      );
      await txn.rawUpdate(
          'UPDATE passenger_bagage SET deleted_at = CURRENT_TIMESTAMP WHERE passenger_id = $passengerId '
      );
      await txn.rawUpdate(
          'UPDATE passenger_bagage SET deleted_at = CURRENT_TIMESTAMP WHERE passenger_id = $passengerId '
      );
    });
  }



}