import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/camera_bloc/camera_state.dart';
import '../../bloc/camera_bloc/camera_bloc.dart';
import '../screens/camera_screen.dart';

class CameraViewWidget extends StatefulWidget {
  const CameraViewWidget({
    this.width = 200,
    required this.setPhotoResult,
    required this.personBase64Image,
    super.key
  });

  final double width;
  final Function(String) setPhotoResult;
  final String? personBase64Image;

  @override
  State<CameraViewWidget> createState() => _CameraViewWidgetState();
}

class _CameraViewWidgetState extends State<CameraViewWidget> {
  final double aspectRatio = 1.3;

  void _openCamera(BuildContext context ,List<CameraDescription> cameras, CameraController controller) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen(cameras: cameras, controller: controller, setPhotoResult: widget.setPhotoResult)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.width * aspectRatio,
      child: _cameraView()
    );
  }

  Widget _cameraView() {
    return BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
      if (state is InitializedCameraState) {
        if (widget.personBase64Image == null) {
          return GestureDetector(
            onTap: () {
              _openCamera(context, state.cameras!, state.controller!);
            },
            child: AspectRatio(
              aspectRatio: state.controller?.value.aspectRatio ?? aspectRatio,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.black),
                      ),
                      child: CameraPreview(state.controller!),
                    ),
                  ),
                  Container(
                    color: const Color(0x33626262),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/camera_icon_white.png", width: 60, height: 60,),
                          const SizedBox(height: 5,),
                          const Text("Сделать фото",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
          );
        } else {
          return AspectRatio(
            aspectRatio: state.controller?.value.aspectRatio ?? aspectRatio,
            child: GestureDetector(
              onTap: () {
                _openCamera(context, state.cameras!, state.controller!);
              },
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.black),
                      ),
                      child: Image.memory(base64Decode(widget.personBase64Image!)),
                    ),
                  ),
                  Container(
                    color: const Color(0x33626262),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 20),
                    child: const Text("Изменить фото",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  )
                ],
              ),
            )
          );
        }
      } else {
        return AspectRatio(
            aspectRatio: aspectRatio,
            child: const Center(
              child: CircularProgressIndicator(),
            )
        );
      }
    });
  }
}
