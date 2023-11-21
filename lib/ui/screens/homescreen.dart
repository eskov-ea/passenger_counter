import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/camera_bloc/camera_bloc.dart';
import 'package:pleyona_app/bloc/camera_bloc/camera_event.dart';
import 'package:pleyona_app/bloc/db_bloc/db_bloc.dart';
import 'package:pleyona_app/bloc/db_bloc/db_state.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/current_route_status_widget.dart';
import '../../bloc/db_bloc/db_event.dart';
import '../../navigation/navigation.dart';
import '../widgets/passenger_options_sliver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  
  @override
  void initState() {
    BlocProvider.of<DBBloc>(context).add(InitializeDBEvent());

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Пассажиры",
                            style: AppStyles.mainTitleTextStyle,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(MainNavigationRouteNames.allPersonsScreen);
                            },
                            child: SizedBox(
                              height: 30,
                              child: Text("Все пассажиры",
                                style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),

                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  PassengerOptionsSliver(),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                    child: const Text("Ближайший рейс",
                      style: AppStyles.mainTitleTextStyle,
                    ),
                  ),
                  const CurrentRouteStatusWidget(),
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
