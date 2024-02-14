
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';

abstract class CurrentTripEvent {}

class InitializeCurrentTripEvent extends CurrentTripEvent {}

class SetNewCurrentTripEvent extends CurrentTripEvent {
  final int tripId;

  SetNewCurrentTripEvent({required this.tripId});
}

class AddNewPassengerStatusEvent extends CurrentTripEvent {
  final PassengerStatus passengerStatus;
  final int passengerId;

  AddNewPassengerStatusEvent({required this.passengerStatus, required this.passengerId});
}

class DeletePassengerStatusEvent extends CurrentTripEvent {
  final int statusId;
  final int passengerId;

  DeletePassengerStatusEvent({required this.statusId, required this.passengerId});
}

class DeleteTripPassengerEvent extends CurrentTripEvent {
  final int passengerId;

  DeleteTripPassengerEvent({required this.passengerId});
}

class AddNewTripPassengerEvent extends CurrentTripEvent {
  final Passenger passenger;
  final List<int> baggage;

  AddNewTripPassengerEvent({required this.passenger, required this.baggage});
}

class ChangePassengerSeatEvent extends CurrentTripEvent {
  final int seatId;
  final int passengerId;
  final int tripId;

  ChangePassengerSeatEvent({required this.seatId, required this.passengerId,
    required this.tripId});
}

