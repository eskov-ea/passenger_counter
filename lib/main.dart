import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:pleyona_app/bloc/camera_bloc/camera_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/db_bloc/db_bloc.dart';
import 'package:pleyona_app/view_models/auth_view_cubit/auth_view_cubit.dart';
import 'package:pleyona_app/view_models/auth_view_cubit/auth_view_cubit_state.dart';
import 'package:pleyona_app/view_models/loader_view_cubit/loader_view_cubit.dart';
import 'navigation/navigation.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // static final MainNavigationRoutes mainNavigation = MainNavigationRoutes;


  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = AuthBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>
          AuthViewCubit(
            initialState: const AuthViewCubitFormFillInProgressState(),
            authBloc: _authBloc
          )
        ),
        BlocProvider(create: (context) =>
          LoaderViewCubit(authBloc: _authBloc)
        ),
        BlocProvider(create: (context) =>
          DBBloc()
        ),
        BlocProvider(create: (context) =>
          CameraBloc()
        ),
        BlocProvider(create: (context) =>
          CurrentTripBloc()
        )
      ],
      child: MaterialApp.router(
        title: 'Pleyona App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          // textTheme: GoogleFonts.robotoMonoTextTheme(Theme.of(context).textTheme)
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: MainNavigationRoutes.router,
        // initialRoute: MainNavigationRouteNames.loaderWidget,
        // onGenerateRoute: mainNavigation.onGenerateRoute
      ),
    );
  }
}



