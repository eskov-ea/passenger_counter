import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

class DBState extends Equatable {

  const DBState();

  @override
  List<Object?> get props => [];
}

class NotInitializedDBState extends DBState {

  const NotInitializedDBState();
}

class InitializedDBState extends DBState {

  const InitializedDBState();
}