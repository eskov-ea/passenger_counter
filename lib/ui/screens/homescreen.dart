import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/bloc/db_bloc/db_bloc.dart';
import 'package:pleyona_app/bloc/db_bloc/db_state.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/person/person_options_sliver.dart';
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
      // color: AppColors.backgroundNeutral,
      child: BlocBuilder<DBBloc, DBState>(
        builder: (context, state) {
          if (state is InitializedDBState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100,),
                  Container(
                      padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
                      child: const Text("Пассажиры",
                        style: AppStyles.mainTitleTextStyle,
                      )
                  ),
                  PassengerOptionsSliver(),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                    child: const Text("Ближайший рейс",
                      style: AppStyles.mainTitleTextStyle,
                    ),
                  ),
                  TripOptionsSliver(),
                  Container(
                    padding: EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
                    child: const Text("Люди",
                      style: AppStyles.mainTitleTextStyle,
                    ),
                  ),
                  PersonOptionsSliver(),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                    child: const Text("Календарь рейсов",
                      style: AppStyles.mainTitleTextStyle,
                    ),
                  ),
                  const SizedBox(height: 50,)
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
