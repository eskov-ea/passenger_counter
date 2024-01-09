import '../../../models/trip_model.dart';
import '../db_provider.dart';


class TripDBLayer {

  Future<List<Trip>> getTrips() async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip'
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

  Future<List<Trip>> searchTripsByDate(DateTime date) async {
    final db = await DBProvider.db.database;
    final DateTime dateRange = date.add(Duration(days: 1));
    print("SEARCH:::::: \r\n $date \r\n $dateRange");
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM trip WHERE start_trip BETWEEN "$date" and "$dateRange" '
          'ORDER BY updated_at ASC'
      );
      print(res);
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

}