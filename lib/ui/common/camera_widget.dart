import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:social_net/ui/app_navigator.dart';

class CameraWidgetArguments {
  final List<CameraDescription> cameras;
  final void Function(File) onTakePicture;
  CameraWidgetArguments({required this.cameras, required this.onTakePicture});
}

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key, required this.cameras, required this.onTakePicture}) : super(key: key);

  final List<CameraDescription> cameras;
  final void Function(File) onTakePicture;

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  int _currentCameraIndex = 0;

  @override
  initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[_currentCameraIndex],
      ResolutionPreset.max,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    await _controller.initialize();
  }

  void onTakePictureButtonPressed() async {
    final file = await _controller.takePicture();
    widget.onTakePicture(File(file.path));
    AppNavigator.toLast();
  }

  void onSwapCameraButtonPressed() {
    _currentCameraIndex++;

    if (widget.cameras.length == _currentCameraIndex) {
      _currentCameraIndex = 0;
    }

    initializeCamera();
    setState(() {
      _controller.dispose();
      _controller = CameraController(
        widget.cameras[_currentCameraIndex],
        ResolutionPreset.max,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: initializeCamera(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreviewWidget(
                controller: _controller,
                onSwapCameraButtonPressed: onSwapCameraButtonPressed,
                onTakePictureButtonPressed: onTakePictureButtonPressed,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    Key? key,
    required this.controller,
    required this.onSwapCameraButtonPressed,
    required this.onTakePictureButtonPressed,
  }) : super(key: key);

  final CameraController controller;
  final void Function() onSwapCameraButtonPressed;
  final void Function() onTakePictureButtonPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minSize = min(constraints.maxWidth, constraints.maxHeight);
        final maxSize = max(constraints.maxWidth, constraints.maxHeight);
        var scale = (minSize / maxSize) * controller.value.aspectRatio;
        if (scale < 1) scale = 1 / scale;

        return Stack(
          children: [
            Transform.scale(
              scale: scale,
              child: Center(
                child: CameraPreview(
                  controller,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.camera),
                      color: Colors.white,
                      iconSize: 54,
                      onPressed: onTakePictureButtonPressed,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.swap_vert),
                      color: Colors.white,
                      iconSize: 54,
                      onPressed: onSwapCameraButtonPressed,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
