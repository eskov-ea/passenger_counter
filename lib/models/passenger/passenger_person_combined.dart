import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';

class PassengerPerson {
  final Passenger passenger;
  final Person person;
  final Seat seat;
  final List<PassengerStatus> statuses;
  final PersonDocument document;

  const PassengerPerson({
    required this.person,
    required this.passenger,
    required this.seat,
    required this.document,
    required this.statuses
  });

  static PassengerPerson fromRawJSON(json) =>
      PassengerPerson(
        passenger: Passenger(id: json["id"], tripId: json["trip_id"], personId: json["person_id"], seatId: json["seat_id"],
            personDocumentId: json["person_document_id"], status: json['status'], comments: json["comments"],
            createdAt: json["created_at"], updatedAt: json["updated_at"]),
        person: Person(id: json["p_id"], firstname: json["firstname"], lastname: json["lastname"], middlename: json["middlename"],
            gender: json["gender"], birthdate: json["birthdate"], phone: json["phone"], email: json["email"], citizenship: json["citizenship"],
            personClass: json["class_person"], comment: json["comment"], parentId: json["parent_id"], photo: json["photo"], createdAt: json["created_at"],
            updatedAt: json["updated_at"]),
        seat: Seat(id: json["seat_id"], cabinNumber: json["cabin_number"], placeNumber: json["place_number"], deck: json["deck"],
            side: json["side"], barcode: json["barcode"], seatClass: json["class_seat"], status: json["seat_status"],
            comment: json["seat_comment"], createdAt: json["created_at"], updatedAt: json["updated_at"]),
        statuses: [ PassengerStatus(id: json["s_id"], passengerId: json["id"], status: json["s_status"], createdAt: json["s_created_at"]) ],
        document: PersonDocument.fromJson(json)
      );


  @override
  String toString() {
    return "Instance of PassengerPerson: [ ${passenger.seatId}]";
  }
}