import 'package:equatable/equatable.dart';

import '../../models/person_model.dart';


class DBEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeDBEvent extends DBEvent {}


class SavePersonEvent extends DBEvent{
  final Person person;

  SavePersonEvent({required this.person});
}

class UpdatePersonEvent extends DBEvent{
  final Person currentPerson;
  final Person newPerson;

  UpdatePersonEvent({required this.currentPerson, required this.newPerson});
}