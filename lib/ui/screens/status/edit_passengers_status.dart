import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
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
    final res = await db.getPassengersWithoutCurrentStatus(tripId: widget.tripId, statusName: widget.statusName);
    log('FindPassengersByCurrentStatus   $res');
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
          child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
            builder: (context, state) {
              if (state is InitializedCurrentTripState) {
                return Column(
                  children: [

                  ],
                );
              } else {
                return Container();
              }
            }
          )
        ),
      )
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
