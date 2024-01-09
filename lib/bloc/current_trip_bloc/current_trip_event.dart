
abstract class CurrentTripEvent {}

class InitializeCurrentTripEvent extends CurrentTripEvent {}

class SetNewCurrentTripEvent extends CurrentTripEvent {
  final int tripId;

  SetNewCurrentTripEvent({required this.tripId});
}
