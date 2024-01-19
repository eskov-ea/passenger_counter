import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import 'package:table_calendar/table_calendar.dart';

const Months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг',
    'Сен', 'Окт', 'Ноя', 'Дек'];

class TripsCalendarScreen extends StatefulWidget {
  const TripsCalendarScreen({super.key});

  @override
  State<TripsCalendarScreen> createState() => _TripsCalendarScreenState();
}

class _TripsCalendarScreenState extends State<TripsCalendarScreen> {

  String? filterDate;

  DateTime _currentDate = DateTime.now();
  late String monthTitle;
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});
  late final CalendarCarousel<Event> _calendarCarousel;

  String _headerTextCallback(DateTime date) {
    return Months[date.month - 1];
  }

  @override
  void initState() {
    monthTitle = _headerTextCallback(_currentDate);
    _markedDateMap.add(
        DateTime(2024, 1, 15),
        Event(
          date: DateTime(2024, 1, 15),
          location: "DDD",
          title: "EVENT",
          // icon: Icon(Icons.circle, color: Color(0xBF12A2FD), size: 40),
          dot: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xBFE684FF)
            ),
            width: 40,
            height: 40
          )
        )
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ThemeBackgroundWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(child: Text('Календарь', style: AppStyles.mainTitleTextStyle), scrollController: null, hideHomeButton: true),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80, width: double.infinity),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 350,
                decoration: const BoxDecoration(
                  color: Color(0xf2ffffff),
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: CalendarCarousel<Event>(
                  onDayPressed: (date, events) {
                    _currentDate = date;
                    setState(() {});
                    events.forEach((event) => print("CALENDAR event ${event}"));
                  },
                  weekendTextStyle: TextStyle(
                    color: Colors.black, fontSize: 16
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  weekDayFormat: WeekdayFormat.short,
                  headerText: monthTitle,
                  weekFormat: false,
                  markedDatesMap: _markedDateMap,
                  height: 250.0,
                  selectedDateTime: _currentDate,
                  showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  markedDateShowIcon: true,
                  markedDateIconMaxShown: 2,
                  selectedDayTextStyle: TextStyle(
                    color: Colors.yellow,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  markedDateIconBuilder: (event) {
                    return event.icon ?? Icon(Icons.radar, size: 30, color: Color(0xbfcfcfcf),);
                  },
                  minSelectedDate: _currentDate.subtract(Duration(days: 360)),
                  maxSelectedDate: _currentDate.add(Duration(days: 360)),
                  todayButtonColor: Colors.transparent,
                  todayBorderColor: Colors.green,
                  markedDateMoreShowTotal: true,

                  onCalendarChanged: (date) {
                    print("CALENDAR change  $date");
                    monthTitle = _headerTextCallback(date);
                    setState(() {});
                  },
                  onLeftArrowPressed: () {
                    print("CALENDAR change l  $_currentDate");
                  },
                  onRightArrowPressed: () {
                    print("CALENDAR change r  $_currentDate");
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
