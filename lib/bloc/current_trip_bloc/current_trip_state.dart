import 'package:equatable/equatable.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/trip_model.dart';
import '../../models/seat_model.dart';

abstract class CurrentTripState  {}

class InitializedCurrentTripState extends CurrentTripState {
  final Trip currentTrip;
  final List<PassengerPerson> tripPassengers;
  final List<Seat> availableSeats;

  InitializedCurrentTripState({
    required this.currentTrip,
    required this.tripPassengers,
    required this.availableSeats
  });




  InitializedCurrentTripState copyWith({
    Trip? currentTrip,
    List<PassengerPerson>? tripPassengers,
    List<Seat>? availableSeats
  }) {
    return InitializedCurrentTripState(
      currentTrip: currentTrip ?? this.currentTrip,
      tripPassengers: tripPassengers ?? this.tripPassengers,
      availableSeats: availableSeats ?? this.availableSeats
    );
  }
}

class InitializingCurrentTripState extends CurrentTripState {}

class NoCurrentTripState extends CurrentTripState {}
