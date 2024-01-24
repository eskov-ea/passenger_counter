import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/ui/widgets/seats/seat_widget.dart';
import '../../../models/seat_model.dart';
import '../../../theme.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/theme_background.dart';

class SeatSearchScreen extends StatefulWidget {
  final Function(Seat) onResultCallback;
  final int tripId;
  final Person? person;
  const SeatSearchScreen({
    required this.onResultCallback,
    required this.tripId,
    required this.person,
    super.key
  });

  @override
  State<SeatSearchScreen> createState() => _SeatSearchScreenState();
}

class _SeatSearchScreenState extends State<SeatSearchScreen> {

  List<Seat>? availableSeats;
  Seat? parentSeat;
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
    if (widget.person != null) {
      db.getParentTripSeat(personId: widget.person!.parentId!, tripId: widget.tripId).then((seat) {
        setState(() {
          parentSeat = seat;
        });
      });
    }
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Свободные места:', style: TextStyle(fontSize: 24, color: Colors.white))),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: availableSeats!.length,
                    itemBuilder: (context, index) => SeatWidget(
                      seat: availableSeats![index],
                      callback: widget.onResultCallback,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4
                    )
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Место с родителем:', style: TextStyle(fontSize: 24, color: Colors.white))),
                const SizedBox(height: 10),
                if (parentSeat != null) Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SeatWidget(seat: parentSeat!, callback: widget.onResultCallback),
                      const VerticalDivider(width: 30, thickness: 2, color: Colors.white24),
                      Expanded(
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.white
                          ),
                          child: const Text(
                            "Вы можете назначить ребенку одно место с родителем. Один родитель - один ребенок.",
                            style: TextStyle(fontSize: 16, height: 1.1),
                          ),
                        )
                      )
                    ],
                  ),
                ) else const SizedBox.shrink(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
  final Person? person;

  SeatSearchScreenArguments({required this.onResultCallback, required this.tripId, required this.person});
}