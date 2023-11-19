import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/person_edit_info_screen.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_brief.dart';

import '../../services/database/db_provider.dart';


class AllPersonsScreen extends StatefulWidget {
  const AllPersonsScreen({super.key});

  @override
  State<AllPersonsScreen> createState() => _AllPersonsScreenState();
}

class _AllPersonsScreenState extends State<AllPersonsScreen> {

  final DBProvider _db = DBProvider.db;
  List<Person> persons = [];

  void readAllPersons() async {
    final List<Person> res =  await _db.getPersons();
    setState(() {
      persons = res;
    });
  }

  void navigateToEditScreen(Person person) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.editPersonInfoScreen,
      arguments: EditPersonScreenArguments(person: person)
    );
  }


  @override
  void initState() {
    // _db.DeveloperModeClearPersonTable();
    print(dateFormatter(DateTime.now()));
    readAllPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundNeutral,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 70,),
              const Text("Все персоны",
                style: AppStyles.mainTitleTextStyle,
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PersonCardBrief(person: persons[index], onTap: navigateToEditScreen);
                }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
