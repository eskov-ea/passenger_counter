import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/factories/screen_factory.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/ui/screens/passenger/all_trip_passengers.dart';
import 'package:pleyona_app/ui/screens/passenger/current_trip_passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/seat/search_seat.dart';
import 'package:pleyona_app/ui/screens/seat/trip_seats_screen.dart';
import 'package:pleyona_app/ui/screens/status/edit_passengers_status.dart';
import 'package:pleyona_app/ui/screens/success_info_screen.dart';
import 'package:pleyona_app/ui/screens/trip/trip_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';
import 'package:pleyona_app/ui/screens/qr_scanner.dart';
import '../ui/pages/adding_person_options.dart';
import '../ui/screens/person/person_edit_info_screen.dart';
import '../ui/screens/person/person_search_screen.dart';
import '../ui/screens/trip/trip_edit_info.dart';

class RouteObj extends Equatable{
  final String path;
  final String name;
  const RouteObj({required this.path, required this.name});

  @override
  List<Object?> get props => [path];
}

abstract class NavigationRoutes {
  static const homeScreen = RouteObj(path: '/', name: "home_screen");
  static const loaderWidget = RouteObj(path: '/check_auth', name: 'loader_widget');
  static const authScreen = RouteObj(path: '/login', name: 'auth_screen');
  static const passengerEditingScreen = RouteObj(path: '/edit_passenger_info', name: 'passenger_edit_screen') ;
  static const addPersonScreen = RouteObj(path: '/add_person', name: 'new_person_screen') ;
  static const editPersonInfoScreen = RouteObj(path: '/person/edit', name: 'edit_person') ;
  static const allPersonsScreen = RouteObj(path: '/persons', name: 'persons');
  static const personCollisionScreen = RouteObj(path: '/persons/collision', name: 'name');
  static const searchPersonScreen = RouteObj(path: '/persons/search', name: 'search_person');
  static const allTripsScreen = RouteObj(path: '/trips', name: 'trips');
  static const addNewTripScreen = RouteObj(path: '/trips/add', name: 'add_trip');
  static const editTripScreen = RouteObj(path: '/trips/edit', name: 'edit_trip');
  static const tripSearchScreen = RouteObj(path: '/trips/search', name: 'search_trip');
  static const currentTripFullInfoScreen = RouteObj(path: '/trips/current', name: 'current_trip_info');
  static const tripFullInfoScreen = RouteObj(path: '/trips/trip', name: 'full_info_trip');
  static const passengerAddNewScreen = RouteObj(path: '/passengers/add', name: 'add_passenger');
  static const tripPassengers = RouteObj(path: '/passengers', name: 'passengers');
  static const currentTripPassengers = RouteObj(path: '/passengers/current_trip/passengers', name: 'current_trip_passengers');
  static const tripPassengerInfo = RouteObj(path: '/passengers/passenger', name: 'passenger');
  static const currentTripPassengerInfo = RouteObj(path: '/passengers/current_trip/passenger', name: 'current_trip_passenger');
  static const editTripPassengersStatus = RouteObj(path: '/passengers/status', name: 'passengers_status');
  static const seatSearchScreen = RouteObj(path: '/seats/search', name: 'search_seat');
  static const currentTripSeatsScreen = RouteObj(path: '/trips/current/seats', name: 'current_trip_seats');
  static const tripSeatsScreen = RouteObj(path: '/trips/trip/seats', name: 'trip_seats');
  static const seatManagerScreen = RouteObj(path: '/seats/manage', name: 'seats_manager');
  static const scannerScreen = RouteObj(path: '/scanner', name: 'scanner');
  static const barcodeScanScreen = RouteObj(path: '/barcode', name: 'name');
  static const tripsCalendarScreen = RouteObj(path: '/trips_calendar', name: 'calendar');
  static const faqScreen = RouteObj(path: '/faq', name: 'faq');
  static const test = '/test';
}

class MainNavigationRoutes {
  static final ScreenFactory _screenFactory = ScreenFactory();
  static final router = GoRouter(routes: routes);
  static final routes = [
    GoRoute(
      path: NavigationRoutes.loaderWidget.path,
      name: NavigationRoutes.loaderWidget.name,
      builder: (context, state) => _screenFactory.makeLoaderWidget(),
    ),
    GoRoute(
      path: NavigationRoutes.authScreen.path,
      name: NavigationRoutes.authScreen.name,
      builder: (context, state) => _screenFactory.makeAuthScreen(),
    ),
    GoRoute(
      path: NavigationRoutes.homeScreen.path,
      name: NavigationRoutes.homeScreen.name,
      builder: (context, state) => _screenFactory.makeHomeScreen(),
    ),
    /// Screen not ready yet
    GoRoute(
      path: NavigationRoutes.passengerEditingScreen.path,
      name: NavigationRoutes.passengerEditingScreen.name,
      builder: (context, state) => _screenFactory.makePassengerEditingScreen(),
    ),
    GoRoute(
      path: NavigationRoutes.addPersonScreen.path,
      name: NavigationRoutes.addPersonScreen.name,
      builder: (context, state) {
        final AddNewPersonScreenArguments args = state.extra as AddNewPersonScreenArguments;
        return _screenFactory.makeAddPersonScreen(args);
      },
      routes: [

      ]
    ),
    GoRoute(
      path: NavigationRoutes.editPersonInfoScreen.path,
      name: NavigationRoutes.editPersonInfoScreen.name,
      builder: (context, state) {
        final EditPersonScreenArguments args = state.extra as EditPersonScreenArguments;
        return _screenFactory.makeEditPersonInfoScreen(args);
      }
    ),
    // GoRoute(
    //   path: MainNavigationRouteNames.personCollisionScreen,
    //   name: 'person_collision',
    //   builder: (context, state) {
    //     final Person person = state.extra as Person;
    //     return _screenFactory.makePersonCollisionScreen(
    //       AddingPersonOptionsArguments(
    //         newPerson: person,
    //         personDocumentName: '',
    //         personDocumentNumber: '',
    //         persons: []
    //       )
    //     );
    //   }
    // ),
    GoRoute(
        path: NavigationRoutes.searchPersonScreen.path,
        name: NavigationRoutes.searchPersonScreen.name,
        builder: (context, state) {
          final Function(Person) callback = state.extra as Function(Person);
          return _screenFactory.makeSearchPersonScreen(
              SearchPersonScreenArguments(callback: callback)
          );
        }
    ),
    GoRoute(
        path: NavigationRoutes.allPersonsScreen.path,
        name: NavigationRoutes.allPersonsScreen.name,
        builder: (context, state) {
          return _screenFactory.makeAllPersonsScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.scannerScreen.path,
        name: NavigationRoutes.scannerScreen.name,
        builder: (context, state) {
          final ScannerScreenArguments args = state.extra as ScannerScreenArguments;
          return _screenFactory.makeScannerScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.allTripsScreen.path,
        name: NavigationRoutes.allTripsScreen.name,
        builder: (context, state) {
          return _screenFactory.makeAllTripsScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.addNewTripScreen.path,
        name: NavigationRoutes.addNewTripScreen.name,
        builder: (context, state) {
          return _screenFactory.makeAddNewTripScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.editTripScreen.path,
        name: NavigationRoutes.editTripScreen.name,
        builder: (context, state) {
          final TripEditInfoScreenArguments args = state.extra as TripEditInfoScreenArguments;
          return _screenFactory.makeEditTripScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.tripSearchScreen.path,
        name: NavigationRoutes.tripSearchScreen.name,
        builder: (context, state) {
          final TripSearchScreenArguments args = state.extra as TripSearchScreenArguments;
          return _screenFactory.makeTripSearchScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.currentTripFullInfoScreen.path,
        name: NavigationRoutes.currentTripFullInfoScreen.name,
        builder: (context, state) {
          return _screenFactory.makeCurrentTripFullInfoScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.tripFullInfoScreen.path,
        name: NavigationRoutes.tripFullInfoScreen.name,
        builder: (context, state) {
          final TripFullInfoScreenArguments args = state.extra as TripFullInfoScreenArguments;
          return _screenFactory.makeTripFullInfoScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.passengerAddNewScreen.path,
        name: NavigationRoutes.passengerAddNewScreen.name,
        builder: (context, state) {
          return _screenFactory.makePassengerAddNewScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.tripPassengers.path,
        name: NavigationRoutes.tripPassengers.name,
        builder: (context, state) {
          final TripPassengersScreenArguments args = state.extra as TripPassengersScreenArguments;
          return _screenFactory.makeTripPassengersScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.currentTripPassengers.path,
        name: NavigationRoutes.currentTripPassengers.name,
        builder: (context, state) {
          return _screenFactory.makeCurrentTripPassengersScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.tripPassengerInfo.path,
        name: NavigationRoutes.tripPassengerInfo.name,
        builder: (context, state) {
          final TripFullPassengerInfoScreenArguments args = state.extra as TripFullPassengerInfoScreenArguments;
          return _screenFactory.makePassengerFullInfoScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.currentTripPassengerInfo.path,
        name: NavigationRoutes.currentTripPassengerInfo.name,
        builder: (context, state) {
          final TripFullPassengerInfoScreenArguments args = state.extra as TripFullPassengerInfoScreenArguments;
          return _screenFactory.makeCurrentTripPassengerFullInfoScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.editTripPassengersStatus.path,
        name: NavigationRoutes.editTripPassengersStatus.name,
        builder: (context, state) {
          final EditTripPassengersStatusScreenArguments args = state.extra as EditTripPassengersStatusScreenArguments;
          return _screenFactory.makeEditTripPassengersStatus(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.seatSearchScreen.path,
        name: NavigationRoutes.seatSearchScreen.name,
        builder: (context, state) {
          final SeatSearchScreenArguments args = state.extra as SeatSearchScreenArguments;
          return _screenFactory.makeSeatSearchScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.tripSeatsScreen.path,
        name: NavigationRoutes.tripSeatsScreen.name,
        builder: (context, state) {
          final TripSeatsScreenArguments args = state.extra as TripSeatsScreenArguments;
          return _screenFactory.makeTripSeatsScreen(args);
        }
    ),
    GoRoute(
        path: NavigationRoutes.currentTripSeatsScreen.path,
        name: NavigationRoutes.currentTripSeatsScreen.name,
        builder: (context, state) {
          return _screenFactory.makeCurrentTripSeatsScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.seatManagerScreen.path,
        name: NavigationRoutes.seatManagerScreen.name,
        builder: (context, state) {
          return _screenFactory.makeSeatManagerScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.tripsCalendarScreen.path,
        name: NavigationRoutes.tripsCalendarScreen.name,
        builder: (context, state) {
          return _screenFactory.makeTripsCalendarsScreen();
        }
    ),
    GoRoute(
        path: NavigationRoutes.faqScreen.path,
        name: NavigationRoutes.faqScreen.name,
        builder: (context, state) {
          return _screenFactory.makeFAQScreen();
        }
    ),
  ]; 
}