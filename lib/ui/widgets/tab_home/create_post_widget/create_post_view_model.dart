import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/domain/services/attach_service.dart';
import 'package:social_net/domain/services/post_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/widgets/roots/camera_widget/camera_widget.dart';

class CreatePostViewModel extends ChangeNotifier {
  CreatePostViewModel(this.context) {
    postTextController = TextEditingController(text: state.text);

    postTextController.addListener(() => state = state.copyWith(text: postTextController.text));
  }

  int currentAttachIndex = 0;
  final _attachService = AttachService();
  final _postService = PostService();
  final formGlobalKey = GlobalKey<FormState>();
  final List<File> attaches = [];
  late final TextEditingController postTextController;
  final BuildContext context;
  CreatePostModel _state = const CreatePostModel(
    text: "",
    isCommentable: true,
    attaches: [],
  );

  CreatePostModel get state => _state;
  set state(CreatePostModel value) {
    _state = value;
    notifyListeners();
  }

  void onAttachIndexChenged(int value) {
    currentAttachIndex = value;
    notifyListeners();
  }

  void onCreateButtonPressed() async {
    try {
      await _postService.createPost(state);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to create post"),
        ),
      );
    }
  }

  void isCommentableChenged(bool? value) {
    state = state.copyWith(isCommentable: value ?? false);
  }

  void onImageSelected(File file) async {
    try {
      final attach = await _attachService.uploadFile(file);
      attaches.add(file);
      state = state.copyWith(attaches: [...state.attaches!, attach]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to upload immage"),
        ),
      );
    }

    // hide dialog
    Navigator.of(context).pop();
  }

  void onSelectImageButtonPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      onImageSelected(file);
    }
  }

  void onTakeImageButtonPressed() async {
    final cameras = await availableCameras();
    final arguments = CameraWidgetArguments(
      cameras: cameras,
      onTakePicture: onImageSelected,
    );

    await AppNavigator.toCamera(arguments);
  }
}
