import 'package:flutter/services.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/services/database/db_provider.dart';

class StatusAPIProvider {
  final DBProvider _db = DBProvider.db;

  Future<PassengerStatus> saveStatus({
    required int passengerId, required String statusName,
  }) async {
    try {
      return await _db.addPassengerStatus(passengerId: passengerId, statusName: statusName);
    } catch (err, stackTrace) {
      rethrow;
    }
  }

  Future<void> deleteStatus({required int statusId}) async {
    try {
      await _db.deletePassengerStatus(statusId: statusId);
    } catch (err, stackTrace) {
      rethrow;
    }
  }

}