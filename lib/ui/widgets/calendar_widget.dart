import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';

const Map<int,String> weekDayIntToName = {
  1: "ПН",
  2: "ВТ",
  3: "СР",
  4: "ЧТ",
  5: "ПТ",
  6: "СБ",
  7: "ВС"
};

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  List<Trip>? trips;
  bool isInitialized = false;
  final Map<DateTime, List<Trip>> tripsForCurrentWeek = {};
  final DBProvider _db = DBProvider.db;

  @override
  void initState() {

    final now = DateTime.now();
    final startSearch = DateTime(now.year, now.month, now.day);
    final endSearch = startSearch.add(const Duration(days: 6));

    _db.searchTripByDateRange(dateStart: startSearch, dateEnd: endSearch).then((value) {
      trips = value;

      for (var i=0; i<7; ++i) {
        final date = startSearch.add(Duration(days: i));
        List<Trip>? dateTrip;
        dateTrip = value.where((el) => el.tripStartDate.day == date.day).toList();
        tripsForCurrentWeek.addAll({date: dateTrip});
      }

      setState(() {
        isInitialized = true;
      });

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: AppColors.transparent,
        child: Ink(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.backgroundMainCard,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(MainNavigationRouteNames.tripsCalendarScreen);
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            splashColor: AppColors.backgroundMain5,
            child: isInitialized ? _calendarChildBlock() : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _calendarChildBlock() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MainNavigationRouteNames.tripsCalendarScreen);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          padding: EdgeInsets.only(bottom: 15),
          itemBuilder: (context, index) {
            return _calendarDayItem(tripsForCurrentWeek.values.elementAt(index), tripsForCurrentWeek.keys.elementAt(index), index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 10);
          },
        )
      ),
    );
  }

  Widget _calendarDayItem(List<Trip> trips, DateTime date, int index) {
    return Container(
      width: (MediaQuery.of(context).size.width - 30 - 20 ) / 7 - 10,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          Container(
            height: trips.length > 1 ? 90.0 : trips.length == 1 ? 60.0 : 5.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: index == 0 ? Colors.pinkAccent : Color(0xFF04A979),
              border: Border.all(width: 1, color: Color(0xFFD0D0D0))
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 30,
            child: Text(weekDayIntToName[date.weekday]!,
              style: TextStyle(
                fontSize: 24, color: index == 0 ? Colors.pinkAccent : Color(0xFFFFFFFF), fontWeight: FontWeight.w600
              ),
            ),
          ),
          // const SizedBox(height: 10),
          Container(
            height: 30,
            child: Text(date.day.toString(),
              style: TextStyle(
                  fontSize: 24, color: index == 0 ? Colors.pinkAccent : Color(0xFFFFFFFF), fontWeight: FontWeight.w600
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
