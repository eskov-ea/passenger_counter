import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';


class SeatWithStatus {
  final Seat seat;
  final bool status;

  SeatWithStatus(this.seat, this.status);
}


class TripSeatsScreen extends StatefulWidget {
  const TripSeatsScreen({super.key});

  @override
  State<TripSeatsScreen> createState() => _TripSeatsScreenState();
}

class _TripSeatsScreenState extends State<TripSeatsScreen> {

  bool isInitialized = false;
  Map<int, SeatWithStatus>? seats;
  Person? seatPassenger;
  Seat? changingSeatPlace;
  late final StreamSubscription _subscription;

  void _readAndSortTripSeats() {
    final state = BlocProvider.of<CurrentTripBloc>(context).state;
    if (state is InitializedCurrentTripState) {
      seats = <int, SeatWithStatus>{};
      for (final seat in state.availableSeats) {
        seats!.addAll({seat.id: SeatWithStatus(seat, false)});
      }
      for (final seat in state.occupiedSeats) {
        seats!.addAll({seat.id: SeatWithStatus(seat, true)});
      }
    }
  }

  void _onStateChange(CurrentTripState state) {
    if (state is InitializedCurrentTripState) {
      _readAndSortTripSeats();
    }
  }

  Future<void> _openSeatInformation(Seat seat, List<PassengerPerson> passengers,
      List<Seat> availableSeats, List<PassengerPerson> allTripPassengers) async {
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
                    passengers.isEmpty
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
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  Person? parent;
                                  for (final tp in allTripPassengers) {
                                    if (tp.person.id == p.person.parentId) parent = tp.person;
                                  }

                                  final parentSeat = parent == null ? null : await DBProvider.db.getParentTripSeat(personId: parent.id, tripId: p.passenger.tripId);
                                  _openChangePassengerSeatDialog(availableSeats, parentSeat, p.passenger.id, p.passenger.tripId);
                                },
                                child: Text("Изменить место")
                              )
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

  Future<void> _openChangePassengerSeatDialog(List<Seat> as, Seat? os, int passengerId, int tripId) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Изменить место пассажира'),
                  insetPadding: EdgeInsets.symmetric(horizontal: 15),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, mainAxisExtent: 60, crossAxisSpacing: 10, mainAxisSpacing: 10),
                              itemCount: as.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      changingSeatPlace = as[index];
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: as[index].id == changingSeatPlace?.id ? const Color(0xFFF7FF02) : const Color(0xcc33d33a),
                                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                                        border: Border.all(width: 1, color: Color(0xC0000000))
                                    ),
                                    child: Text("${as[index].cabinNumber}${as[index].placeNumber}",
                                      style: AppStyles.submainTitleTextStyle,
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                        SizedBox(height: 20),
                        os != null ? GestureDetector(
                          onTap: () {
                            setState(() {
                              changingSeatPlace = os;
                            });
                          },
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: changingSeatPlace?.id == os.id ? const Color(0xFFF7FF02) : const Color(0xcce80606),
                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                      border: Border.all(width: 1, color: Color(0xC0000000))
                                  ),
                                  child: Text("${os.cabinNumber}${os.placeNumber}",
                                    style: AppStyles.submainTitleTextStyle,
                                  ),
                                ),
                                const VerticalDivider(width: 30, thickness: 2, color: Colors.white24),
                                Expanded(
                                    child: Container(
                                      height: 80,
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                          color: Colors.white
                                      ),
                                      child: const Text(
                                        "Вы можете назначить ребенку одно место с родителем. Один родитель - один ребенок.",
                                        style: TextStyle(fontSize: 15, height: 1.1),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ) : SizedBox.shrink()
                      ]
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Подтвердить',
                        style: TextStyle(color: changingSeatPlace == null ? Color(0x666f1dbb) : Color(0xff6f1dbb),
                            fontSize: 18, fontWeight: FontWeight.w500
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<CurrentTripBloc>(context).add(ChangePassengerSeatEvent(seatId: changingSeatPlace!.id, passengerId: passengerId, tripId: tripId));
                        setState(() {
                          changingSeatPlace = null;
                        });
                        Navigator.of(context).pop();
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
                        setState(() {
                          changingSeatPlace = null;
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
    _readAndSortTripSeats();
    _subscription = BlocProvider.of<CurrentTripBloc>(context).stream.listen(_onStateChange);

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
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
            child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
              builder: (context, state) {
                if (state is InitializedCurrentTripState) {
                  return Column(
                    children: [
                      _infoBloc(state),
                      _seatsBloc(state)
                    ],
                  );
                } else {
                  return Container(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.backgroundMain2),
                    ),
                  );
                }
              }
            )
          ),
        ),
      ),
    );
  }

  Widget _infoBloc(InitializedCurrentTripState state) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text("Менеджер кают",
            style: AppStyles.mainTitleTextStyle,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5 - 23,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const WidgetSpan(child: Icon(Icons.circle, color: Color(0xcc33d33a), size: 22)),
                      const WidgetSpan(child: SizedBox(width: 10,)),
                      WidgetSpan(child: Text("Свободно: ${state.availableSeats.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                    ]
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5 - 23,
                height: 30,
                decoration: const BoxDecoration(
                    color: Color(0xBCDEDEDE),
                    borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                      children: [
                        const WidgetSpan(child: Icon(Icons.circle, color: Color(0xcce80606), size: 22)),
                        const WidgetSpan(child: SizedBox(width: 10,)),
                        WidgetSpan(child: Text("Занято: ${state.occupiedSeats.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      ]
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: .8, color: Color(0x80000000))
        ],
      ),
    );
  }

  Widget _seatsBloc(InitializedCurrentTripState state) {
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
                  List<PassengerPerson> passengers = [];
                  for (final p in state.tripPassengers) {
                    if (p.passenger.seatId == seats![key]!.seat.id) {
                      passengers.add(p);
                    }
                  }
                  await _openSeatInformation(seats![key]!.seat, passengers, state.availableSeats, state.tripPassengers);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: seats![key]!.status ? const Color(0xcce80606) : const Color(0xcc33d33a),
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
}
