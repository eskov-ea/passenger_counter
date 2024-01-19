import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';

import '../../screens/person/person_add_new_screen.dart';


class PersonOptionsSliver extends StatelessWidget {
  PersonOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: SizedBox(
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 15),
            Ink(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(MainNavigationRouteNames.addPersonScreen,
                      arguments: AddNewPersonScreenArguments(parentId: null, routeName: null)
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
                    Text("Add", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15,),
            Ink(
              width: 150,
              height: 120,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pushNamed(MainNavigationRouteNames.allPersonsScreen);
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
                    Text("Все люди", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
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
