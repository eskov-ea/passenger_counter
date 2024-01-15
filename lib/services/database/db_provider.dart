import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_bagage.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/services/database/dbs/bagage_db_layer.dart';
import 'package:pleyona_app/services/database/dbs/documents_db_layer.dart';
import 'package:pleyona_app/services/database/dbs/passenger_status_db_layer.dart';
import 'package:pleyona_app/services/database/dbs/person_db_layer.dart';
import 'package:pleyona_app/services/database/dbs/seats_db_layer.dart';
import 'package:pleyona_app/services/database/dbs/trip_db_layer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/passenger/passenger_status.dart';
import '../../models/seat_model.dart';
import 'dbs/passenger_db_layer.dart';
import 'dbs/tables.dart';


class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB();
      return _database!;
    }
  }


  /// DB INITIALIZE

  Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'pleyona.db');
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await createTables(db);
      },
      onOpen: (db) async {
        final List<Object> rawTables = await db.rawQuery('SELECT * FROM sqlite_master');
        final List<DBTable> existingTables = rawTables.map((el) => DBTable.fromJson(el)).toList();
        tables.forEach((k, sql) async {
          if ( !checkIfTableExists(existingTables, k) ) {
            await db.execute(sql);
            print("TABLE CREATED ::::::");
          }
        });
      }
    );
  }
  Future<void> createTables(Database db) async {
    try {
      tables.forEach((key, sql) async {
        await db.execute(sql);
      });
    } catch (err) {
      print("ERROR:DBProvider:73:: $err");
    }
  }

  /// PERSON

  Future<int> addPerson(Person p) => PersonDBLayer().addPerson(p);
  Future<List<Person>> getPersons(List<int>? ids) => PersonDBLayer().getPersons(ids);
  Future<Person> getPersonById({required int personId}) => PersonDBLayer().getPersonById(personId);
  Future<List<Person>> getPersonChildren(int personId) => PersonDBLayer().getPersonChildren(personId);
  Future<List<Person>> findPerson({
    required String lastname, String? firstname, String? middlename, String? birthdate
  }) => PersonDBLayer().findPerson(lastname: lastname, firstname: firstname, middlename: middlename, birthdate: birthdate);
  Future updatePersonsContactInformation({
    required int id, required String phone, required String email
  }) => PersonDBLayer().updatePersonsContactInformation(id: id, phone: phone, email: email);
  Future updatePerson({required Person p, required String? photo}) => PersonDBLayer().updatePerson(p: p, photo: photo);

  /// DOCUMENTS

  Future<int> addDocument({required PersonDocument document}) => DocumentsDBLayer().addDocument(document);
  Future<List<PersonDocument>> getPersonDocuments({required int personId}) => DocumentsDBLayer().getPersonDocuments(personId);
  Future<List<PersonDocument>> findPersonDocument({
    required String name, required String number
  }) => DocumentsDBLayer().findPersonDocument(name, number);


  /// TRIPS

  Future<List<Trip>> getTrips() => TripDBLayer().getTrips();
  Future<Trip> getTripById({required int tripId}) => TripDBLayer().getTripById(tripId);
  Future<int> addTrip({required Trip trip}) => TripDBLayer().addTrip(trip);
  Future<List<Trip>> searchTripsByDate({required DateTime date}) => TripDBLayer().searchTripsByDate(date);
  Future updateTrip({
    required int id, required String tripName, required DateTime tripStartDate, required DateTime tripEndDate, int? status, String? comment,
  }) => TripDBLayer().updateTrip(id, tripName, tripStartDate, tripEndDate, status, comment);


  /// PASSENGERS

  Future<int> addPassenger({required Passenger p}) => PassengerDBLayer().addPassenger(p);
  Future<List<Passenger>> getPassengers({required int tripId}) => PassengerDBLayer().getPassengers(tripId);
  Future<Passenger> findPassengerById({required int tripId}) => PassengerDBLayer().findPassengerById(tripId);
  Future<int> updatePassenger({required Passenger p}) => PassengerDBLayer().addPassenger(p);
  Future<void> deletePassenger({required int passengerId}) => PassengerDBLayer().deletePassenger(passengerId);

  /// SEAT

  Future<Seat> getPassengerSeat({required int seatId}) => SeatsDBLayer().getPassengerSeat(seatId);
  Future<List<Seat>> getAvailableSeats({required int tripId}) => SeatsDBLayer().getAvailableSeats(tripId);
  Future<void> initializeSeats({required List<Seat> s}) => SeatsDBLayer().initializeSeats(s);

  /// BAGAGE

  Future<int> addPassengerBagage({required int passengerId, required int weight}) => BagageDBLayer().addPassengerBagage(passengerId, weight);
  Future<List<PassengerBagage>> getPassengerBagage({required int passengerId}) => BagageDBLayer().getPassengerBagage(passengerId);

  /// PASSENGER STATUS
  Future<void> initializePassengerStatusValues(
      {required List<PassengerStatusValue> statuses}) => PassengerStatusDBLayer().initializePassengerStatusValues(statuses);
  Future<List<PassengerStatusValue>> getAvailableStatuses() => PassengerStatusDBLayer().getAvailableStatuses();
  Future<List<Passenger>> getPassengersByStatusName({required int tripId,
    required String statusName}) => PassengerStatusDBLayer().getPassengersByStatusName(tripId, statusName);
  Future<List<Passenger>> getPassengersWithoutCurrentStatus({required int tripId,
    required String statusName}) => PassengerStatusDBLayer().getPassengersWithoutCurrentStatus(tripId, statusName);
  Future<PassengerStatus> addPassengerStatus({required int passengerId, required String? statusName}) => PassengerStatusDBLayer().addPassengerStatus(passengerId, statusName);
  Future<List<PassengerStatus>> getPassengerStatuses({required int passengerId}) =>
      PassengerStatusDBLayer().getPassengerStatuses(passengerId);
  Future<void> deletePassengerStatus({required int statusId}) => PassengerStatusDBLayer().deletePassengerStatus(statusId);




  Future<void> DeveloperModeClearPersonTable() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS person");
    await db.execute("DROP TABLE IF EXISTS trip");
    await db.execute("DROP TABLE IF EXISTS person_documents");
    await db.execute("DROP TABLE IF EXISTS passenger");
  }


}

String dateFormatter(DateTime date) {
  return "${date.day}.${date.month}.${date.year}";
}



class DBTable {
  final String name;
  const DBTable({required this.name});
  static DBTable fromJson(json) => DBTable(name: json["name"]);
}


bool checkIfTableExists(List<DBTable> existingTables, String searchingTableName) {
  final res = existingTables.where((el) =>
  el.name == searchingTableName
  );
  return res.isEmpty ?  false : true;
}




