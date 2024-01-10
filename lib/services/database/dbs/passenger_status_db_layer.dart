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

  Future<List<PassengerStatus>> getPassengerStatuses(int passengerId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger_status WHERE passenger_id = $passengerId'
      );
      log('getPassengerStatuses' + res.toString());
      return res.map((el) => PassengerStatus.fromJson(el)).toList();
    });
  }

  Future<int> addPassengerStatus(int passengerId, String? statusName) async {
    final db = await DBProvider.db.database;
    final status = statusName ?? 'CheckIn';
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO passenger_status(passenger_id, status) VALUES(?, ?)',
          [passengerId, status]
      );
      return id;
    });
  }

  // /'SELECT * FROM passenger_status LEFT JOIN '
  // 'passenger ON passenger_status.passenger_id = passenger.id '
  // 'WHERE passenger.id IN '
  // '(SELECT passenger.id FROM passenger WHERE passenger.trip_id = $tripId) '
  // 'AND passenger_status.status = $statusName'

}