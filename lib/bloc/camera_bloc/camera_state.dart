import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

class CameraState extends Equatable {
  const CameraState({
    required this.cameras,
    required this.controller
  });

  final List<CameraDescription>? cameras;
  final CameraController? controller;

  @override
  List<Object?> get props => [cameras, controller];
}

class NotInitializedCameraState extends CameraState {
  const NotInitializedCameraState({
    required super.cameras,
    required super.controller
  });
}

class InitializedCameraState extends CameraState {
  const InitializedCameraState({
    required super.cameras,
    required super.controller
  });

  @override
  List<Object?> get props => [cameras, controller];
}

class ErrorCameraState extends CameraState {
  const ErrorCameraState({
    required super.cameras,
    required super.controller,
    required this.message
  });

  final String message;

  @override
  List<Object?> get props => [cameras, controller, message];
}