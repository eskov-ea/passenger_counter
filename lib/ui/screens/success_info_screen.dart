import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/person/person_edit_info_screen.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_fullsize.dart';

class SuccessInfoScreen extends StatelessWidget {
  final String message;
  final String routeName;
  final Person person;
  final List<PersonDocument> personDocuments;

  const SuccessInfoScreen({
    required this.message,
    required this.routeName,
    required this.person,
    required this.personDocuments,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cardColor5,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: AppColors.textMain,
                    borderRadius: const BorderRadius.all(Radius.circular(12))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 80, bottom: 10),
                          child: Text(message)),
                        PersonCardFullSize(person: person, personDocuments: personDocuments),
                        ElevatedButton(
                          onPressed: () {
                            if(routeName == MainNavigationRouteNames.editPersonInfoScreen) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.editPersonInfoScreen,
                                  arguments: EditPersonScreenArguments(person: person)
                              );
                            } else {
                              Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.homeScreen);
                            }
                          },
                          child: Text("Продолжить"),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -75),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset("assets/icons/done2.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoScreenArguments {
  final String message;
  final String routeName;
  final Person person;
  final List<PersonDocument> personDocuments;

  const InfoScreenArguments({
    required this.message,
    required this.routeName,
    required this.person,
    required this.personDocuments
  });
}
