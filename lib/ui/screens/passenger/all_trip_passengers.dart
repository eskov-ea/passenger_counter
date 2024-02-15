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

class AllTripPassengers extends StatelessWidget {
  final List<PassengerPerson> tripPassengers;
  const AllTripPassengers({
    required this.tripPassengers,
    super.key
  });

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
                child:  tripPassengers.isEmpty
                  ? Center(
                    child: Text("На данный рейс пассажиров не зарегистрировано"),
                  )
                  : SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        itemCount: tripPassengers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PassengerCard(
                            passengerPerson: tripPassengers[index],
                            index: index,
                            navigationCallback: () {
                              context.pushNamed(
                                NavigationRoutes.tripPassengerInfo.name,
                                extra: TripFullPassengerInfoScreenArguments(passenger: tripPassengers[index])
                              );
                            },
                          );
                        },
                      ),
                    )
              )
            ],
          )
        )
      ),
    );
  }
}

class TripPassengersScreenArguments {
  final List<PassengerPerson> tripPassengers;

  TripPassengersScreenArguments({required this.tripPassengers});
}
