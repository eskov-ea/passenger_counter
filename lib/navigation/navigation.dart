import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/factories/screen_factory.dart';
import 'package:pleyona_app/ui/screens/passenger/all_trip_passengers.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/seat/search_seat.dart';
import 'package:pleyona_app/ui/screens/status/edit_passengers_status.dart';
import 'package:pleyona_app/ui/screens/success_info_screen.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';
import 'package:pleyona_app/ui/screens/qr_scanner.dart';
import '../ui/pages/adding_person_options.dart';
import '../ui/screens/person/person_edit_info_screen.dart';
import '../ui/screens/person/person_search_screen.dart';
import '../ui/screens/trip/trip_edit_info.dart';


abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const authScreen = '/auth';
  static const homeScreen = '/homescreen';
  static const passengerEditingScreen = '/edit_passenger_info';
  static const addPersonScreen = '/add_person';
  static const editPersonInfoScreen = '/edit_person';
  static const allPersonsScreen = '/all_persons';
  static const scannerScreen = '/scanner';
  static const personOptionsScreen = '/add_person_options';
  static const successInfoScreen = '/success_info';
  static const searchPersonScreen = '/searching_person';
  static const allTripsScreen = '/all_trips';
  static const addNewTripScreen = '/add_trip';
  static const editTripScreen = '/edit_trip';
  static const passengerAddNewScreen = '/add_passenger';
  static const tripSearchScreen = '/search_trip';
  static const seatSearchScreen = '/search_seat';
  static const tripFullInfoScreen = '/trip_full_info';
  static const tripPassengers = '/trip_passengers';
  static const tripPassengerInfo = '/trip_passenger_full_info';
  static const editTripPassengersStatus = '/edit_passenger_status';
  static const tripSeatsScreen = '/trip_seats';
  static const barcodeScanScreen = '/scan_barcode';
  static const test = '/test';
}


class MainNavigation {
  static final ScreenFactory _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)> {
    MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoaderWidget(),
    MainNavigationRouteNames.authScreen: (_) => _screenFactory.makeAuthScreen(),
    MainNavigationRouteNames.homeScreen: (_) => _screenFactory.makeHomeScreen()
  };


  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.passengerEditingScreen:
        settings: const RouteSettings(name: MainNavigationRouteNames.passengerEditingScreen);
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePassengerEditingScreen());
      case MainNavigationRouteNames.addPersonScreen:
        final arguments = settings.arguments as AddNewPersonScreenArguments;
        return CupertinoPageRoute(
          settings: const RouteSettings(name: MainNavigationRouteNames.addPersonScreen),
          builder: (BuildContext context) => _screenFactory.makeAddPersonScreen(arguments)
        );
      case MainNavigationRouteNames.allPersonsScreen:
        settings: const RouteSettings(name: MainNavigationRouteNames.allPersonsScreen);
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAllPersonsScreen());
      case MainNavigationRouteNames.scannerScreen:
        final arguments = settings.arguments as ScannerScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeScannerScreen(arguments));
      case MainNavigationRouteNames.personOptionsScreen:
        final arguments = settings.arguments as AddingPersonOptionsArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAddingPersonOptionsPage(arguments));
      case MainNavigationRouteNames.successInfoScreen:
        final arguments = settings.arguments as InfoScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSuccessInfoScreen(arguments));
      case MainNavigationRouteNames.editPersonInfoScreen:
        final arguments = settings.arguments as EditPersonScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeEditPersonInfoScreen(arguments));
        return PageRouteBuilder(
          settings: const RouteSettings(name: MainNavigationRouteNames.successInfoScreen),
          pageBuilder: (BuildContext context, _, __) => _screenFactory.makeEditPersonInfoScreen(arguments),
          transitionsBuilder: (context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            final tween = Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).chain(CurveTween(curve: Curves.ease));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 700),
        );
      case MainNavigationRouteNames.searchPersonScreen:
        final arguments = settings.arguments as SearchPersonScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSearchPersonScreen(arguments));
      case MainNavigationRouteNames.addNewTripScreen:
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAddNewTripScreen());
      case MainNavigationRouteNames.allTripsScreen:
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAllTripsScreen());
      case MainNavigationRouteNames.editTripScreen:
        final arguments = settings.arguments as TripEditInfoScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeEditTripScreen(arguments));
      case MainNavigationRouteNames.passengerAddNewScreen:
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePassengerAddNewScreen());
      case MainNavigationRouteNames.seatSearchScreen:
        final arguments = settings.arguments as SeatSearchScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSeatSearchScreen(arguments));
      case MainNavigationRouteNames.tripSearchScreen:
        final arguments = settings.arguments as TripSearchScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripSearchScreen(arguments));
      case MainNavigationRouteNames.tripPassengers:
        final arguments = settings.arguments as TripPassengersScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripPassengersScreen(arguments));
      case MainNavigationRouteNames.tripPassengerInfo:
        final arguments = settings.arguments as TripFullPassengerInfoScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePassengerFullInfoScreen(arguments));
      case MainNavigationRouteNames.editTripPassengersStatus:
        final arguments = settings.arguments as EditTripPassengersStatusScreenArguments;
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeEditTripPassengersStatus(arguments));
      case MainNavigationRouteNames.tripFullInfoScreen:
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripFullInfoScreen());
      case MainNavigationRouteNames.tripSeatsScreen:
        return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripSeatsScreen());
      case MainNavigationRouteNames.test:
        return PageRouteBuilder(
          settings: const RouteSettings(name: MainNavigationRouteNames.allPersonsScreen),
          pageBuilder: (BuildContext context, _, __) => _screenFactory.makeAllPersonsScreen(),
          transitionsBuilder: (context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            final tween = Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).chain(CurveTween(curve: Curves.ease));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 700),
        );
      default:
        const widget = Center(child: Text('Ошибка навигации между страницами приложения', style: TextStyle(color: Colors.black87, fontSize: 16),));
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}