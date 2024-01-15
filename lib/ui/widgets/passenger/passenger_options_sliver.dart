import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/status/edit_passengers_status.dart';


class PassengerOptionsSliver extends StatelessWidget {
  PassengerOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
        builder: (context, state) {
          if (state is InitializedCurrentTripState) {
            return Container(
              height: 120,
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
                              width: 40,
                              height: 40,
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
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () async {
                        // final db = await DBProvider.db;
                        // await db.DeveloperModeClearPersonTable();
                        // print("TABLE DELETE::::");
                        Navigator.of(context).pushNamed(MainNavigationRouteNames.editTripPassengersStatus,
                          arguments: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'CheckIn')
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
                              "assets/icons/check-in-desk.png",
                              width: 40,
                              height: 40,
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
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pushNamed(MainNavigationRouteNames.editTripPassengersStatus,
                            arguments: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'CheckOut')
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
                              "assets/icons/check-out.png",
                              width: 40,
                              height: 40,
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
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(MainNavigationRouteNames.editTripPassengersStatus,
                            arguments: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'OffBoard')
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
                              "assets/icons/exit-door-sign.png",
                              width: 40,
                              height: 40,
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
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(MainNavigationRouteNames.editTripPassengersStatus,
                            arguments: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'OnBoard')
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
                              "assets/icons/back-to-school.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Вернулся",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMain, fontSize: 18)
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
            );
          } else {
            return Container(
              height: 120,
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
                              width: 40,
                              height: 40,
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
                    width: MediaQuery.of(context).size.width - 45 - 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0x80304764),
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
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Text("Выберите рейс для работы с пассажирами",
                          style: TextStyle(color: AppColors.textMain, fontSize: 18),
                          textAlign: TextAlign.center,
                        )
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      )
    );
  }
}
