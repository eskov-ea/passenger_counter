import 'package:flutter/cupertino.dart';
import '../ui/pages/loader_widget.dart';
import '../ui/screens/auth_screen.dart';
import '../ui/screens/entry_point.dart';


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
}