import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/models/route_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/ui/screens/trip/trip_edit_info.dart';
import '../../../theme.dart';


class TripCard extends StatelessWidget {
  const TripCard({
    required this.trip,
    required this.callback,
    this.index = 0,
    super.key
  });

  final Function(TripModel trip) callback;
  String dateToString(DateTime date) {
    String hour = "";
    String minute = "";
    String day = "";
    String month = "";
    String year = "";

    if (date.hour < 10) {
      hour = "0${date.hour}";
    } else {
      hour = "${date.hour}";
    }

    if (date.minute < 10) {
      minute = "0${date.minute}";
    } else {
      minute = "${date.minute}";
    }

    if (date.day < 10) {
      day = "0${date.day}";
    } else {
      day = "${date.day}";
    }

    if (date.month < 10) {
      month = "0${date.month}";
    } else {
      month = "${date.month}";
    }

    year = "${date.year}";

    return "$day.$month.$year  $hour:$minute";
  }


  final Color firstColor = const Color(0xF2FFFFFF);
  final Color secondColor = const Color(0xD9FFFFFF);
  final TripModel trip;
  final int index;

  @override
  Widget build(BuildContext context) {

    void callFunction() {
      callback(trip);
    }

    return GestureDetector(
      onTap: callFunction,
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 10),
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
                Text(dateToString(trip.tripStartDate),
                  style: AppStyles.secondaryTextStyle,
                ),
                Text(dateToString(trip.tripEndDate),
                  style: AppStyles.secondaryTextStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
