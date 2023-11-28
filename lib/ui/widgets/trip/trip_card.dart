import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/models/route_model.dart';
import '../../../theme.dart';


class TripCard extends StatelessWidget {
  const TripCard({
    required this.trip,
    required this.index,
    super.key
  });

  String dateToString(DateTime date) {
    return "${date.day}.${date.month}.${date.year}  ${date.hour}:${date.minute}";
  }

  final Color firstColor = const Color(0xF2FFFFFF);
  final Color secondColor = const Color(0xD9FFFFFF);
  final TripModel trip;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
