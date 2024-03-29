import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pleyona_app/view_models/loader_view_cubit/loader_view_cubit.dart';
import '../../navigation/navigation.dart';


class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  void onLoaderViewCubitStateChange(
      BuildContext context,
      LoaderViewCubitState state) {
    final nextScreen = state == LoaderViewCubitState.authorized
        ? NavigationRoutes.homeScreen
        : NavigationRoutes.authScreen;
    context.goNamed(nextScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (prev, currnt) => currnt != LoaderViewCubitState.unknown,
      listener: onLoaderViewCubitStateChange,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
