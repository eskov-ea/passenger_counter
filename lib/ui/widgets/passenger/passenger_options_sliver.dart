import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_state.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/screens/qr_scanner.dart';
import 'package:pleyona_app/ui/screens/status/edit_passengers_status.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class PassengerOptionsSliver extends StatelessWidget {
  PassengerOptionsSliver({super.key});

  final Color cardColor = AppColors.backgroundMainCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: BlocBuilder<CurrentTripBloc, CurrentTripState>(
        builder: (context, state) {
          if (state is InitializedCurrentTripState) {
            return Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 15,),
                  Ink(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.goNamed(
                            NavigationRoutes.passengerAddNewScreen.name
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/add-person.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Add", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Ink(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.goNamed(
                          NavigationRoutes.scannerScreen.name,
                          extra: ScannerScreenArguments(
                            setStateCallback: (result ) async {
                              final barcode = result.code;
                              final db = DBProvider.db;
                              final state = BlocProvider.of<CurrentTripBloc>(context).state as InitializedCurrentTripState;
                              final tripId = state.currentTrip.id;

                              final passenger = await db.getPassengerByBarcode(tripId: tripId, barcode: barcode!);
                              if (passenger == null) {
                                PopupManager.showInfoPopup(context, dismissible: true, type: PopupType.warning,
                                    message: "По данному баркоду пассажир не найден.");
                                return;
                              }
                              final statuses = await db.getPassengerStatuses(passengerId: passenger.id);
                              final document = await db.getPersonDocumentById(documentId: passenger.personDocumentId);
                              final seat = await db.getPassengerSeat(seatId: passenger.seatId);
                              final person = await db.getPersonById(personId: passenger.personId);

                              final passengerPerson = PassengerPerson(person: person, passenger: passenger, seat: seat, document: document, statuses: statuses);
                              context.goNamed(
                                  NavigationRoutes.editTripPassengersStatus.name,
                                  extra: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'OffBoard')
                              );
                              context.goNamed(
                                  NavigationRoutes.tripPassengerInfo.name,
                                  extra: TripFullPassengerInfoScreenArguments(passenger: passengerPerson)
                              );
                            },
                          allowedFormat: [BarcodeFormat.code128],
                          description: "Чтобы считать баркод пассажира наведите на него камеру. Код должен быть читаем и освещение должно быть достаточным для распознования, в противном случае вы можете использовать фонарик камеры."
                        )
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/barcode-icon-1.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Scan", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Ink(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.goNamed(
                            NavigationRoutes.editTripPassengersStatus.name,
                            extra: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'OffBoard')
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/exit-door-sign.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Сошел с судна", style: TextStyle(color: AppColors.textMain, fontSize: 18),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Ink(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.goNamed(
                            NavigationRoutes.editTripPassengersStatus.name,
                            extra: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'OnBoard')
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/back-to-school.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Вернулся",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMain, fontSize: 18)
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Ink(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () async {
                        context.goNamed(
                          NavigationRoutes.editTripPassengersStatus.name,
                          extra: EditTripPassengersStatusScreenArguments(tripId: state.currentTrip.id, statusName: 'CheckOut')
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/check-out.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Check-out", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
            );
          } else {
            return Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 15,),
                  Ink(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.goNamed(
                            NavigationRoutes.passengerAddNewScreen.name
                        );
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/add-person.png",
                              width: 40,
                              height: 40,
                              color: AppColors.textMain,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("Add", style: TextStyle(color: AppColors.textMain, fontSize: 20),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Ink(
                    width: MediaQuery.of(context).size.width - 45 - 100,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xF2576D8A),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: InkWell(
                      onTap: () {
                        print("Clicked!");
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: AppColors.backgroundMain5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Text("Выберите рейс для работы с пассажирами",
                          style: TextStyle(color: AppColors.textMain, fontSize: 18),
                          textAlign: TextAlign.center,
                        )
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      )
    );
  }
}
