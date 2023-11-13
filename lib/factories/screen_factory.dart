import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/ui/screens/all_persons_screen.dart';
import 'package:pleyona_app/ui/screens/person_add_new_screen.dart';
import '../ui/pages/loader_widget.dart';
import '../ui/screens/auth_screen.dart';
import '../ui/screens/entry_point.dart';
import '../ui/screens/passenger_add_new.dart';


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

  Widget makeAddPersonScreen() {
    return const PersonAddNewScreen();
  }

  Widget makeAllPersonsScreen() {
    return const AllPersonsScreen();
  }
}