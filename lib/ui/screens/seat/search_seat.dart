import 'package:flutter/material.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/ui/widgets/seats/seat_widget.dart';
import '../../../models/seat_model.dart';
import '../../../theme.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/theme_background.dart';

class SeatSearchScreen extends StatefulWidget {
  final Function(Seat) onResultCallback;
  final int tripId;
  const SeatSearchScreen({
    required this.onResultCallback,
    required this.tripId,
    super.key
  });

  @override
  State<SeatSearchScreen> createState() => _SeatSearchScreenState();
}

class _SeatSearchScreenState extends State<SeatSearchScreen> {

  List<Seat>? availableSeats;
  final DBProvider db = DBProvider.db;

  Future<void> getAvailableSeats() async {
    availableSeats = await db.getAvailableSeats(tripId: widget.tripId);
  }

  @override
  void initState() {
    db.getAvailableSeats(tripId: widget.tripId).then((seats) {
      setState(() {
        availableSeats = seats;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (availableSeats == null) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(
            scrollController: null,
            child: Text("Выберите место", style: AppStyles.mainTitleTextStyle)),
        body: ThemeBackgroundWidget(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Container(
                  height: 500,
                  child: GridView.builder(
                    itemCount: availableSeats!.length,
                    itemBuilder: (context, index) => SeatWidget(
                          seat: availableSeats![index],
                          callback: widget.onResultCallback,
                        ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}


class SeatSearchScreenArguments {
  final Function(Seat) onResultCallback;
  final int tripId;

  SeatSearchScreenArguments({required this.onResultCallback, required this.tripId});
}