import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';


class PersonOptionsSliver extends StatelessWidget {
  PersonOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Container(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 15,),
            Ink(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(MainNavigationRouteNames.addPersonScreen);
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                splashColor: AppColors.backgroundMain5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/icons/add-person.png",
                        width: 90,
                        height: 90,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Add", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                  ],
                ),
              ),
            ),
            SizedBox(width: 15,),
            Ink(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
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
                    Container(
                      child: Image.asset(
                        "assets/icons/search-person.png",
                        width: 90,
                        height: 90,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Все люди", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                  ],
                ),
              ),
            ),
            SizedBox(width: 15,),
          ],
        ),
      ),
    );
  }
}
