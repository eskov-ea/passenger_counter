import 'package:pleyona_app/models/person_model.dart';

class Passenger {
  final int id;
  final int tripId;
  final int personId;
  final int seatId;
  final String document;
  final int status;
  final String comments;
  final String createdAt;
  final String updatedAt;


  const Passenger({
    required this.id,
    required this.tripId,
    required this.personId,
    required this.seatId,
    required this.document,
    required this.status,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  static Passenger fromJson(json) => Passenger(
      id: json["id"],
      tripId: json["trip_id"],
      personId: json["person_id"],
      seatId: json["seat_id"],
      document: json["document"],
      status: json["status"],
      comments: json["comments"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"]
    );

  @override
  String toString() => "Passenger: $id, $tripId, $personId, $seatId, $document";

  static Passenger updatePassengerId(Passenger p, id) => Passenger(
    id: id,
    tripId: p.tripId,
    personId: p.personId,
    seatId: p.seatId,
    document: p.document,
    status: p.status,
    comments: p.comments,
    createdAt: p.createdAt,
    updatedAt: p.updatedAt
  );
}