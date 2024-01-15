import 'dart:developer';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:sqflite/sqflite.dart';
import '../db_provider.dart';


class PassengerStatusDBLayer {

  Future<void> initializePassengerStatusValues(List<PassengerStatusValue> statuses) async {
    final db = await DBProvider.db.database;
    final Batch batch = db.batch();
    for (var status in statuses) {
      batch.insert('passenger_status_list', {
        'status': status.statusName,
        'seq': status.seq
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<PassengerStatusValue>> getAvailableStatuses() async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger_status_list'
      );
      print(res);
      return res.map((el) => PassengerStatusValue.fromJson(el)).toList();
    });
  }

  Future<List<Passenger>> getPassengersByStatusName(int tripId, String statusName) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
        'SELECT * FROM passenger_status LEFT JOIN '
        'passenger ON passenger_status.passenger_id = passenger.id '
        'WHERE passenger.id IN '
        '(SELECT passenger.id FROM passenger WHERE passenger.trip_id = $tripId) '
      );
      log('getPassengersByStatusName' + res.toString());
      return res.map((el) => Passenger.fromJson(el)).toList();
    });
  }

  Future<List<Passenger>> getPassengersWithoutCurrentStatus(int tripId, String statusName) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
        'SELECT * FROM passenger as p '
        ' LEFT JOIN ('
            'SELECT MAX(id) as status_id, passenger_id, deleted_at, status as statusName '
            'FROM passenger_status WHERE deleted_at IS NULL GROUP BY passenger_id'
        ') as s ON s.passenger_id = p.id '
        'WHERE p.trip_id = $tripId AND p.deleted_at IS NULL '
        'AND s.statusName != "$statusName" AND s.statusName != "CheckOut" '
      );
      log('getPassengersByStatusName \n\r'  + res.toString() + '\n\r length: ${res.length}');
      return res.map((el) => Passenger.fromJson(el)).toList();
    });
  }

  Future<List<PassengerStatus>> getPassengerStatuses(int passengerId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger_status '
          'WHERE passenger_id = $passengerId AND deleted_at IS NULL '
          'ORDER BY created_at DESC '
      );
      log('getPassengerStatuses' + res.toString());
      return res.map((el) => PassengerStatus.fromJson(el)).toList();
    });
  }

  Future<PassengerStatus> addPassengerStatus(int passengerId, String? statusName) async {
    final db = await DBProvider.db.database;
    final status = statusName ?? 'CheckIn';
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO passenger_status(passenger_id, status) VALUES(?, ?)',
          [passengerId, status]
      );
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger_status WHERE id = $id'
      );
      return PassengerStatus.fromJson(res.first);
    });
  }

  Future<void> deletePassengerStatus(int statusId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE passenger_status SET deleted_at = CURRENT_TIMESTAMP WHERE id = $statusId '
      );
    });
  }

  // 'SELECT * FROM passenger WHERE trip_id = $tripId AND deleted_at IS NULL '
  // 'AND id IN ('
  // ' SELECT passenger_id FROM passenger_status WHERE deleted_at IS NULL '
  // ' GROUP BY passenger_id ORDER BY created_at DESC '
  // ') '

  // /'SELECT * FROM passenger_status LEFT JOIN '
  // 'passenger ON passenger_status.passenger_id = passenger.id '
  // 'WHERE passenger.id IN '
  // '(SELECT passenger.id FROM passenger WHERE passenger.trip_id = $tripId) '
  // 'AND passenger_status.status = $statusName'


  // 'SELECT  * FROM passenger LEFT JOIN passenger_status '
  // 'ON passenger_status.passenger_id = passenger.id '
  // 'WHERE trip_id = $tripId AND passenger_status.deleted_at IS NULL AND passenger.deleted_at IS NULL '
  // 'GROUP BY passenger_status.status ORDER BY passenger_status.created_at DESC '
}