import 'package:flutter/material.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
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

  @override
  void initState() {

    final now = DateTime.now();
    final currentDay = DateTime(now.year, now.month, now.day);
    final startSearch = currentDay.subtract(const Duration(days: 3));
    final endSearch = currentDay.add(const Duration(days: 3));
    final Map<String, Trip?>? tripsForCurrentWeek;

    var count = 0;
    for (var i=startSearch.day; i<=endSearch.day; ++i) {
      final day = startSearch.add(Duration(days: count));
      ++count;

      print("CALENDAR::  ${day.weekday}");
    }

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
            child: _calendarChildBlock(),
          ),
        ),
      ),
    );
  }

  Widget _calendarChildBlock() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(onPressed: (){

            }, child: Text('press'))
        ],
      ),
    );
  }
}
