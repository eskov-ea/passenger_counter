import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/bloc/db_bloc/db_bloc.dart';
import 'package:pleyona_app/bloc/db_bloc/db_state.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/calendar_widget.dart';
import 'package:pleyona_app/ui/widgets/person/person_options_sliver.dart';
import 'package:pleyona_app/ui/widgets/title_decoration_container.dart';
import '../../bloc/db_bloc/db_event.dart';
import '../widgets/passenger/passenger_options_sliver.dart';
import '../widgets/trip/trip_options_sliver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  
  @override
  void initState() {
    BlocProvider.of<DBBloc>(context).add(InitializeDBEvent());
    BlocProvider.of<CurrentTripBloc>(context).add(InitializeCurrentTripEvent());

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: BlocBuilder<DBBloc, DBState>(
        builder: (context, state) {
          if (state is InitializedDBState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Container(
                      padding: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                      child: const TitleDecorationWidget(
                        child: Text("Пассажиры",
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      )
                  ),
                  PassengerOptionsSliver(),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: const TitleDecorationWidget(
                      child: Text("Ближайший рейс",
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  TripOptionsSliver(),
                  const SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: const TitleDecorationWidget(
                      child: Text("Люди",
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  PersonOptionsSliver(),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                    child: TitleDecorationWidget(
                      child: Text("Календарь рейсов",
                        style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  CalendarWidget(),
                  const SizedBox(height: 50)
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.backgroundMain4,
              ),
            );
          }
        }
      )
    );
  }
}
