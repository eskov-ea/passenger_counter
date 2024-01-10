import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';

import '../../../models/trip_model.dart';
import '../../../navigation/navigation.dart';

class CurrentTripStatusWidget extends StatefulWidget {
  const CurrentTripStatusWidget({super.key});

  @override
  State<CurrentTripStatusWidget> createState() =>
      _CurrentTripStatusWidgetState();
}

class _CurrentTripStatusWidgetState extends State<CurrentTripStatusWidget> {

  void onCurrentTripSet(Trip trip) {
    BlocProvider.of<CurrentTripBloc>(context).add(SetNewCurrentTripEvent(tripId: trip.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentTripBloc, CurrentTripState>(
        builder: (context, state) {
      if (state is NoCurrentTripState) {
        return Material(
          color: AppColors.transparent,
          child: Ink(
            decoration: BoxDecoration(
                color: AppColors.backgroundMainCard,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: InkWell(
              onTap: () {},
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              splashColor: AppColors.backgroundMain5,
              child: Container(
                height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("На данную дату не найдено рейса",
                      style: TextStyle(fontSize: 20, color: Color(0xE6FFFFFF))
                    ),
                    SizedBox(height: 20),
                    const Divider(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(
                            MainNavigationRouteNames.tripSearchScreen,
                            arguments: TripSearchScreenArguments(onResultCallback: onCurrentTripSet)
                        );
                      },
                      child: Text("Установить текущий рейс",
                        style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2)
                      )
                    )
                  ],
                )
              ),
            )
          )
        );
      } else if (state is InitializedCurrentTripState) {
        return Material(
          color: AppColors.transparent,
          child: Ink(
            decoration: BoxDecoration(
                color: AppColors.backgroundMainCard,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(MainNavigationRouteNames.tripFullInfoScreen);
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              splashColor: AppColors.backgroundMain5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text.rich(TextSpan(
                        text: "Направление: ",
                        style: TextStyle(
                            fontSize: 16, color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: state.currentTrip.tripName,
                            style: TextStyle(
                                fontSize: 22, color: AppColors.textMain),
                          )
                        ])),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Дата: ",
                          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 60,
                          child: Column(
                            children: [
                              Text(dateToTimeString(state.currentTrip.tripStartDate),
                                style: TextStyle(fontSize: 30, color: AppColors.textMain),
                                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                              ),
                              // SizedBox(height: 10),
                              Text(dateToDateString(state.currentTrip.tripStartDate),
                                style: TextStyle(fontSize: 18, color: AppColors.textMain),
                                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 60,
                          child: Column(
                            children: [
                              Text(dateToTimeString(state.currentTrip.tripEndDate),
                                style: TextStyle(fontSize: 30, color: AppColors.textMain),
                                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                              ),
                              // SizedBox(height: 10),
                              Text(dateToDateString(state.currentTrip.tripEndDate),
                                style: TextStyle(fontSize: 18, color: AppColors.textMain),
                                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.textFaded,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: Text("На борту:".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, color: AppColors.textMain)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: Text("Свободно:".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, color: AppColors.textMain)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: Text(state.tripPassengers.length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 72, color: AppColors.textMain)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: Text(state.availableSeats.length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 72, color: AppColors.textMain)),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(TextSpan(
                        text: "Сошли с судна: ",
                        style: TextStyle(
                            fontSize: 16, color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                            text: "--",
                            style: TextStyle(
                                fontSize: 22, color: AppColors.textMain),
                          )
                        ])),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.backgroundMainCard,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Center(
              child: CircularProgressIndicator()
            )
        );
      }
    });
  }
}
