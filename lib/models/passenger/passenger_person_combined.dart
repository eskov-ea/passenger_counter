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
}