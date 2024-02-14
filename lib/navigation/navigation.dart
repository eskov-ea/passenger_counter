import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/factories/screen_factory.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/ui/screens/passenger/all_trip_passengers.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/seat/search_seat.dart';
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
  static const tripPassengerInfo = RouteObj(path: '/passengers/passenger', name: 'passenger');
  static const editTripPassengersStatus = RouteObj(path: '/passengers/status', name: 'passengers_status');
  static const seatSearchScreen = RouteObj(path: '/seats/search', name: 'search_seat');
  static const currentTripSeatsScreen = RouteObj(path: '/trips/current/seats', name: 'current_trip_seats');
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
        final Person person = state.extra as Person;
        return _screenFactory.makeEditPersonInfoScreen(
            EditPersonScreenArguments(
                person: person
            )
        );
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
        path: NavigationRoutes.tripPassengerInfo.path,
        name: NavigationRoutes.tripPassengerInfo.name,
        builder: (context, state) {
          final TripFullPassengerInfoScreenArguments args = state.extra as TripFullPassengerInfoScreenArguments;
          return _screenFactory.makePassengerFullInfoScreen(args);
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


// class MainNavigation {
//   static final ScreenFactory _screenFactory = ScreenFactory();
//
//   final routes = <String, Widget Function(BuildContext)> {
//     MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoaderWidget(),
//     MainNavigationRouteNames.authScreen: (_) => _screenFactory.makeAuthScreen(),
//     MainNavigationRouteNames.homeScreen: (_) => _screenFactory.makeHomeScreen()
//   };
//
//
//   Route<Object> onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case MainNavigationRouteNames.passengerEditingScreen:
//         settings: const RouteSettings(name: MainNavigationRouteNames.passengerEditingScreen);
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePassengerEditingScreen());
//       case MainNavigationRouteNames.addPersonScreen:
//         final arguments = settings.arguments as AddNewPersonScreenArguments;
//         return CupertinoPageRoute(
//           settings: const RouteSettings(name: MainNavigationRouteNames.addPersonScreen),
//           builder: (BuildContext context) => _screenFactory.makeAddPersonScreen(arguments)
//         );
//       case MainNavigationRouteNames.allPersonsScreen:
//         settings: const RouteSettings(name: MainNavigationRouteNames.allPersonsScreen);
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAllPersonsScreen());
//       case MainNavigationRouteNames.scannerScreen:
//         final arguments = settings.arguments as ScannerScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeScannerScreen(arguments));
//       case MainNavigationRouteNames.personCollisionScreen:
//         final arguments = settings.arguments as AddingPersonOptionsArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePersonCollisionScreen(arguments));
//       case MainNavigationRouteNames.successInfoScreen:
//         final arguments = settings.arguments as InfoScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSuccessInfoScreen(arguments));
//       case MainNavigationRouteNames.editPersonInfoScreen:
//         final arguments = settings.arguments as EditPersonScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeEditPersonInfoScreen(arguments));
//         return PageRouteBuilder(
//           settings: const RouteSettings(name: MainNavigationRouteNames.successInfoScreen),
//           pageBuilder: (BuildContext context, _, __) => _screenFactory.makeEditPersonInfoScreen(arguments),
//           transitionsBuilder: (context, Animation<double> animation,
//               Animation<double> secondaryAnimation, Widget child) {
//             final tween = Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).chain(CurveTween(curve: Curves.ease));
//             return SlideTransition(
//               position: animation.drive(tween),
//               child: child,
//             );
//           },
//           transitionDuration: Duration(milliseconds: 700),
//         );
//       case MainNavigationRouteNames.searchPersonScreen:
//         final arguments = settings.arguments as SearchPersonScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSearchPersonScreen(arguments));
//       case MainNavigationRouteNames.addNewTripScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAddNewTripScreen());
//       case MainNavigationRouteNames.allTripsScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeAllTripsScreen());
//       case MainNavigationRouteNames.editTripScreen:
//         final arguments = settings.arguments as TripEditInfoScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeEditTripScreen(arguments));
//       case MainNavigationRouteNames.passengerAddNewScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePassengerAddNewScreen());
//       case MainNavigationRouteNames.seatSearchScreen:
//         final arguments = settings.arguments as SeatSearchScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSeatSearchScreen(arguments));
//       case MainNavigationRouteNames.tripSearchScreen:
//         final arguments = settings.arguments as TripSearchScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripSearchScreen(arguments));
//       case MainNavigationRouteNames.tripPassengers:
//         final arguments = settings.arguments as TripPassengersScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripPassengersScreen(arguments));
//       case MainNavigationRouteNames.tripPassengerInfo:
//         final arguments = settings.arguments as TripFullPassengerInfoScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makePassengerFullInfoScreen(arguments));
//       case MainNavigationRouteNames.editTripPassengersStatus:
//         final arguments = settings.arguments as EditTripPassengersStatusScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeEditTripPassengersStatus(arguments));
//       case MainNavigationRouteNames.currentTripFullInfoScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeCurrentTripFullInfoScreen());
//       case MainNavigationRouteNames.tripFullInfoScreen:
//         final arguments = settings.arguments as TripFullInfoScreenArguments;
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripFullInfoScreen(arguments));
//       case MainNavigationRouteNames.currentTripSeatsScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeCurrentTripSeatsScreen());
//       case MainNavigationRouteNames.seatManagerScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeSeatManagerScreen());
//       case MainNavigationRouteNames.tripsCalendarScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeTripsCalendarsScreen());
//       case MainNavigationRouteNames.faqScreen:
//         return CupertinoPageRoute(builder: (BuildContext context) => _screenFactory.makeFAQScreen());
//       case MainNavigationRouteNames.test:
//         return PageRouteBuilder(
//           settings: const RouteSettings(name: MainNavigationRouteNames.allPersonsScreen),
//           pageBuilder: (BuildContext context, _, __) => _screenFactory.makeAllPersonsScreen(),
//           transitionsBuilder: (context, Animation<double> animation,
//               Animation<double> secondaryAnimation, Widget child) {
//             final tween = Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).chain(CurveTween(curve: Curves.ease));
//             return SlideTransition(
//               position: animation.drive(tween),
//               child: child,
//             );
//           },
//           transitionDuration: Duration(milliseconds: 700),
//         );
//       default:
//         const widget = Center(child: Text('Ошибка навигации между страницами приложения', style: TextStyle(color: Colors.black87, fontSize: 16),));
//         return MaterialPageRoute(builder: (_) => widget);
//     }
//   }
// }