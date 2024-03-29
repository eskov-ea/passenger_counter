import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_card.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/form_block_title.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

class CurrentTripPassengers extends StatefulWidget {
  const CurrentTripPassengers({
    super.key
  });

  @override
  State<CurrentTripPassengers> createState() => _CurrentTripPassengersState();
}

class _CurrentTripPassengersState extends State<CurrentTripPassengers> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(child: const Text("Все пассажиры",
          style: AppStyles.mainTitleTextStyle), scrollController: null),
      body: ThemeBackgroundWidget(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 150),
              Expanded(
                child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
                  builder: (context, state) {
                    if (state is InitializedCurrentTripState) {
                      if(state.tripPassengers.isEmpty) {
                        return Center(
                          child: Text("На данный рейс пассажиров не зарегистрировано"),
                        );
                      } else {
                        return SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.vertical,
                            itemCount: state.tripPassengers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PassengerCard(
                                passengerPerson: state.tripPassengers[index],
                                index: index,
                                navigationCallback: () {
                                  context.pushNamed(
                                      NavigationRoutes.currentTripPassengerInfo.name,
                                      extra: TripFullPassengerInfoScreenArguments(passenger: state.tripPassengers[index])
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Text("Не удалось загрузить пассажиров"),
                      );
                    }
                  },
                ),
              )
            ],
          )
        )
      ),
    );
  }
}
