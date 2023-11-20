import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:pleyona_app/bloc/camera_bloc/camera_bloc.dart';
import 'package:pleyona_app/bloc/db_bloc/db_bloc.dart';
import 'package:pleyona_app/view_models/auth_view_cubit/auth_view_cubit.dart';
import 'package:pleyona_app/view_models/auth_view_cubit/auth_view_cubit_state.dart';
import 'package:pleyona_app/view_models/loader_view_cubit/loader_view_cubit.dart';

import 'navigation/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final MainNavigation mainNavigation = MainNavigation();


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
        )
      ],
      child: MaterialApp(
        title: 'Pleyona App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routes: mainNavigation.routes,
        initialRoute: MainNavigationRouteNames.loaderWidget,
        onGenerateRoute: mainNavigation.onGenerateRoute
      ),
    );
  }
}



