import 'package:pleyona_app/models/seat_model.dart';
import 'package:sqflite/sqflite.dart';
import '../db_provider.dart';


class SeatsDBLayer {

  Future<void> initializeSeats(List<Seat> s) async {
    final db = await DBProvider.db.database;
    final Batch batch = db.batch();
    for (var seat in s) {
      batch.insert('seat', {
        'cabin_number': seat.cabinNumber,
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
              '(SELECT passenger.seat_id FROM passenger '
              'WHERE passenger.trip_id = $tripId AND passenger.deleted_at IS NULL) '
      );
      print(res);
      return res.map((el) => Seat.fromJson(el)).toList();
    });
  }

  Future<List<Seat>> getOccupiedTripSeats(int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM seat WHERE seat.id IN '
              '(SELECT passenger.seat_id FROM passenger '
              'WHERE passenger.trip_id = $tripId AND passenger.deleted_at IS NULL) '
      );
      print(res);
      return res.map((el) => Seat.fromJson(el)).toList();
    });
  }

  Future<Seat> getPassengerSeat(int seatId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM seat WHERE id = $seatId '
      );
      print(res.first);
      return Seat.fromJson(res.first);
    });
  }

  Future<Seat> getParentTripSeat(int personId, int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM seat WHERE id IN '
          '( SELECT seat_id FROM passenger WHERE person_id = "$personId" AND trip_id = "$tripId" )'
      );
      print(res.first);
      return Seat.fromJson(res.first);
    });
  }

}