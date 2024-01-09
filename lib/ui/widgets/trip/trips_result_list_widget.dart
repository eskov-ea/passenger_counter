import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/ui/widgets/trip/trip_card.dart';
import '../../../models/trip_model.dart';

class TripsResultList extends StatelessWidget {
  const TripsResultList({
    required this.isSearching,
    required this.trips,
    required this.callback,
    super.key
  });

  final bool isSearching;
  final List<Trip>? trips;
  final Function(Trip) callback;

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (trips == null) {
        return Center(
          child: Text("Произошла ошибка при загрузке рейсов"),
        );
      } else if (trips!.isEmpty) {
        return Center(
          child: Text("Не запланировано ни одного рейса"),
        );
      } else {
        return Container(
          height: 330,
          alignment: Alignment.topCenter,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: trips!.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              return TripCard(trip: trips![index], index: index, callback: callback);
            }
          ),
        );
      }
    }
  }
}
