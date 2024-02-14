import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';

import 'current_trip_status_widget.dart';


class TripOptionsSliver extends StatelessWidget {
  TripOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;

  @override
  Widget build(BuildContext context) {
    void onCurrentTripSet(Trip trip) {
      BlocProvider.of<CurrentTripBloc>(context).add(SetNewCurrentTripEvent(tripId: trip.id));
      Navigator.of(context).pop();
    }
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
                      context.goNamed(
                          NavigationRoutes.addNewTripScreen.name
                      );
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
                      context.goNamed(
                          NavigationRoutes.allTripsScreen.name
                      );
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
                    onTap: () async {
                      context.goNamed(
                        NavigationRoutes.tripSearchScreen.name,
                        extra: TripSearchScreenArguments(onResultCallback: onCurrentTripSet)
                      );
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
                            "assets/icons/change-trip-icon-2.png",
                            width: 50,
                            height: 50,
                            color: AppColors.textMain,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Сменить текущий рейс",
                          style: TextStyle(color: AppColors.textMain, fontSize: 20),
                          textAlign: TextAlign.center,
                        )
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
