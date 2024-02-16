import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_bagage.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
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
  Future addChildToPerson({required int childPersonId, required int parentPersonId}) =>
      PersonDBLayer().addChildToPerson(childPersonId, parentPersonId);
  Future removeChildFromPerson({required int childPersonId}) =>
      PersonDBLayer().removeChildFromPerson(childPersonId);

  /// DOCUMENTS

  Future<int> addDocument({required PersonDocument document}) => DocumentsDBLayer().addDocument(document);
  Future<List<PersonDocument>> getPersonDocuments({required int personId}) => DocumentsDBLayer().getPersonDocuments(personId);
  Future<List<PersonDocument>> findPersonDocument({
    required String name, required String number
  }) => DocumentsDBLayer().findPersonDocument(name, number);
  Future<PersonDocument> getPersonDocumentById({required int documentId}) => DocumentsDBLayer().getPersonDocumentById(documentId);

  /// TRIPS

  Future<List<Trip>> getTrips() => TripDBLayer().getTrips();
  Future<Trip> getTripById({required int tripId}) => TripDBLayer().getTripById(tripId);
  Future<int> addTrip({required Trip trip}) => TripDBLayer().addTrip(trip);
  Future<List<Trip>> searchTripForToday({required DateTime date}) => TripDBLayer().searchTripForToday(date);
  Future updateTrip({
    required int id, required String tripName, required DateTime tripStartDate, required DateTime tripEndDate, int? status, String? comment,
  }) => TripDBLayer().updateTrip(id, tripName, tripStartDate, tripEndDate, status, comment);
  Future<List<Trip>> searchTripByDateRange({required DateTime dateStart,
    required DateTime dateEnd}) => TripDBLayer().searchTripByDateRange(dateStart, dateEnd);

  /// PASSENGERS

  Future<int> addPassenger({required Passenger p}) => PassengerDBLayer().addPassenger(p);
  Future<List<Passenger>> getPassengers({required int tripId}) => PassengerDBLayer().getPassengers(tripId);
  Future<Passenger> findPassengerById({required int tripId}) => PassengerDBLayer().findPassengerById(tripId);
  Future<int> updatePassenger({required Passenger p}) => PassengerDBLayer().addPassenger(p);
  Future<void> deletePassenger({required int passengerId}) => PassengerDBLayer().deletePassenger(passengerId);
  Future<int> changePassengerSeat({required int passengerId, required int seatId}) => PassengerDBLayer().changePassengerSeat(passengerId, seatId);
  Future<Passenger?> checkIfPersonRegisteredOnTrip({required int personId, required int tripId}) => PassengerDBLayer().checkIfPersonRegisteredOnTrip(personId, tripId);
  Future<Passenger?> getPassengerByBarcode({required String barcode, required int tripId}) => PassengerDBLayer().getPassengerByBarcode(barcode, tripId);

  /// SEAT

  Future<Seat> getPassengerSeat({required int seatId}) => SeatsDBLayer().getPassengerSeat(seatId);
  Future<List<Seat>> getAvailableSeats({required int tripId}) => SeatsDBLayer().getAvailableSeats(tripId);
  Future<List<Seat>> getOccupiedTripSeats({required int tripId}) => SeatsDBLayer().getOccupiedTripSeats(tripId);
  Future<void> initializeSeats({required List<Seat> s}) => SeatsDBLayer().initializeSeats(s);
  Future<Seat?> getParentTripSeat({required int personId, required int tripId}) => SeatsDBLayer().getParentTripSeat(personId, tripId);
  Future<bool> checkSeatsInitialized() => SeatsDBLayer().checkSeatsInitialized();
  Future<List<Seat>> getSeats() => SeatsDBLayer().getSeats();
  Future<int> changeSeatStatus({required int status, required List<int> ids}) => SeatsDBLayer().changeSeatStatus(status, ids);

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
  Future<bool> checkStatusValuesInitialized() => PassengerStatusDBLayer().checkStatusValuesInitialized();


  /// PASSENGERS PERSON SEATS
  Future<List<PassengerPerson>> getTripPassengersInfo({required int tripId}) async {
    final db = await DBProvider.db.database;
    return await db.transaction((txn) async {
      final res = await txn.rawQuery(
          "SELECT p.id, p.person_id, p.trip_id, seat_id, p.person_document_id, p.status, p.comments, p.created_at, p.updated_at, "
          "person.id as p_id, person.firstname, person.lastname, person.middlename, person.gender, person.birthdate, person.phone, person.email, person.photo, person.citizenship, person.class_person, person.parent_id, "
          "seat.id as seat_id, seat.cabin_number, seat.place_number, seat.deck, seat.side, seat.barcode, seat.class_seat, seat.status as seat_status, seat.comments as seat_comment, "
          "doc.name, doc.description, doc.id_person,s.id as s_id, s.passenger_id, s.status as s_status, s.created_at as s_created_at "
          "FROM passenger p "
          "JOIN person ON (p.person_id = person.id) "
          "JOIN seat ON (p.seat_id = seat.id) "
          "JOIN person_documents doc ON (p.person_document_id = doc.id) "
          "JOIN passenger_status s ON (p.id = s.passenger_id) "
          "WHERE trip_id = '$tripId' AND p.deleted_at IS NULL AND s.deleted_at IS NULL "
          "ORDER BY s_created_at DESC "
      );
      final Map<int, PassengerPerson> result = {};
      for (var value in res) {
        if (result.containsKey(value["id"])) {
          final status = PassengerStatus(id: value["s_id"] as int, passengerId: value["id"] as int , status: value["s_status"] as String, createdAt: value["s_created_at"] as String);
          result[value["id"]]?.statuses.add(status);
        } else {
          result.addAll({value["id"] as int: PassengerPerson.fromRawJSON(value)});
        }
      }
      final r = result.values.toList();
      log("TRIP PASSENGERS   $r");
return r;
    });
  }

  Future<void> DeveloperModeClearPersonTable() async {
    final db = await database;
    // await db.execute("DROP TABLE IF EXISTS person");
    // await db.execute("DROP TABLE IF EXISTS trip");
    // await db.execute("DROP TABLE IF EXISTS person_documents");
    await db.execute("DROP TABLE IF EXISTS seat");
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




