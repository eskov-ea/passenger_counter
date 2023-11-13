import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../services/database/db_provider.dart';
import 'db_event.dart';
import 'db_state.dart';



class DBBloc extends Bloc<DBEvent, DBState> {

  late final Database _dbProvider;

  DBBloc(): super(const NotInitializedDBState()) {
    on<DBEvent>((event, emit) async {
      if (event is InitializeDBEvent) {
        await _onInitializeDBEvent(event, emit);
      }
    });
  }

  _onInitializeDBEvent(InitializeDBEvent event, Emitter<DBState> emit) async {
    _dbProvider = await DBProvider.db.database;
    emit(const InitializedDBState());
  }
}