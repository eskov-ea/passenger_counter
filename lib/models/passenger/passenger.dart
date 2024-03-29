import 'package:pleyona_app/models/person_model.dart';

class Passenger {
  final int id;
  final int tripId;
  final int personId;
  final int seatId;
  final int personDocumentId;
  final int status;
  final String comments;
  final String createdAt;
  final String updatedAt;


  const Passenger({
    required this.id,
    required this.tripId,
    required this.personId,
    required this.seatId,
    required this.personDocumentId,
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
      personDocumentId: json["person_document_id"],
      status: json["status"],
      comments: json["comments"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"]
    );

  @override
  String toString() => "Passenger: $id, $tripId, $personId, $personDocumentId, $seatId, $personDocumentId";

  static Passenger updatePassengerId(Passenger p, id) => Passenger(
    id: id,
    tripId: p.tripId,
    personId: p.personId,
    seatId: p.seatId,
    personDocumentId: p.personDocumentId,
    status: p.status,
    comments: p.comments,
    createdAt: p.createdAt,
    updatedAt: p.updatedAt
  );
}