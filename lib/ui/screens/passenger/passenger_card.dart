import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/models/passenger/passenger_person_combined.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/avatar.dart';

class PassengerCard extends StatelessWidget {
  const PassengerCard({
    required this.passengerPerson,
    this.index = 0,
    super.key
  });

  final PassengerPerson passengerPerson;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? AppColors.textMain : AppColors.cardColor3,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        children: [
          AvatarWidget(photo: passengerPerson.person.photo),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${passengerPerson.person.lastname} ${passengerPerson.person.firstname} ${passengerPerson.person.middlename}"),
                  Text("${passengerPerson.passenger.document}"),
                  Text("${passengerPerson.seat.cabinNumber}""${passengerPerson.seat.placeNumber}")
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
