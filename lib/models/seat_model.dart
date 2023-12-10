import 'package:equatable/equatable.dart';

class Seat extends Equatable {

  final int id;
  final String cabinNumber;
  final String placeNumber;
  final String deck;
  final String side;
  final String barcode;
  final int seatClass;
  final String status;
  final String comment;
  final String createdAt;
  final String updatedAt;

  const Seat({
    required this.id,
    required this.cabinNumber,
    required this.placeNumber,
    required this.deck,
    required this.side,
    required this.barcode,
    required this.seatClass,
    required this.status,
    required this.comment,
    required this.createdAt,
    required this.updatedAt
  });


  @override
  List<Object?> get props => [id, updatedAt, createdAt];

  static Seat fromJson(json) => Seat(
    id: json["id"],
    cabinNumber: json["cabin_number"],
    placeNumber: json["place_number"],
    deck: json["deck"],
    side: json["side"],
    barcode: json["barcode"],
    seatClass: json["class_seat"],
    status: json["status"],
    comment: json["comments"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"]
  );

}