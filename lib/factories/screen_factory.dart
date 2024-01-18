import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_add_new.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/person/all_persons_screen.dart';
import 'package:pleyona_app/ui/screens/seat/search_seat.dart';
import 'package:pleyona_app/ui/screens/seat/trip_seats_screen.dart';
import 'package:pleyona_app/ui/screens/status/edit_passengers_status.dart';
import 'package:pleyona_app/ui/screens/trip/all_trips_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_search_screen.dart';
import 'package:pleyona_app/ui/screens/success_info_screen.dart';
import 'package:pleyona_app/ui/screens/trip/trip_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';
import 'package:pleyona_app/ui/screens/qr_scanner.dart';
import '../ui/pages/adding_person_options.dart';
import '../ui/pages/loader_widget.dart';
import '../ui/screens/auth_screen.dart';
import '../ui/screens/passenger/all_trip_passengers.dart';
import '../ui/screens/person/person_edit_info_screen.dart';
import '../ui/screens/entry_point.dart';
import '../ui/screens/passenger_add_new.dart';
import '../ui/screens/trip/trip_add_new.dart';
import '../ui/screens/trip/trip_edit_info.dart';


class ScreenFactory {
  Widget makeLoaderWidget() {
    return const LoaderWidget();
  }

  Widget makeHomeScreen() {
    return const EntryPoint();
  }

  Widget makeAuthScreen() {
    return const AuthScreen();
  }

  Widget makePassengerEditingScreen() {
    return const PassengerAddNew();
  }

  Widget makeAddPersonScreen(AddNewPersonScreenArguments arguments) {
    return PersonAddNewScreen(parentId: arguments.parentId, routeName: arguments.routeName);
  }

  Widget makeAllPersonsScreen() {
    return const AllPersonsScreen();
  }

  Widget makeScannerScreen(ScannerScreenArguments arguments) {
    return QRScanner(setStateCallback: arguments.setStateCallback, allowedFormat: arguments.allowedFormat);
  }

  Widget makeAddingPersonOptionsPage(AddingPersonOptionsArguments arguments) {
    return AddingPersonOptions(newPerson: arguments.newPerson,
        persons: arguments.persons, personDocumentName: arguments.personDocumentName,
        personDocumentNumber: arguments.personDocumentNumber,);
  }

  Widget makeSuccessInfoScreen(InfoScreenArguments arguments) {
    return SuccessInfoScreen(message: arguments.message, routeName: arguments.routeName,
      person: arguments.person, personDocuments: arguments.personDocuments,);
  }

  Widget makeEditPersonInfoScreen(EditPersonScreenArguments arguments) {
    return EditPersonInfoScreen(person: arguments.person);
  }

  Widget makeSearchPersonScreen(SearchPersonScreenArguments arguments) {
    return SearchPersonScreen(callback: arguments.callback,);
  }

  Widget makeAllTripsScreen() {
    return const AllTripsScreen();
  }

  Widget makeAddNewTripScreen() {
    return const TripAddNewScreen();
  }

  Widget makeEditTripScreen(TripEditInfoScreenArguments arguments) {
    return TripEditInfo(trip: arguments.trip);
  }

  Widget makePassengerAddNewScreen() {
    return const PassengerAddNewScreen();
  }

  Widget makeTripSearchScreen(TripSearchScreenArguments arguments) {
    return TripSearchScreen(onResultCallback: arguments.onResultCallback);
  }

  Widget makeSeatSearchScreen(SeatSearchScreenArguments arguments) {
    return SeatSearchScreen(onResultCallback: arguments.onResultCallback, tripId: arguments.tripId, person: arguments.person);
  }

  Widget makeTripFullInfoScreen() {
    return const TripFullInfoScreen();
  }

  Widget makeTripPassengersScreen(TripPassengersScreenArguments arguments) {
    return AllTripPassengers(tripPassengers: arguments.tripPassengers);
  }

  Widget makePassengerFullInfoScreen(TripFullPassengerInfoScreenArguments arguments) {
    return PassengerFullInfoScreen(passenger: arguments.passenger);
  }

  Widget makeEditTripPassengersStatus(EditTripPassengersStatusScreenArguments arguments) {
    return EditTripPassengersStatus(statusName: arguments.statusName, tripId: arguments.tripId);
  }

  Widget makeTripSeatsScreen() {
    return const TripSeatsScreen();
  }
}