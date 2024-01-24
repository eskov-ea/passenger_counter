import '../../../models/trip_model.dart';
import '../db_provider.dart';


class TripDBLayer {

  Future<List<Trip>> getTrips() async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip WHERE '
          'deleted_at IS NULL '
      );
      return res.map((el) => Trip.fromJson(el)).toList();
    });
  }

  Future<int> addTrip(Trip trip) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO trip(name, start_trip, end_trip, status, comments) VALUES(?, ?, ?, ?, ?)',
          [trip.tripName, trip.tripStartDate.toString(), trip.tripEndDate.toString(), trip.status, trip.comment]
      );
      return id;
    });
  }

  Future<Trip> getTripById(int tripId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip WHERE id = "$tripId"'
      );
      return Trip.fromJson(res.first);
    });
  }

  // Future<List<Trip>> searchTripForToday(DateTime date) async {
  //   final db = await DBProvider.db.database;
  //   final DateTime dateStart = DateTime(date.year, date.month, date.day).subtract(const Duration(minutes: 1));
  //   final DateTime dateEnd = dateStart.add(const Duration(days: 1));
  //   return await db.transaction((txn) async {
  //     List<Object> res = await txn.rawQuery(
  //         'SELECT * FROM trip WHERE start_trip BETWEEN "${dateStart.toIso8601String()}" AND "${dateEnd.toIso8601String()}" '
  //         'ORDER BY updated_at ASC'
  //     );
  //     print("searchTripForToday  $date  --  $res");
  //     return res.map((el) => Trip.fromJson(el)).toList();
  //   });
  // }

  Future<List<Trip>> searchTripForToday(DateTime date) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip WHERE "${date.toIso8601String()}" BETWEEN start_trip AND end_trip '
          'AND deleted_at IS NULL '
          'ORDER BY start_trip ASC'
      );
      return res.map((el) => Trip.fromJson(el)).toList();
    });
  }

  Future<int> updateTrip(int id, String tripName, DateTime tripStartDate,
  DateTime tripEndDate, int? status, String? comment) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      String sqlGeneral = "UPDATE trip SET name = '$tripName', start_trip = '$tripStartDate', end_trip = '$tripEndDate'";
      String sqlStatus = status == null ? "" : ", status = '$status'";
      String sqlComment = comment == null ? "" : ", comments = '$comment'";
      String sqlWhere = " WHERE id = '$id';";
      final sql = sqlGeneral + sqlStatus + sqlComment + sqlWhere;
      return await txn.rawUpdate(sql);
    });
  }

  Future<List<Trip>> searchTripByDateRange(DateTime dateStart, DateTime dateEnd) async {
    final db = await DBProvider.db.database;
    print("SEARCH:::::: \r\n $dateStart \r\n $dateEnd");
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip WHERE start_trip BETWEEN "$dateStart" and "$dateEnd" '
          'AND deleted_at IS NULL '
          'ORDER BY start_trip ASC'
      );
      return res.map((el) => Trip.fromJson(el)).toList();
    });
  }

}