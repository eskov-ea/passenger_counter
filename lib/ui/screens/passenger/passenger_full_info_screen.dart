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
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
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
  final DBProvider _db = DBProvider.db;
  late final List<PassengerStatusValue> statuses;
  PassengerPerson? passenger;
  late final StreamSubscription streamSubscription;
  bool isStatusUpdating = false;
  int? activeStatusIndex;
  bool isPassengerInitialized = false;
  bool isErrorHappened = false;
  String? errorMessage;
  PersonDocument? personDocument;


  Future<void> _openUpdateStatusDialogWindow() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
    {
      return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Обновить статус пассажира'),
              content: Container(
                height: statuses.length <= 8 ? statuses.length * 30 +
                    statuses.length * 5 * 0.5 : 400,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Stack(
                  children: [
                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 60,
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5
                        ),
                        itemCount: statuses.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeStatusIndex = index;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: index == activeStatusIndex ? Color(
                                      0xcc96ff98) : Color(0xCCFFFFFF),
                                  borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: Text(statuses[index].statusName,
                                style: style,
                              ),
                            ),
                          );
                        }
                    ),
                    isStatusUpdating ? Container(
                      height: statuses.length <= 8 ? statuses.length * 30 +
                          statuses.length * 5 * 0.5 : 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Color(0xCCFFFFFF),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ) : SizedBox.shrink()
                  ]
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Добавить статус',
                    style: TextStyle(color: activeStatusIndex == null ? Color(0x666f1dbb) : Color(0xff6f1dbb),
                      fontSize: 18, fontWeight: FontWeight.w500
                    ),
                  ),
                  onPressed: () async {
                    if (activeStatusIndex == null) return;
                    setState(() {
                      isStatusUpdating = true;
                    });
                     BlocProvider.of<CurrentTripBloc>(context).add(AddNewPassengerStatusEvent(
                       passengerId: passenger!.passenger.id,
                       statusName: statuses[activeStatusIndex!].statusName
                     ));
                    Navigator.of(context).pop();
                    setState(() {
                      isStatusUpdating = false;
                      activeStatusIndex = null;
                    });
                  },
                ),
                TextButton(
                  child: const Text('Назад',
                    style: TextStyle(color: Color(0xff6f1dbb),
                        fontSize: 18, fontWeight: FontWeight.w500
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isStatusUpdating = false;
                      activeStatusIndex = null;
                    });
                  },
                ),
              ],
            );
          }
      );
    });
  }

  Future<void> _openDeleteStatusAlertDialog(PassengerStatus status) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить статус пассажира?'),
          actions: <Widget>[
            TextButton(
              child: Text('Удалить',
                style: TextStyle(color: activeStatusIndex == null ? Color(0x666f1dbb) : Color(0xff6f1dbb),
                    fontSize: 18, fontWeight: FontWeight.w500
                ),
              ),
              onPressed: () async {
                BlocProvider.of<CurrentTripBloc>(context).add(DeletePassengerStatusEvent(
                  statusId: status.id, passengerId: status.passengerId)
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Назад',
                style: TextStyle(color: Color(0xff6f1dbb),
                    fontSize: 18, fontWeight: FontWeight.w500
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: Container(
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
                    Text(status.status, style: style),
                    Text(dateToFullDateString(DateTime.parse(status.createdAt)), style: style)
                  ],
                ),
              )
          ),
        );
      }
    );
  }

  void _initializePassenger(InitializedCurrentTripState state) {
    for (var p in state.tripPassengers) {
      if (p.passenger.id == widget.passenger.passenger.id) {
        print('_onStateChange 3  ${p.statuses.length}');
        setState(() {
          passenger = p;
          isPassengerInitialized = true;
        });
      }
    }
  }

  void _onStateChange(CurrentTripState state) {
    print('_onStateChange 1  $state');
    if (state is InitializedCurrentTripState) {
      print('_onStateChange 2  $state');
      _initializePassenger(state);
    } else {
      setState(() {
        errorMessage = 'Произошла ошибка состояния приложения. Перезагрузите приложение или установите текущий рейс заново';
        isErrorHappened = true;
      });
    }
  }

  @override
  void initState() {
    _db.getAvailableStatuses().then((value) {
      setState(() {
        statuses = value;
      });
    });
    streamSubscription = BlocProvider.of<CurrentTripBloc>(context).stream.listen(_onStateChange);
    _onStateChange(BlocProvider.of<CurrentTripBloc>(context).state);

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
                  const SizedBox(height: 100),
                  _personInfoBloc(),
                  const SizedBox(height: 40),
                  const Text('История статусов:', style: AppStyles.mainTitleTextStyle),
                  const SizedBox(height: 20),
                  _updateStatusButton(),
                  const SizedBox(height: 20),
                  _personStatusesBloc(),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else if (isErrorHappened) {
            return Container();
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
      height: 200,
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
            return SlidableWrapperWidget(
              idKey: s.id.toString(),
              groupTag: 'status',
              callback: (context) {
                _openDeleteStatusAlertDialog(s);
              },
              child: Container(
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
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _updateStatusButton() {
    return Material(
        color: Colors.transparent,
        child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: const BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(6))
        ),
        child: InkWell(
          splashColor: const Color(0xFFFFFFFF),
          onTap: _openUpdateStatusDialogWindow,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text('Обновить статус',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.backgroundMain2),
            )
          )
        ),
      ),
    );
  }
}


class TripFullPassengerInfoScreenArguments {
  final PassengerPerson passenger;

  TripFullPassengerInfoScreenArguments({required this.passenger});
}
