import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';


class EditTripPassengersStatus extends StatefulWidget {
  final int tripId;
  final String statusName;
  const EditTripPassengersStatus({
    required this.statusName,
    required this.tripId,
    super.key
  });

  @override
  State<EditTripPassengersStatus> createState() => _EditTripPassengersStatusState();
}

class _EditTripPassengersStatusState extends State<EditTripPassengersStatus> {

  bool isInitialized = false;
  PassengerStatusValue? status;
  List<Passenger>? passengers;
  List<Person>? persons;
  Map<int, bool> checkValues = <int, bool>{};
  bool isUpdating = false;
  final DBProvider db = DBProvider.db;


  Future<void> _findCurrentStatus() async {
    final availableStatuses = await db.getAvailableStatuses();
    for (var availableStatus in availableStatuses) {
      if (availableStatus.statusName == widget.statusName) {
        status = availableStatus;
      }
    }
  }

  Future<void> _findPassengersByCurrentStatus() async {
    final cPassengers = await db.getPassengersWithoutCurrentStatus(tripId: widget.tripId, statusName: widget.statusName);
    final List<int> ids = cPassengers.map((e) => e.personId).toList();
    final cPersons = await db.getPersons(ids);
    for (var passenger in cPassengers) {
      checkValues.addAll({passenger.id: false});
    }
    setState(() {
      persons = cPersons;
      passengers = cPassengers;
    });
  }
  Future<void> _updateStatuses() async {
    setState(() {
      isUpdating = true;
    });
    checkValues.forEach((key, value) async {
      if (value) {
        final status = await db.addPassengerStatus(passengerId: key, statusName: widget.statusName);
        log('Updated status  $status');
      }
    });
    await _findPassengersByCurrentStatus();
    setState(() {
      isUpdating = false;
    });
  }

  @override
  void initState() {
    _findCurrentStatus();
    _findPassengersByCurrentStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(child: null, scrollController: null),
        body: ThemeBackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
              builder: (context, state) {
                if (state is InitializedCurrentTripState) {
                  if (passengers != null && persons != null) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 80, width: MediaQuery.of(context).size.width),
                            Text(widget.statusName, style: AppStyles.mainTitleTextStyle),
                            const SizedBox(height: 20),
                            Expanded(
                              child: passengers!.length > 0
                              ? ListView.builder(
                                itemCount: passengers!.length,
                                itemBuilder: (context, index) {
                                  return _passengersOptions(passengers![index], persons![index]);
                              })
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Color(0xCFFFFFFF),
                                        borderRadius: BorderRadius.all(Radius.circular(6))
                                    ),
                                    child: const Text('Нет пассажиров, которым можно было бы присвоить данный статус',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              )
                            ),
                            const SizedBox(height: 20),
                            SaveButton(
                              onTap: _updateStatuses,
                              label: "Обновить статус"
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                        isUpdating ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color(0xBFFFFFFF),
                            borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xBF1131FF),
                            ),
                          ),
                        ) : const SizedBox.shrink()
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  return Container();
                }
              }
            ),
          )
        ),
      )
    );
  }

  Widget _passengersOptions(Passenger passenger, Person person) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xBFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: Row(
        children: [
          Checkbox(
            value: checkValues[passenger.id],
            onChanged: (value) {
              setState(() {
                checkValues[passenger.id] = value ?? false;
              });
            }
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7 -20,
            child: Text("${person.lastname} ${person.firstname} ${person.middlename}"),
          )
        ],
      ),
    );
  }
}


class EditTripPassengersStatusScreenArguments {
  final int tripId;
  final String statusName;

  const EditTripPassengersStatusScreenArguments({
    required this.statusName,
    required this.tripId
  });
}
