import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/trip/trip_edit_info.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/search_date_widget.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import 'package:pleyona_app/ui/widgets/trip/trips_result_list_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/route_model.dart';
import '../../../navigation/navigation.dart';


class AllTripsScreen extends StatefulWidget {
  const AllTripsScreen({super.key});

  @override
  State<AllTripsScreen> createState() => _AllTripsScreenState();
}

class _AllTripsScreenState extends State<AllTripsScreen> {


  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? filterDate;
  final ScrollController _scrollController = ScrollController();
  final DBProvider _db = DBProvider.db;
  List<TripModel>? trips;

  void goToDate(int year, int month, int day) {
    final date = DateTime(year, month, day);
    setState(() {
      _selectedDay = date;
    });
  }

  bool isCalendarOpen = false;
  bool isSearching = false;

  void toggleCalendar() {
    setState(() {
      isCalendarOpen = !isCalendarOpen;
    });
  }

  void searchTrips(DateTime? date) async {
    setState(() {
      isSearching = true;
    });
    List<TripModel> result = [];
    if (date != null) {
      result = await _db.searchTripsByDate(date);
    } else {
      result = await _db.getTrips();
    }
    String? filter;
    if (date != null) filter = "${date.day}.${date.month}.${date.year}";
    setState(() {
      trips = result;
      isSearching = false;
      filterDate = filter;
    });
  }

  void openEditTripScreen(TripModel trip) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.editTripScreen,
        arguments: TripEditInfoScreenArguments(trip: trip)
    );
  }

  @override
  void initState() {
    super.initState();
    searchTrips(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(scrollController: _scrollController, child: null,),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 90),
                  child: Text("Перейти к дате:",
                    style: TextStyle(fontSize: 20, color: AppColors.textMain),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  child: InputDateToSearchWidget(calendarCallback: searchTrips),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0x80FFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      border: Border.all(width: 1, color: AppColors.backgroundMain1)
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Календарь",
                        style: TextStyle(fontSize: 20, color: AppColors.backgroundMain2),
                      ),
                      GestureDetector(
                        onTap: toggleCalendar,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0x9FFFFFFF),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            // shape: BoxShape.circle
                          ),
                          width: 50,
                          height: 50,
                          child: Transform.rotate(
                            angle: isCalendarOpen ? pi : 2*pi,
                            child: Image.asset("assets/icons/down-arrow.png",
                              scale: 0.5, width: 30, height: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isCalendarOpen ? Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
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
                      searchTrips(_selectedDay);
                    },
                  ),
                ) : const SizedBox.shrink(),
                const SizedBox(height: 10,),
                _filterWidget(),
                const SizedBox(height: 40,),
                Text("Рейсы",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, color: AppColors.textMain),
                ),
                SizedBox(height: 10,),
                TripsResultList(
                  trips: trips,
                  isSearching: isSearching,
                  callback: openEditTripScreen,
                ),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterWidget() {
    return filterDate != null ?
    Stack(
      children: [
        Container(
          // width: MediaQuery.of(context).size.width,
          height: 30,
          padding: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Color(0x4DFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Text("Сбросить фильтр:  $filterDate",
            style: AppStyles.secondaryTextStyle,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: AppColors.transparent,
            child: Ink(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0x4DFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: InkWell(
                onTap: () {
                  searchTrips(null);
                },
                child: Icon(Icons.close),
              ),
            ),
          ),
        )
      ],
    )
    : const SizedBox(height: 30);
  }
}
