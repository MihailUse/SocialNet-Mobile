import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/attach_service.dart';
import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/widgets/roots/camera_widget/camera_widget.dart';

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel(this.context) {
    asyncInit();
  }

  final BuildContext context;
  UserProfileModel? _user;
  final _userService = UserService();
  final _attachService = AttachService();
  final formGlobalKey = GlobalKey<FormState>();
  late final TextEditingController nicknameController;
  late final TextEditingController fullNameController;
  late final TextEditingController aboutController;

  UserProfileModel? get user => _user;
  set user(UserProfileModel? value) {
    _user = value;
    notifyListeners();
  }

  void asyncInit() async {
    user = await _userService.getCurrentUserProfile();

    nicknameController = TextEditingController(text: user!.nickname);
    fullNameController = TextEditingController(text: user!.fullName);
    aboutController = TextEditingController(text: user!.about);

    nicknameController.addListener(() => user = user!.copyWith(nickname: nicknameController.text));
    fullNameController.addListener(() => user = user!.copyWith(fullName: fullNameController.text));
    aboutController.addListener(() => user = user!.copyWith(about: aboutController.text));
  }

  void onImageSelected(File file) async {
    try {
      final attach = await _attachService.uploadFile(file);
      await _userService.setUserAvatar(attach);
      user = await _userService.getCurrentUserProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to upload immage"),
        ),
      );
    }

    await CachedNetworkImage.evictFromCache(ApiRepository.getUserAvatarPath(user!.avatarLink!));
    await DefaultCacheManager().removeFile(ApiRepository.getUserAvatarPath(user!.avatarLink!));
    notifyListeners();

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
