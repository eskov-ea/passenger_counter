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
      }
    });
  }

  Future<void> _onCurrentTripInitializeEvent(
      InitializeCurrentTripEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    final db = DBProvider.db;
    final trips = await db.searchTripsByDate(date: DateTime.now());
    final current = trips.isEmpty ? null : trips.first;
    List<Passenger>? passengers;
    List<PassengerPerson> passengerPerson = [];
    List<Seat>? availableSeats = [];
    if (current != null) {
      passengers = await db.getPassengers(tripId: current.id);
      for (var passenger in passengers) {
        final Person person = await db.getPersonById(personId: passenger.personId);
        final Seat seat = await db.getPassengerSeat(seatId: passenger.seatId);
        passengerPerson.add(PassengerPerson(person: person, passenger: passenger, seat: seat));
      }
      availableSeats = await db.getAvailableSeats(tripId: current.id);
    }
    final newState = InitializedCurrentTripState(currentTrip: current!,
        tripPassengers: passengerPerson, availableSeats: availableSeats);
    emit(newState);
  }

  Future<void> _onSetNewCurrentTripEvent(
      SetNewCurrentTripEvent event,
      Emitter<CurrentTripState> emit
      ) async {
    emit(InitializingCurrentTripState());
    final db = DBProvider.db;
    log('current trip ${event.tripId}');
    final current = await db.getTripById(tripId: event.tripId);
    List<Passenger>? passengers;
    List<PassengerPerson> passengerPerson = [];
    List<Seat>? availableSeats = [];
    passengers = await db.getPassengers(tripId: event.tripId);
    log("Passangers   $passengers");
    for (var passenger in passengers) {
      final Person person = await db.getPersonById(personId: passenger.personId);
      final Seat seat = await db.getPassengerSeat(seatId: passenger.seatId);
      passengerPerson.add(PassengerPerson(person: person, passenger: passenger, seat: seat));
    }
    availableSeats = await db.getAvailableSeats(tripId: current.id);
    final newState = InitializedCurrentTripState(currentTrip: current,
        tripPassengers: passengerPerson, availableSeats: availableSeats);
    emit(newState);
  }

}