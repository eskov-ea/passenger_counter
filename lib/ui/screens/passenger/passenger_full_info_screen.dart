import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/passenger/passenger_status.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';


class PassengerFullInfoScreen extends StatefulWidget {
  PassengerPerson passenger;
  PassengerFullInfoScreen({
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
  bool isStatusUpdating = false;
  int? activeStatusIndex;


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
                    final statusId = await _db.addPassengerStatus(passengerId: widget.passenger.passenger.id, statusName: statuses[activeStatusIndex!].statusName);
                    final newStatus = PassengerStatus(
                      id: statusId,
                      passengerId: widget.passenger.passenger.id,
                      status: statuses[activeStatusIndex!].statusName,
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString()
                    );
                    widget.passenger.statuses.insert(0, newStatus);
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

  @override
  void initState() {
    _db.getAvailableStatuses().then((value) {
      setState(() {
        statuses = value;
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
        child: Container(
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
        ),
      ),
    );
  }

  Widget _personInfoBloc() {
    final Person p = widget.passenger.person;
    final Seat s = widget.passenger.seat;
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text('${p.lastname} ${p.firstname} ${p.middlename}', style: style),
                        Text('${p.birthdate}, ${p.gender} ${p.citizenship}', style: style),
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
