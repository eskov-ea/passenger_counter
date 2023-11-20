import 'package:equatable/equatable.dart';

class CameraEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeCameraEvent extends CameraEvent {}
class DisposeCameraEvent extends CameraEvent {}