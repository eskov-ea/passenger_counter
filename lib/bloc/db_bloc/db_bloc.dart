import 'package:flutter_bloc/flutter_bloc.dart';
import 'db_event.dart';
import 'db_state.dart';



class DBBloc extends Bloc<DBEvent, DBState> {

  DBBloc(): super(const NotInitializedDBState(db: null)) {
    on<DBEvent>((event, emit) async {

    });
  }

}