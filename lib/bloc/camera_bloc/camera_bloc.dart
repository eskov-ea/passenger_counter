import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc(): super(const NotInitializedCameraState(cameras: null, controller: null)) {
    on<CameraEvent>((event, emit) async {
      print("CameraEvent:::::  $event");
      if (event is InitializeCameraEvent) {
        await onInitializeCamera(event, emit);
      } else if (event is DisposeCameraEvent) {
        await onDisposeCameraEvent(event, emit);
      }
    });
  }

  Future<void> onInitializeCamera(InitializeCameraEvent event, Emitter emit) async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      final CameraController controller =
          CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
      emit(InitializedCameraState(cameras: cameras, controller: controller));
    } catch(e, stack) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            log("Error", stackTrace: stack, level: 8);
            break;
          default:
            log("Error", stackTrace: stack, level: 8);
            break;
        }
      }
      emit(ErrorCameraState(cameras: null, controller: null, message: e.toString()));
    }
  }

  Future<void> onDisposeCameraEvent(DisposeCameraEvent event, Emitter emit) async {
    await state.controller?.dispose();
    emit(const NotInitializedCameraState(cameras: null, controller: null));
  }
}