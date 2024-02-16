import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';


class SeatWithStatus {
  final Seat seat;
  final List<PassengerPerson>? passengers;

  SeatWithStatus(this.seat, this.passengers);
}

class TripSeatsScreenArguments {
  final int tripId;
  final List<PassengerPerson> passengers;

  TripSeatsScreenArguments({required this.tripId, required this.passengers});
}


class TripSeatsScreen extends StatefulWidget {
  final TripSeatsScreenArguments tripSeatsScreenArguments;
  const TripSeatsScreen({
    required this.tripSeatsScreenArguments,
    super.key
  });

  @override
  State<TripSeatsScreen> createState() => _TripSeatsScreenState();
}

class _TripSeatsScreenState extends State<TripSeatsScreen> {

  bool isInitialized = false;
  Map<int, SeatWithStatus> seats = {};
  Person? seatPassenger;
  final DBProvider _db = DBProvider.db;

  void _readAndSortTripSeats() async {
    final allSeats = await _db.getSeats();
    seats = <int, SeatWithStatus>{};
    for (var passenger in widget.tripSeatsScreenArguments.passengers) {
      final int seatId = passenger.passenger.seatId;
      Seat? seat;
      try {
        seat = allSeats.firstWhere((element) => element.id == seatId);
        if (seats.containsKey(seat.id)) {
          seats[seat.id]!.passengers!.add(passenger);
        } else {
          seats.addAll({seatId: SeatWithStatus(seat, [passenger])});
        }
      } catch(_) {}
    }
    for (var seat in allSeats) {
      if (!seats.containsKey(seat.id)) {
        seats.addAll({seat.id: SeatWithStatus(seat, null)});
      }
    }
    setState(() {
      isInitialized = true;
    });
  }



  void _onStateChange(CurrentTripState state) {
    if (state is InitializedCurrentTripState) {
      _readAndSortTripSeats();
    }
  }

  Future<void> _openSeatInformation(Seat seat, List<PassengerPerson>? passengers) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Полная информация'),
                  insetPadding: EdgeInsets.symmetric(horizontal: 15),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 30, thickness: .8, color: Color(0x80000000)),
                      Text('Место: ${seat.cabinNumber}${seat.placeNumber}, класс: ${seat.seatClass}, баркод: ${seat.barcode}'),
                      Text('Сторона: ${seat.side}, дек: ${seat.deck}, статус: ${seat.status}'),
                      seat.comment != '' ? Text(seat.comment) : const SizedBox.shrink(),
                      const Divider(height: 30, thickness: .8, color: Color(0x80000000)),
                      passengers == null
                          ? Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text("Место свободно"),
                      )
                          : Column(
                        children: [
                          ...passengers.map((p) => Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text("ФИО: ${p.person.lastname} ${p.person.firstname.characters.first.toUpperCase()}. ${p.person.middlename.characters.first.toUpperCase()}."),
                                Text("${p.person.gender}, ${p.person.birthdate}, ${p.person.citizenship}"),
                                const SizedBox(height: 20)
                              ],
                            ),
                          )).toList()
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Готово',
                        style: TextStyle(color: Color(0xff6f1dbb),
                            fontSize: 18, fontWeight: FontWeight.w500
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
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
    _readAndSortTripSeats();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: const CustomAppBar(child: null, scrollController: null),
        body: Material(
          color: const Color(0xFFF9F9F9),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _infoBloc(),
                  _seatsBloc()
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget _infoBloc() {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text("Аналитика занятости кают",
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Container(
            // width: MediaQuery.of(context).size.width * 0.5 - 23,
            height: 30,
            decoration: const BoxDecoration(
                // color: Color(0xFFE8E8E8),
                borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                  children: [
                    WidgetSpan(child: Text("Каюта занята:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                    const WidgetSpan(child: SizedBox(width: 10,)),
                    const WidgetSpan(child: Icon(Icons.circle, color: Color(0xccffd1d7), size: 22)),
                  ]
              ),
            ),
          ),
          const Divider(height: 30, thickness: .8, color: Color(0x80000000))
        ],
      ),
    );
  }

  Widget _seatsBloc() {
    log("SEATS   $seats");
    if (seats == null) {
      return Container(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.backgroundMain2),
        ),
      );
    } else {
      return Expanded(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisExtent: 60, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: seats!.length,
            itemBuilder: (context, index) {
              int key = seats!.keys.elementAt(index);
              return GestureDetector(
                onTap: () async {
                  await _openSeatInformation(seats![key]!.seat, seats![key]!.passengers);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: seats![key]!.passengers == null ? const Color(0xffe5e5e5) : const Color(0xccffd1d7),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(width: 1, color: Color(0xC0000000))
                  ),
                  child: Text("${seats![key]!.seat.cabinNumber}${seats![key]!.seat.placeNumber}",
                    style: AppStyles.submainTitleTextStyle,
                  ),
                ),
              );
            }),
      );
    }
  }

  // Widget _suitesItems() {
  //   final int margin = 70;
  //   return Container(
  //     width: MediaQuery.of(context).size.width - 60,
  //     child: Wrap(
  //       direction: Axis.horizontal,
  //       alignment: WrapAlignment.spaceBetween,
  //       children: seatsByCabinNumber.entries.map(
  //               (cabin) {
  //             final koef = cabin.value.length == 4 ? 0 : 5;
  //             return Container(
  //               width: (MediaQuery.of(context).size.width - 60 - koef) / 4 * cabin.value.length,
  //               height: 80,
  //               margin: EdgeInsets.only(bottom: 10),
  //               padding: EdgeInsets.symmetric(vertical: 5),
  //               alignment: Alignment.bottomLeft,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.all(Radius.circular(6)),
  //                   color: Colors.blueGrey.shade200
  //               ),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.only(right: 10),
  //                     alignment: Alignment.bottomRight,
  //                     child: Text('Каюта ${cabin.key}',
  //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //                     ),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: cabin.value.map((suite) => GestureDetector(
  //                       onTap: () async {
  //                         await _openSeatInformation(seats![key]!.seat, passengers, state.availableSeats, state.tripPassengers);
  //                       },
  //                       child: Container(
  //                         width: (MediaQuery.of(context).size.width - 60 - 40 - 2 * koef) / 4,
  //                         height: 40,
  //                         decoration: BoxDecoration(
  //                             color: suite.status == 0 ? Colors.red.shade100 : Colors.green.shade100,
  //                             borderRadius: BorderRadius.all(Radius.circular(6))
  //                         ),
  //                         child: Container(
  //                             padding: EdgeInsets.only(right: 5),
  //                             alignment: Alignment.bottomRight,
  //                             child: Text(suite.placeNumber,
  //                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
  //                             )
  //                         ),
  //                       ),,
  //                     )).toList(),
  //                   )
  //                 ],
  //               ),
  //             );
  //           }
  //       ).toList(),
  //     ),
  //   );
  // }
}
