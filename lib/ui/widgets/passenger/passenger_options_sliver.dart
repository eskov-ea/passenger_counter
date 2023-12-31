import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';


class PassengerOptionsSliver extends StatelessWidget {
  PassengerOptionsSliver({super.key});

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
                  Navigator.of(context).pushNamed(MainNavigationRouteNames.passengerAddNewScreen);
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
                  final db = await DBProvider.db;
                  await db.DeveloperModeClearPersonTable();
                  print("TABLE DELETE::::");
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
                        "assets/icons/check-in-desk.png",
                        width: 90,
                        height: 90,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Check-in", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
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
                  final res = await DBProvider.db.getPassengers(tripId: 4);
                  log(res[0].toString(), level: 10);
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
                        "assets/icons/check-out.png",
                        width: 90,
                        height: 90,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Check-out", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
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
                onTap: () {
                  print("Clicked!");
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
                        "assets/icons/exit-door-sign.png",
                        width: 90,
                        height: 90,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Сошел с судна", style: TextStyle(color: AppColors.textMain, fontSize: 18),)
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
                onTap: () {
                  print("Clicked!");
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
                        "assets/icons/back-to-school.png",
                        width: 90,
                        height: 90,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Вернулся на судно", style: TextStyle(color: AppColors.textMain, fontSize: 18),)
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
