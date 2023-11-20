import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as IMG;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({
    required this.controller,
    required this.cameras,
    required this.setPhotoResult,
    super.key
  });

  final CameraController controller;
  final List<CameraDescription> cameras;
  final Function(String) setPhotoResult;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver, TickerProviderStateMixin {


  XFile? imageFile;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;
  int activeCamera = 0;

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    return Icons.camera;
  }

  void _logError(String code, String? message) {
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (widget.controller == null) {
      return;
    }

    final CameraController cameraController = widget.controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = widget.controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // _initializeCameraController(cameraController.description);
    }
  }

  Future<void> onNewCameraSelected() async {
    if (activeCamera == widget.cameras.length - 1) {
      activeCamera = 0;
    } else {
      activeCamera += 1;
    }
    return widget.controller.setDescription(widget.cameras[activeCamera]);

  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );


    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                  (double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value)
        ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
        // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
        // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = widget.controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) async {
      try {
        if (mounted) {
          setState(() {
            imageFile = file;
          });
          if (file != null) {
            file.readAsBytes().then((bytes) {
              final str = resizeImage(bytes);
              widget.setPhotoResult(str!);
              Navigator.of(context).pop();
            });
          }
        }
      } catch(err) {
        print("ERRROR:::: $err");
        setState(() {
          imageFile = null;
        });
        return;
      }
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = widget.controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (widget.controller == null) {
      return;
    }

    try {
      await widget.controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (widget.controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await widget.controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (widget.controller == null) {
      return;
    }

    try {
      await widget.controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (widget.controller == null) {
      return;
    }

    try {
      await widget.controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (widget.controller != null) {
        final CameraController cameraController = widget.controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (widget.controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await widget.controller!.setZoomLevel(_currentScale);
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width * widget.controller.value.aspectRatio,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          _modeControlRowWidget(),
          _captureControlRowWidget(),
          const SizedBox(height: 5,)
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: CameraPreview(
        widget.controller,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                onTapDown: (TapDownDetails details) =>
                    onViewFinderTap(details, constraints),
              );
            }),
      ),
    );
  }

  Widget _thumbnailWidget() {
    return imageFile == null
        ? const SizedBox(
          width: 64,
          height: 64,
        )
        : SizedBox(
          width: 64.0,
          height: 64.0,
          child: kIsWeb
            ? Image.network(imageFile!.path)
            : Image.file(File(imageFile!.path)));
  }

  String? resizeImage(Uint8List data) {
    try {
      IMG.Image img = IMG.decodeImage(data)!;
      IMG.Image resized = IMG.copyResize(img, width: 512);
      final resizedData = IMG.encodeJpg(resized);
      final base64resizedData = base64Encode(resizedData);
      return base64resizedData;
    } catch(err) {
      print("Resize error --> $err");
      return null;
    }
  }

  Widget _modeControlRowWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_on, size: 30),
              color: Colors.blue,
              onPressed: widget.controller != null ? onFlashModeButtonPressed : null,
            ),
            // The exposure and focus mode are currently not supported on the web.
            ...!kIsWeb
                ? <Widget>[
              IconButton(
                icon: const Icon(Icons.exposure, size: 30,),
                color: Colors.blue,
                onPressed: widget.controller != null
                    ? onExposureModeButtonPressed
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.filter_center_focus, size: 30),
                color: Colors.blue,
                onPressed:
                widget.controller != null ? onFocusModeButtonPressed : null,
              )
            ]
                : <Widget>[],
            IconButton(
              icon: const Icon(Icons.switch_camera, size: 30),
              color: Colors.blue,
              onPressed: onNewCameraSelected,
            ),
          ],
        ),
        _flashModeControlRowWidget(),
        _exposureModeControlRowWidget(),
        _focusModeControlRowWidget(),
      ],
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: widget.controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: widget.controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: widget.controller?.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: widget.controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: widget.controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: widget.controller?.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: widget.controller?.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Exposure Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: widget.controller != null
                        ? () =>
                        onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (widget.controller != null) {
                        widget.controller!.setExposurePoint(null);
                        showInSnackBar('Resetting exposure point');
                      }
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: widget.controller != null
                        ? () =>
                        onSetExposureModeButtonPressed(ExposureMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: widget.controller != null
                        ? () => widget.controller!.setExposureOffset(0.0)
                        : null,
                    child: const Text('RESET OFFSET'),
                  ),
                ],
              ),
              const Center(
                child: Text('Exposure Offset'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(_minAvailableExposureOffset.toString()),
                  Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toString(),
                    onChanged: _minAvailableExposureOffset ==
                        _maxAvailableExposureOffset
                        ? null
                        : setExposureOffset,
                  ),
                  Text(_maxAvailableExposureOffset.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: widget.controller?.value.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: widget.controller?.value.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Focus Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: widget.controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                        : null,
                    onLongPress: () {
                      if (widget.controller != null) {
                        widget.controller!.setFocusPoint(null);
                      }
                      showInSnackBar('Resetting focus point');
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: widget.controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _captureControlRowWidget() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.pause_presentation),
          color: Colors.blue,
          onPressed: onPausePreviewButtonPressed,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF000000),
                  border: Border.all(width: 1, color: Color(0xFF000000))
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF000000),
                  border: Border.all(width: 3, color: Color(0xFFFFFFFF))
              ),
            ),
            IconButton(
                icon: const Icon(Icons.camera_alt, size: 35,),
                color: Color(0xFFFFFFFF),
                onPressed: onTakePictureButtonPressed
            ),
          ],
        ),
        _thumbnailWidget()
      ],
    );
  }

  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }

      // onNewCameraSelected(description);
    }

    if (widget.cameras.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        showInSnackBar('No camera found.');
      });
      return const Text('None');
    } else {
      for (final CameraDescription cameraDescription in widget.cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: widget.controller?.description,
              value: cameraDescription,
              onChanged: onChanged,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

}
