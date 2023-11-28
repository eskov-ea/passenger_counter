import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';

import 'current_trip_status_widget.dart';


class TripOptionsSliver extends StatelessWidget {
  TripOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 300,
          minHeight: 100
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 15,),
            CurrentTripStatusWidget(),
            SizedBox(width: 15,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Ink(
                  width: 142,
                  height: 142,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(MainNavigationRouteNames.addNewTripScreen);
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
                            "assets/icons/add-location.png",
                            width: 50,
                            height: 50,
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Добавить", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                      ],
                    ),
                  ),
                ),
                Ink(
                  width: 142,
                  height: 142,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(MainNavigationRouteNames.allTripsScreen);
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
                            "assets/icons/search.png",
                            width: 50,
                            height: 50,
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Все рейсы", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15,),
          ],
        ),
      ),
    );
  }
}
