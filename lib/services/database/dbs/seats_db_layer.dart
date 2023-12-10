import 'package:pleyona_app/models/seat_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/passenger/passenger.dart';
import '../db_provider.dart';


class SeatsDBLayer {

  Future<void> initializeSeats(List<Seat> s) async {
    final db = await DBProvider.db.database;
    final Batch batch = db.batch();
    for (var seat in s) {
      batch.insert('seat', {
        'cabinNumber': seat.cabinNumber,
        'place_number': seat.placeNumber,
        'deck': seat.deck,
        'side': seat.side,
        'barcode': seat.barcode,
        'class_seat': seat.seatClass,
        'status': seat.status,
        'comments': seat.comment
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<Seat>> getAvailableSeats(int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM seat WHERE seat.id NOT IN '
              'SELECT * FROM passenger WHERE passenger.trip_id = "$tripId"'
      );
      print(res);
      return res.map((el) => Seat.fromJson(el)).toList();
    });
  }

  Future<Passenger> findPassengerById(int id) async {
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

}