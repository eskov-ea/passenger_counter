import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

import '../widgets/CurrentRouteStatusWidget.dart';
import '../widgets/passenger_options_sliver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColors.backgroundNeutral,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Text("Пассажиры",
                style: TextStyle(fontSize: 34, color: Color(0xFF000000), fontWeight: FontWeight.w600),
              ),
            ),
            PassengerOptionsSliver(),
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 20, top: 20),
              child: Text("Ближайший рейс",
                style: TextStyle(fontSize: 34, color: Color(0xFF000000), fontWeight: FontWeight.w600),
              ),
            ),
            CurrentRouteStatusWidget(),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
