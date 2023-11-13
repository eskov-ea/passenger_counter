import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/factories/screen_factory.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const authScreen = '/auth';
  static const homeScreen = '/home_screen';
  static const passengerEditingScreen = '/passenger_editing_screen';
  static const addPersonScreen = '/add_person_screen';
  static const allPersonsScreen = '/all_persons_screen';
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
        return PageRouteBuilder(
          settings: const RouteSettings(name: MainNavigationRouteNames.passengerEditingScreen),
          pageBuilder: (BuildContext context, _, __) => _screenFactory.makePassengerEditingScreen(),
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
      case MainNavigationRouteNames.addPersonScreen:
        return PageRouteBuilder(
          settings: const RouteSettings(name: MainNavigationRouteNames.addPersonScreen),
          pageBuilder: (BuildContext context, _, __) => _screenFactory.makeAddPersonScreen(),
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
      case MainNavigationRouteNames.allPersonsScreen:
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