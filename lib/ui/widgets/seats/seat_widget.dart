import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/theme.dart';

class SeatWidget extends StatelessWidget {
  const SeatWidget({
    required this.seat,
    required this.callback,
    super.key
  });

  final Seat seat;
  final Function(Seat) callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(seat);
      },
      child: Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.secondary4,
          borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 6, left: 3, right: 3),
        child: Text("${seat.cabinNumber} ${seat.placeNumber}",
          style: TextStyle(fontSize: 20, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
