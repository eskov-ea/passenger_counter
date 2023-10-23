import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/factories/screen_factory.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const authScreen = '/auth';
  static const homeScreen = '/home_screen';
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
      default:
        const widget = Center(child: Text('Ошибка навигации между страницами приложения', style: TextStyle(color: Colors.black87, fontSize: 16),));
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}