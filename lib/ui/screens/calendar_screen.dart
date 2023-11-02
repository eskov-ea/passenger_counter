import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/search_date_widget.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {


  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void goToDate(int year, int month, int day) {
    final date = DateTime(year, month, day);
    setState(() {
      _selectedDay = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 70),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Перейти к дате:",
              style: TextStyle(fontSize: 20, color: AppColors.textMain),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: InputDateToSearchWidget(calendarCallback: goToDate),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.textMain
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 01, 01),
              lastDay: DateTime.utc(2035, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
          SizedBox(height: 40,),
          Text("Рейсы",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: AppColors.textMain),
          ),
          SizedBox(height: 10,),
          Text("Нет запланированных рейсов на выбранную дату",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          )
        ],
      ),
    );
  }
}
