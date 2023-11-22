import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/ui/screens/all_persons_screen.dart';
import 'package:pleyona_app/ui/screens/person_add_new_screen.dart';
import 'package:pleyona_app/ui/screens/person_search_screen.dart';
import 'package:pleyona_app/ui/screens/success_info_screen.dart';
import 'package:pleyona_app/ui/widgets/scanner.dart';
import '../ui/pages/adding_person_options.dart';
import '../ui/pages/loader_widget.dart';
import '../ui/screens/auth_screen.dart';
import '../ui/screens/person_edit_info_screen.dart';
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

  Widget makeScannerScreen(ScannerScreenArguments arguments) {
    return Scanner(setStateCallback: arguments.setStateCallback, allowedFormat: arguments.allowedFormat);
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
    return EditPersonInfoScreen(person: arguments.person,);
  }

  Widget makeSearchPersonScreen(SearchPersonScreenArguments arguments) {
    return SearchPersonScreen(callback: arguments.callback,);
  }
}