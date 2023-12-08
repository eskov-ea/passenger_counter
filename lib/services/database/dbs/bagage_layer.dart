import 'package:pleyona_app/models/passenger/passenger_bagage.dart';
import '../db_provider.dart';


class BagageDBLayer {

  Future<int> addPassengerBagage(PassengerBagage b) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO passenger_bagage(passenger_id, weight) VALUES(?, ?)',
          [b.passengerId, b.weight]
      );
      return id;
    });
  }

  Future<List<PassengerBagage>> getPassengerBagage(int passengerId) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      List<Object> res = await txn.rawQuery(
          'SELECT * FROM passenger_bagage WHERE passenger_id="$passengerId"'
      );
      print(res);
      return res.map((el) => PassengerBagage.fromJson(el)).toList();
    });
  }


}