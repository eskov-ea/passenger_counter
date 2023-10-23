import 'package:flutter/cupertino.dart';
import '../ui/pages/loader_widget.dart';
import '../ui/screens/auth_screen.dart';
import '../ui/screens/homescreen.dart';


class ScreenFactory {
  Widget makeLoaderWidget() {
    return const LoaderWidget();
  }

  Widget makeHomeScreen() {
    return const HomeScreen();
  }

  Widget makeAuthScreen() {
    return const AuthScreen();
  }
}