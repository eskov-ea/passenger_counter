import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc(): super(const NotInitializedCameraState(cameras: null, controller: null)) {
    on<CameraEvent>((event, emit) async {
      if (event is InitializeCameraEvent) {
        await onInitializeCamera(event, emit);
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
    } catch(e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
      emit(ErrorCameraState(cameras: null, controller: null, message: e.toString()));
    }
  }
}