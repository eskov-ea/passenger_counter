import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_card.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/form_block_title.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

class AllTripPassengers extends StatefulWidget {
  final List<PassengerPerson> tripPassengers;
  const AllTripPassengers({
    required this.tripPassengers,
    super.key
  });

  @override
  State<AllTripPassengers> createState() => _AllTripPassengersState();
}

class _AllTripPassengersState extends State<AllTripPassengers> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(child: null, scrollController: null),
      body: ThemeBackgroundWidget(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 100),
              BlockTitle(message: "Все пассажиры", alignment: Alignment.center),
              Expanded(
                child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
                  builder: (context, state) {
                    if (state is InitializedCurrentTripState && state.currentTrip != null) {
                      if(state.tripPassengers.isEmpty) {
                        return Center(
                          child: Text("На данный рейс пассажиров не зарегистрировано"),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.all(0),
                          scrollDirection: Axis.vertical,
                          itemCount: state.tripPassengers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PassengerCard(passengerPerson: state.tripPassengers[index], index: index,);
                          },
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

class TripPassengersScreenArguments {
  final List<PassengerPerson> tripPassengers;

  TripPassengersScreenArguments({required this.tripPassengers});
}
