import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/services/statuses/statuses_api_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/slidable_wrapper.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';


class PassengerFullInfoScreen extends StatefulWidget {
  final PassengerPerson passenger;
  const PassengerFullInfoScreen({
    required this.passenger,
    super.key
  });

  @override
  State<PassengerFullInfoScreen> createState() => _PassengerFullInfoScreenState();
}

class _PassengerFullInfoScreenState extends State<PassengerFullInfoScreen> {

  final TextStyle style = TextStyle(fontSize: 18, color: AppColors.backgroundMain2, fontWeight: FontWeight.w600);
  late final List<PassengerStatusValue> statuses;
  bool isPassengerInitialized = false;
  PersonDocument? personDocument;
  final DBProvider _db = DBProvider.db;


  @override
  void initState() {
    _db.getAvailableStatuses().then((value) {
      value.removeWhere((statusObj) => statusObj.statusName == "CheckIn");
      setState(() {
        statuses = value;
        isPassengerInitialized = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(child: null, scrollController: null),
      body: ThemeBackgroundWidget(
          child: Builder(builder: (context) {
            if (isPassengerInitialized) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    _personInfoBloc(),
                    const SizedBox(height: 40),
                    const Text('История статусов:', style: AppStyles.mainTitleTextStyle),
                    const SizedBox(height: 20),
                    _personStatusesBloc(),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          })
      ),
    );
  }

  Widget _personInfoBloc() {
    final Person p = widget.passenger.person;
    final Seat s = widget.passenger.seat;
    final PersonDocument d = widget.passenger.document;
    return Container(
      height: 250,
      decoration: const BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  p.photo != ""
                      ? Image.memory(base64Decode(p.photo),
                    fit: BoxFit.cover,
                    width: 80,
                    height: 120,
                  )
                      : Image.asset("assets/images/no_avatar.png",
                    fit: BoxFit.cover,
                    width: 80,
                    height: 120,
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('${p.lastname} ${p.firstname} ${p.middlename}', style: style),
                        Text('${p.birthdate}, ${p.gender} ${p.citizenship}', style: style),
                        Text('${d.name} ${d.description}', style: style),
                        Text('${p.phone} / ${p.email}', style: style),
                        Text('Родитель: Иванов Иван'),
                        p.comment == null ? SizedBox.shrink() : Text(p.comment!),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Text('${s.cabinNumber}${s.placeNumber} / ${s.barcode}', style: style),
            Text('${s.seatClass}, ${s.side} ${s.deck}, ${s.status}', style: style),
            s.comment == '' ? const SizedBox.shrink() : Text(s.comment)
          ],
        ),
      ),
    );
  }

  Widget _personStatusesBloc() {
    return Expanded(
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: ListView.builder(
            itemCount: widget.passenger.statuses.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final PassengerStatus s = widget.passenger.statuses[index];
              return Container(
                  height: 45,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 7),
                  decoration: const BoxDecoration(
                      color: Color(0xCCFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.status, style: style),
                        Text(dateToFullDateString(DateTime.parse(s.createdAt)), style: style)
                      ],
                    ),
                  )
              );
            }
        ),
      ),
    );
  }

}


class TripFullPassengerInfoScreenArguments {
  final PassengerPerson passenger;

  TripFullPassengerInfoScreenArguments({required this.passenger});
}

