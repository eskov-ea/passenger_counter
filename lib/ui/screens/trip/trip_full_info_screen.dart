import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

class TripFullInfoScreen extends StatefulWidget {
  const TripFullInfoScreen({super.key});

  @override
  State<TripFullInfoScreen> createState() => _TripFullInfoScreenState();
}

class _TripFullInfoScreenState extends State<TripFullInfoScreen> {

  bool isInitialized = false;
  Trip? currentTrip;
  final DBProvider _db = DBProvider.db;
  late final CurrentTripBloc _bloc;
  late final List<PassengerStatusValue> statuses;
  late final List<Passenger> checkInPassengers;


  void initializeCurrentTrip() async {
    if(_bloc.state is InitializedCurrentTripState) {
      final bstate = _bloc.state as InitializedCurrentTripState;
      currentTrip = bstate.currentTrip;
      await _readPassengerStatusValues();
      setState(() {
        isInitialized = true;
      });
    }
  }

  Future<void> _readPassengerStatusValues() async {
    checkInPassengers = await _db.getPassengersByStatusName(tripId: currentTrip!.id, statusName: 'CheckIn');

  }

  @override
  void initState() {
    _bloc = BlocProvider.of<CurrentTripBloc>(context);
    initializeCurrentTrip();
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
        _optionButtons(label: 'Пассажиры', callback: (){}),
        const SizedBox(height: 20),
        _optionButtons(label: 'Каюто-места', callback: (){}),
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
          Text(currentTrip!.tripName, style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w500)),
          Text("Начало: ${dateToFullDateString(currentTrip!.tripStartDate)}", style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w400)),
          Text("Конец: ${dateToFullDateString(currentTrip!.tripEndDate)}", style: const TextStyle(fontSize: 20, color: Color(0xFF000000), fontWeight: FontWeight.w400)),
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
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5 -20,
                child: Text("CheckIn: ${checkInPassengers.length}"),
              )
            ],
          ),
          Column(
            children: [],
          )
        ],
      ),
    );
  }

  Widget _optionButtons({required String label, required Function callback}) {
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
