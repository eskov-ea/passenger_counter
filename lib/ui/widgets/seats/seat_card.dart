import 'package:flutter/material.dart';
import 'package:pleyona_app/models/seat_model.dart';

class SeatCard extends StatelessWidget {
  final Seat seat;
  const SeatCard({
    required this.seat,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: const Color(0xF2FFFFFF),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text("${seat.cabinNumber}${seat.placeNumber}",
            style: TextStyle(fontSize: 24),
          ),
          const Divider(),
          Text("Дополнительная информация тут")
          // Text("${seat.deck}, ${seat.barcode}, ${seat.status}, ${seat.seatClass}, ${seat.side}, ${seat.comment}")
        ],
      ),
    );
  }
}
