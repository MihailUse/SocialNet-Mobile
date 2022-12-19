import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_net/ui/app_navigator.dart';
import 'package:social_net/ui/common/camera_widget.dart';

class SelectFileAlertDialog extends StatelessWidget {
  const SelectFileAlertDialog({super.key, required this.onImageSelected});

  final void Function(File file) onImageSelected;

  void onSelectImageButtonPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      onImageSelected(file);
    }

    // hide dialog
    AppNavigator.toLast();
  }

  void onTakePhotoButtonPressed() async {
    final cameras = await availableCameras();

    await AppNavigator.navigateTo(
      RouteAction.push,
      AppNavigationRoutes.camera,
      arguments: CameraWidgetArguments(
        onTakePicture: (file) {
          onImageSelected(file);
          AppNavigator.toLast(); // hide dialog
        },
        cameras: cameras,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        'Select image for post',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton(
          onPressed: onSelectImageButtonPressed,
          child: const Text('Select file'),
        ),
        TextButton(
          onPressed: onTakePhotoButtonPressed,
          child: const Text('Take a photo'),
        ),
      ],
    );
  }
}
