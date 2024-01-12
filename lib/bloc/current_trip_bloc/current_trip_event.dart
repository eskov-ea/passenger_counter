
import 'package:pleyona_app/models/passenger/passenger.dart';

abstract class CurrentTripEvent {}

class InitializeCurrentTripEvent extends CurrentTripEvent {}

class SetNewCurrentTripEvent extends CurrentTripEvent {
  final int tripId;

  SetNewCurrentTripEvent({required this.tripId});
}

class AddNewPassengerStatusEvent extends CurrentTripEvent {
  final String statusName;
  final int passengerId;

  AddNewPassengerStatusEvent({required this.statusName, required this.passengerId});
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

