import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/database/db_provider.dart';
import 'db_event.dart';
import 'db_state.dart';



class DBBloc extends Bloc<DBEvent, DBState> {

  late final DBProvider _dbProvider;

  DBBloc(): super(const NotInitializedDBState()) {
    on<DBEvent>((event, emit) async {
      if (event is InitializeDBEvent) {
        await _onInitializeDBEvent(event, emit);
      } else if (event is UpdatePersonEvent) {
        await _onUpdatePersonEvent(event, emit);
      } else if (event is SavePersonEvent) {
        await _onSavePersonEvent(event, emit);
      }
    });
  }

  _onInitializeDBEvent(InitializeDBEvent event, Emitter<DBState> emit) async {
    print("[ DATABASE INITIALIZE]::: ");
    if( state is NotInitializedDBState) {
      _dbProvider = DBProvider.db;
      await _dbProvider.database;
      emit(const InitializedDBState());
    }
  }

  _onSavePersonEvent(SavePersonEvent event, Emitter<DBState> emit) async {
    try {
      await _dbProvider.addPerson(event.person);
    } catch (err) {
      print("[ DATABASE ERROR]:::   $err");
    }
  }

  _onUpdatePersonEvent( UpdatePersonEvent event, Emitter<DBState> emit) async {
    try {
      // doc = event.currentPerson.documents;
      String phone = event.currentPerson.phone;
      String email = event.currentPerson.email;
      // if (event.newPerson.documents.trim() != event.currentPerson.documents.trim()) {
      //   doc += ", ${event.currentPerson.documents.trim()}";
      // }
      if (event.newPerson.phone.trim() != event.currentPerson.phone.trim()) {
        phone = event.newPerson.phone.trim();
      }
      if (event.newPerson.email.trim() != event.currentPerson.email.trim()) {
        email = event.newPerson.email.trim();
      }
      _dbProvider.updatePerson(id: event.currentPerson.id, phone: phone, email: email);
    } catch(err) {
      print("[ DATABASE ERROR]:::   $err");
    }
  }
}