import 'package:flutter/material.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import '../../../models/route_model.dart';
import '../../../services/database/db_provider.dart';
import '../../widgets/search_date_widget.dart';
import '../../widgets/trip/trips_result_list_widget.dart';

class TripSearchScreen extends StatefulWidget {
  const TripSearchScreen({
    required this.onResultCallback,
    super.key
  });

  final Function() onResultCallback;

  @override
  State<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _TripSearchScreenState extends State<TripSearchScreen> {

  bool isSearching = false;
  List<TripModel>? trips;
  final DBProvider _db = DBProvider.db;
  String? filterDate;


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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(child: null, scrollController: null),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 100),
              InputDateToSearchWidget(calendarCallback: searchTrips),
              const SizedBox(height: 20),
              TripsResultList(trips: [], isSearching: isSearching)
            ],
          ),
        ),
      ),
    );
  }
}

class TripSearchScreenArguments {
  final Function() onResultCallback;

  const TripSearchScreenArguments({required this.onResultCallback});
}