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

  // final String baggageStatus;
  // final String? baggageWeight;
  // final int children;
  // final String passangerRoundStatus;
  // final String passId;

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

    // required this.baggageStatus,
    // required this.baggageWeight,
    // required this.children,
    // required this.passangerRoundStatus,
    // required this.passId,
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
}