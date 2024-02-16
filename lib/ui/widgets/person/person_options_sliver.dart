import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/person/person_edit_info_screen.dart';
import 'package:pleyona_app/ui/screens/person/person_search_screen.dart';

import '../../screens/person/person_add_new_screen.dart';


class PersonOptionsSliver extends StatelessWidget {
  PersonOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;


  @override
  Widget build(BuildContext context) {

    void navigateToEditScreen(Person person) {
      context.pushNamed(
          NavigationRoutes.editPersonInfoScreen.name,
          extra: EditPersonScreenArguments(person: person)
      );
    }

    return Material(
      color: AppColors.transparent,
      child: SizedBox(
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 15),
            Ink(
              width: 110,
              height: 120,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () {
                  context.push(
                    NavigationRoutes.addPersonScreen.path,
                    extra: AddNewPersonScreenArguments(parentId: null, routeName: null)
                  );
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                splashColor: AppColors.backgroundMain5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/add-person.png",
                      width: 40,
                      height: 40,
                      color: AppColors.textMain,
                    ),
                    const SizedBox(height: 10),
                    Text("Добавить", style: TextStyle(color: AppColors.textMain, fontSize: 16),)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15,),
            Ink(
              width: 110,
              height: 120,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () async {
                  context.push(
                    NavigationRoutes.searchPersonScreen.path,
                    extra: SearchPersonScreenArguments(callback: navigateToEditScreen)
                  );
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                splashColor: AppColors.backgroundMain5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/search-person.png",
                      width: 40,
                      height: 40,
                      color: AppColors.textMain,
                    ),
                    const SizedBox(height: 10),
                    Text("Все люди", style: TextStyle(color: AppColors.textMain, fontSize: 16),)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
