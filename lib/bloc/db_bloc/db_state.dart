import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';

class DBState extends Equatable {

  final Database? db;
  const DBState({required this.db});

  @override
  List<Object?> get props => [db];
}

class NotInitializedDBState extends DBState {

  const NotInitializedDBState({required super.db});
}

class InitializedDBState extends DBState {

  const InitializedDBState({required super.db});
}