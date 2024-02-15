import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/person/person_edit_info_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_brief.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

import '../../../services/database/db_provider.dart';


class AllPersonsScreen extends StatefulWidget {
  const AllPersonsScreen({super.key});

  @override
  State<AllPersonsScreen> createState() => _AllPersonsScreenState();
}

class _AllPersonsScreenState extends State<AllPersonsScreen> {

  final DBProvider _db = DBProvider.db;
  List<Person> persons = [];

  void readAllPersons() async {
    final List<Person> res =  await _db.getPersons(null);
    setState(() {
      persons = res;
    });
  }

  void navigateToEditScreen(Person person) {
    context.pushNamed(
      NavigationRoutes.editPersonInfoScreen.name,
      extra: EditPersonScreenArguments(person: person)
    );
  }


  @override
  void initState() {
    readAllPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.backgroundNeutral,
        appBar: const CustomAppBar(scrollController: null, hideHomeButton: false, child: Text("Все персоны",
          style: AppStyles.mainTitleTextStyle,
        )),
        body: ThemeBackgroundWidget(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 50,),
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
      ),
    );
  }
}
