import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/global/helpers.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/ui/widgets/slidable_wrapper.dart';
import '../../../theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    required this.trip,
    required this.callback,
    this.index = 0,
    super.key
  });

  final Function(Trip trip) callback;

  Future<void> _openAlertDialog(BuildContext context) async {
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
                await _deleteTrip();
                context.goNamed(
                    NavigationRoutes.allTripsScreen.name
                );
              },
            ),
            TextButton(
              child: const Text('Отменить'),
              onPressed: () {
                context.pop();
              },
            )
          ],
        );
      },
    );
  }

  //Todo: delete trip functionality
  Future<void> _deleteTrip() async {

  }


  final Color firstColor = const Color(0xF2FFFFFF);
  final Color secondColor = const Color(0xD9FFFFFF);
  final Trip trip;
  final int index;

  @override
  Widget build(BuildContext context) {

    void callFunction() {
      callback(trip);
    }

    return SlidableWrapperWidget(
      groupTag: 'trip',
      idKey: '',
      callback: _openAlertDialog,
      child: GestureDetector(
        onTap: callFunction,
        child: Container(
          height: 100,
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: index % 2 == 0 ? firstColor : secondColor,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(trip.tripName,
                style: AppStyles.submainTitleTextStyle,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(dateToFullDateString(trip.tripStartDate),
                    style: AppStyles.secondaryTextStyle,
                  ),
                  Text(dateToFullDateString(trip.tripEndDate),
                    style: AppStyles.secondaryTextStyle,
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );

    return Slidable(
      key: ValueKey(trip.id),
      groupTag: 'trip',
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: false,
            onPressed: _openAlertDialog,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6)
            ),
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: GestureDetector(
        onTap: callFunction,
        child: Container(
          height: 100,
          margin: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: index % 2 == 0 ? firstColor : secondColor,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(trip.tripName,
                style: AppStyles.submainTitleTextStyle,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(dateToFullDateString(trip.tripStartDate),
                    style: AppStyles.secondaryTextStyle,
                  ),
                  Text(dateToFullDateString(trip.tripEndDate),
                    style: AppStyles.secondaryTextStyle,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
