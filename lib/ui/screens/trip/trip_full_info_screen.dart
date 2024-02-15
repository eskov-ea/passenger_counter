import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/passenger/all_trip_passengers.dart';
import 'package:pleyona_app/ui/screens/seat/trip_seats_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

class TripFullInfoScreenArguments {
  final Trip trip;
  TripFullInfoScreenArguments({required this.trip});
}

class TripFullInfoScreen extends StatefulWidget {
  final Trip trip;
  const TripFullInfoScreen({
    required this.trip,
    super.key
  });

  @override
  State<TripFullInfoScreen> createState() => _TripFullInfoScreenState();
}

class _TripFullInfoScreenState extends State<TripFullInfoScreen> {

  bool isInitialized = false;
  final DBProvider _db = DBProvider.db;
  late final List<PassengerStatusValue> statuses;
  late final List<PassengerPerson> passengers;
  final Map<String, List<PassengerPerson>> passengersByStatuses = {};


  void initializeTrip() async {
    passengers = await _db.getTripPassengersInfo(tripId: widget.trip.id);
    statuses = await _db.getAvailableStatuses();

    for (var status in statuses) {
      for (var pp in passengers) {
        print("initializeTrip ${pp.statuses}");
        if (pp.statuses.first.status == status.statusName) {

          if (passengersByStatuses.containsKey(status.statusName)) {
            passengersByStatuses[status.statusName]!.add(pp);
          } else {
            passengersByStatuses.addAll({
              status.statusName: [pp]
            });
          }
        }
      }
    }
    setState(() {
      isInitialized = true;
    });
  }
  void _openAllTripPassengersScreen() {
    context.pushNamed(
      NavigationRoutes.tripPassengers.name,
      extra: TripPassengersScreenArguments(tripPassengers: passengers)
    );
  }
  void _openTripSeatsScreen() {
    context.pushNamed(
      NavigationRoutes.tripSeatsScreen.name,
      extra: TripSeatsScreenArguments(tripId: widget.trip.id, passengers: passengers)
    );
  }

  @override
  void initState() {
    initializeTrip();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(child: null, scrollController: null),
        body: ThemeBackgroundWidget(
          child: Stack(
            children: [
              _optionsBlock(),
              _placeholderBloc()
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionsBlock() {
    return Column(
      children: [
        const SizedBox(height: 70),
        _tripNameBloc(),
        const SizedBox(height: 20),
        _tripPassengersStatus(),
        const SizedBox(height: 60),
        _optionButtons(label: 'Пассажиры', callback: _openAllTripPassengersScreen),
        const SizedBox(height: 20),
        _optionButtons(label: 'Каюто-места', callback: _openTripSeatsScreen),
        const SizedBox(height: 20),
        _optionButtons(label: 'Еще что-то', callback: (){}),
      ],
    );
  }

  Widget _placeholderBloc() {
    if (isInitialized) {
      return SizedBox.shrink();
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xCCFFFFFF)
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: AppColors.backgroundMain2,
        ),
      );
    }
  }

  Widget _tripNameBloc() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 120,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: isInitialized
        ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.trip.tripName, style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w500)),
          Text("Начало: ${dateToFullDateString(widget.trip.tripStartDate)}", style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w400)),
          Text("Конец: ${dateToFullDateString(widget.trip.tripEndDate)}", style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w400)),
        ],
      )
        : CircularProgressIndicator(color: AppColors.backgroundMain2)
    );
  }

  Widget _tripPassengersStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 120,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: isInitialized
        ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 60,
              crossAxisCount: 2),
          itemCount: statuses.length,
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: index == 0 ? Colors.white : index % 2 != 0 ? Colors.white : Colors.white70,
                  border: const Border.fromBorderSide(BorderSide(color: Colors.black26, width: 0.5)),
                  borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              child: Text("${statuses[index].statusName}: ${passengersByStatuses[statuses[index].statusName]?.length ?? "0"}",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
      )
        : Center(
          child: CircularProgressIndicator(),
      )
    );
  }

  Widget _optionButtons({required String label, required Function() callback}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: Ink(
          height: 50,
          decoration: const BoxDecoration(
              color: Color(0xCCFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(6))
          ),
          child: InkWell(
            onTap: callback,
            splashColor: const Color(0xFFFFFFFF),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(label, style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.arrow_right, color: AppColors.backgroundMain2),
                )
              ],
            ),
          )
        ),
      ),
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xCCFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(label, style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: Icon(Icons.arrow_right, color: AppColors.backgroundMain2),
          )
        ],
      ),
    );
  }
}
