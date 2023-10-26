import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/theme.dart';


class CurrentRouteStatusWidget extends StatefulWidget {
  const CurrentRouteStatusWidget({Key? key}) : super(key: key);

  @override
  State<CurrentRouteStatusWidget> createState() => _CurrentRouteStatusWidgetState();
}

class _CurrentRouteStatusWidgetState extends State<CurrentRouteStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: AppColors.backgroundMain3,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          Text("Владивосток-Нанао",
            style: TextStyle(fontSize: 24, color: AppColors.textMain),
          ),
          Text("27.10.2023"),
        ],
      ),
    );
  }
}
