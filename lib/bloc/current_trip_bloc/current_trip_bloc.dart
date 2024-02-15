import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';

class CurrentTripBloc extends Bloc<CurrentTripEvent, CurrentTripState> {

  CurrentTripBloc(): super(InitializingCurrentTripState()) {

    on<CurrentTripEvent>((event, emit) async {
      print("CurrentTripBloc:::   $event");
      if (event is InitializeCurrentTripEvent) {
        await _onCurrentTripInitializeEvent(event, emit);
      } else if (event is SetNewCurrentTripEvent) {
        await _onSetNewCurrentTripEvent(event, emit);
      } else if (event is AddNewPassengerStatusEvent) {
        await _onAddNewPassengerStatusEvent(event, emit);
      } else if (event is DeletePassengerStatusEvent) {
        await _onDeletePassengerStatusEvent(event, emit);
      } else if (event is DeleteTripPassengerEvent) {
        await _onDeleteTripPassengerEvent(event, emit);
      } else if (event is AddNewTripPassengerEvent) {
        await _onAddNewTripPassengerEvent(event, emit);
      } else if (event is ChangePassengerSeatEvent) {
        await _onChangePassengerSeatEvent(event, emit);
      }
    });
  }

  Future<void> _onCurrentTripInitializeEvent(
      InitializeCurrentTripEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    if (state is! InitializingCurrentTripState) return;
    emit(InitializingCurrentTripState());
    final db = DBProvider.db;
    final trips = await db.searchTripForToday(date: DateTime.now());
    if (trips.isEmpty) {
      emit(NoCurrentTripState());
    } else {
      final current = trips.first;
      final List<PassengerPerson> passengerPerson = await db.getTripPassengersInfo(tripId: current.id);
      final List<Seat> availableSeats = await db.getAvailableSeats(tripId: current.id);
      final List<Seat> occupiedSeats = await db.getOccupiedTripSeats(tripId: current.id);

      final newState = InitializedCurrentTripState(currentTrip: current,
          tripPassengers: passengerPerson, availableSeats: availableSeats, occupiedSeats: occupiedSeats);
      emit(newState);
    }
  }

  Future<void> _onSetNewCurrentTripEvent(
      SetNewCurrentTripEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    emit(InitializingCurrentTripState());
    final db = DBProvider.db;
    final current = await db.getTripById(tripId: event.tripId);
    final List<PassengerPerson> passengerPerson = await db.getTripPassengersInfo(tripId: current.id);
    final List<Seat> availableSeats = await db.getAvailableSeats(tripId: current.id);
    final List<Seat> occupiedSeats = await db.getOccupiedTripSeats(tripId: current.id);
    final newState = InitializedCurrentTripState(currentTrip: current,
        tripPassengers: passengerPerson, availableSeats: availableSeats, occupiedSeats: occupiedSeats);
    emit(newState);
  }

  Future<void> _onAddNewPassengerStatusEvent(
      AddNewPassengerStatusEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    if (state is! InitializedCurrentTripState) return;
    final s = state as InitializedCurrentTripState;
    for (var p in s.tripPassengers) {
      if (p.passenger.id == event.passengerId) {
        p.statuses.insert(0, event.passengerStatus);
      }
    }
    emit(s.copyWith(
      currentTrip: s.currentTrip,
      tripPassengers: s.tripPassengers,
      availableSeats: s.availableSeats
    ));
  }

  Future<void> _onDeletePassengerStatusEvent(
      DeletePassengerStatusEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    if (state is! InitializedCurrentTripState) return;
    final s = state as InitializedCurrentTripState;
    for (var p in s.tripPassengers) {
      if (p.passenger.id == event.passengerId) {
        p.statuses.removeWhere((status) => status.id == event.statusId);
      }
    }
    emit(s.copyWith(
      currentTrip: s.currentTrip,
      tripPassengers: s.tripPassengers,
      availableSeats: s.availableSeats
    ));
  }

  Future<void> _onDeleteTripPassengerEvent(
      DeleteTripPassengerEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    final db = DBProvider.db;
    await db.deletePassenger(passengerId: event.passengerId);
    final s = state as InitializedCurrentTripState;
    s.tripPassengers.removeWhere((tripPassenger) =>
      tripPassenger.passenger.id == event.passengerId);
    final List<Seat> availableSeats = await db.getAvailableSeats(tripId: s.currentTrip.id);

    emit(s.copyWith(
        currentTrip: s.currentTrip,
        tripPassengers: s.tripPassengers,
        availableSeats: availableSeats
    ));
  }

  Future<void> _onAddNewTripPassengerEvent(
      AddNewTripPassengerEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    final db = DBProvider.db;
    final passengerId = await db.addPassenger(p: event.passenger);
    await db.addPassengerStatus(passengerId: passengerId, statusName: 'CheckIn');
    for (var baggageWeight in event.baggage) {
      await db.addPassengerBagage(passengerId: passengerId, weight: baggageWeight);
    }

    if (state is InitializedCurrentTripState) {
      final passenger = Passenger.updatePassengerId(event.passenger, passengerId);
      //TODO: refactor 4 requests into 1
      final Person person = await db.getPersonById(personId: event.passenger.personId);
      final Seat seat = await db.getPassengerSeat(seatId: event.passenger.seatId);
      final statuses = await db.getPassengerStatuses(passengerId: passengerId);
      final document = await db.getPersonDocumentById(documentId: passenger.personDocumentId);

      final newPassengerPerson = PassengerPerson(
          person: person,
          passenger: passenger,
          seat: seat,
          statuses: statuses,
          document: document);
      final s = state as InitializedCurrentTripState;
      s.tripPassengers.insert(0, newPassengerPerson);
      final List<Seat> availableSeats = await db.getAvailableSeats(tripId: s.currentTrip.id);

      emit(s.copyWith(
          currentTrip: s.currentTrip,
          tripPassengers: s.tripPassengers,
          availableSeats: availableSeats));
    }
  }

  Future<void> _onChangePassengerSeatEvent(
      ChangePassengerSeatEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    emit(InitializingCurrentTripState());
    final db = DBProvider.db;
    await db.changePassengerSeat(passengerId: event.passengerId, seatId: event.seatId);
    add(SetNewCurrentTripEvent(tripId: event.tripId));
  }

}