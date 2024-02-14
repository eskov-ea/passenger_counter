import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/trip/trip_full_info_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import 'package:pleyona_app/ui/widgets/trip/trip_card.dart';
import 'package:table_calendar/table_calendar.dart';

const Months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг',
    'Сен', 'Окт', 'Ноя', 'Дек'];
class TripEvent extends Event {
  final Trip trip;
  TripEvent({
    required this.trip,
    super.icon,
    super.title,
    super.dot,
    required super.date
  });

}

class TripsCalendarScreen extends StatefulWidget {
  const TripsCalendarScreen({super.key});

  @override
  State<TripsCalendarScreen> createState() => _TripsCalendarScreenState();
}

class _TripsCalendarScreenState extends State<TripsCalendarScreen> {

  String? filterDate;

  DateTime _currentDate = DateTime.now();
  List<Trip> _currentDateTrips = [];
  late String monthTitle;
  final EventList<TripEvent> _markedDateMap = EventList<TripEvent>(events: {});
  final DBProvider _db = DBProvider.db;
  bool isTripsProcessed = false;

  String _headerTextCallback(DateTime date) {
    return "${Months[date.month - 1]}, ${date.year}";
  }

  @override
  void initState() {
    monthTitle = _headerTextCallback(_currentDate);
    _db.getTrips().then((trips) {
      for (final trip in trips) {
        final calendarDate = DateTime(trip.tripStartDate.year, trip.tripStartDate.month, trip.tripStartDate.day);
        _markedDateMap.add(
            calendarDate,
            TripEvent(
                trip: trip,
                date: calendarDate,
                title: trip.tripName,
                dot: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey
                  ),
                )
                // icon: const Icon(Icons.circle, color: Color(0xBF12A2FD), size: 30)
            )
        );
      }
      final now = DateTime.now();
      _currentDateTrips = _markedDateMap.events[DateTime(now.year, now.month, now.day)]?.map((el) => el.trip).toList() ?? [];
      isTripsProcessed = true;
      setState(() {});
    });


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
                child: CalendarCarousel<TripEvent>(
                  onDayPressed: (date, List<TripEvent>events) {
                    _currentDate = date;
                    _currentDateTrips = events.map((e) => e.trip).toList();
                    print(_currentDateTrips);
                    setState(() {});
                  },
                  iconColor: Colors.black,
                  headerText: monthTitle,
                  headerTextStyle: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
                  markedDatesMap: _markedDateMap,
                  selectedDateTime: _currentDate,
                  showIconBehindDayText: true,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  markedDateShowIcon: true,
                  markedDateIconMaxShown: 1,

                  weekFormat: false,
                  firstDayOfWeek: 1,
                  weekDayFormat: WeekdayFormat.short,
                  daysTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                  weekendTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red),
                  customWeekDayBuilder: (int, String) {
                    return Container(
                      width: (MediaQuery.of(context).size.width - 60) / 7,
                      alignment: Alignment.center,
                      child: Text(String,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                            color: int == 6 || int == 5 ? Colors.red : Colors.black
                        ),
                      ),
                    );
                  },

                  selectedDayTextStyle: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,
                    background: Paint()..color = Colors.black
                      ..strokeWidth = 16
                      ..strokeJoin = StrokeJoin.round
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,
                    background: Paint()..color = Colors.red
                      ..strokeWidth = 16
                      ..strokeJoin = StrokeJoin.round
                      ..strokeCap = StrokeCap.round
                      ..style = PaintingStyle.stroke,
                  ),
                  markedDateIconBuilder: (event) {
                    return Transform.translate(
                      offset: const Offset(0, 23),
                      child: const Icon(Icons.circle, color: Colors.grey, size: 10)
                    );
                  },
                  markedDateMoreShowTotal: null,
                  minSelectedDate: _currentDate.subtract(Duration(days: 360)),
                  maxSelectedDate: _currentDate.add(Duration(days: 360)),
                  todayButtonColor: Colors.transparent,
                  todayBorderColor: Colors.transparent,
                  selectedDayButtonColor: Colors.transparent,

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
              ),
              const SizedBox(height: 40),
              Text('Рейсы', style: TextStyle(fontSize: 24, color: Color(0xFFFFFFFF))),
              const SizedBox(height: 10),
              isTripsProcessed
                ? Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: _currentDateTrips.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            ..._currentDateTrips.map((trip) => TripCard(trip: trip, callback: (trip){
                              context.goNamed(
                                NavigationRoutes.tripFullInfoScreen.name,
                                extra: TripFullInfoScreenArguments(trip: trip)
                              );
                            })).toList()
                          ],
                        ),
                    )
                    : Container (
                        height: 65,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Color(0xf2ffffff),
                        ),
                        alignment: Alignment.center,
                        child: Text('На эту дату рейсов не запланировано'),
                    ),
                )
                : Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 200,
                decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Color(0xf2ffffff),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator()
                    ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
