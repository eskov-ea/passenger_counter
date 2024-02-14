import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/passenger/passenger_full_info_screen.dart';
import 'package:pleyona_app/ui/widgets/avatar.dart';
import 'package:pleyona_app/ui/widgets/slidable_wrapper.dart';

class PassengerCard extends StatelessWidget {
  const PassengerCard({
    required this.passengerPerson,
    this.index = 0,
    super.key
  });

  final PassengerPerson passengerPerson;
  final int index;

  Future<void> _openDeleteAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы хотите удалить рейс?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Это действие нельзя будет отменить.'),
                Text('При удалении рейса будут удалены все пассажиры, зарегистрированные на этот рейс, багаж пассажиров, места. Контактная информация (Персона) о пассажирах удалена НЕ БУДЕТ'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Удалить'),
              onPressed: () async {
                BlocProvider.of<CurrentTripBloc>(context).add(DeleteTripPassengerEvent(
                  passengerId: passengerPerson.passenger.id)
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Отменить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SlidableWrapperWidget(
      groupTag: 'passenger',
      idKey: passengerPerson.passenger.id.toString(),
      callback: _openDeleteAlertDialog,
      child: GestureDetector(
        onTap: () {
          context.goNamed(
            NavigationRoutes.tripPassengerInfo.name,
            extra: TripFullPassengerInfoScreenArguments(passenger: passengerPerson)
          );
        },
        child: Container(
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: index % 2 == 0 ? AppColors.textMain : AppColors.cardColor3,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Row(
            children: [
              AvatarWidget(photo: passengerPerson.person.photo),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${passengerPerson.person.lastname} ${passengerPerson.person.firstname} ${passengerPerson.person.middlename}"),
                      Text("${passengerPerson.passenger.personDocumentId}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${passengerPerson.seat.cabinNumber} ${passengerPerson.seat.placeNumber}"),
                          Text("Статус: ${passengerPerson.statuses.first.status}")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
