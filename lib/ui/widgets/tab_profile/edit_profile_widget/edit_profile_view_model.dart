import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/models/update_user_model.dart';
import 'package:social_net/domain/exceptions/bad_request_exception.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/attach_service.dart';
import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/roots/camera_widget/camera_widget.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel(this.context) {
    asyncInit();
  }

  File? avatarFile;
  UpdateUserModel _updateUserModel = UpdateUserModel();
  final BuildContext context;
  late final String? avatarLink;
  final _userService = UserService();
  final _attachService = AttachService();
  final formGlobalKey = GlobalKey<FormState>();
  late final TextEditingController nicknameController;
  late final TextEditingController fullNameController;
  late final TextEditingController aboutController;

  UpdateUserModel get updateUserModel => _updateUserModel;
  set updateUserModel(UpdateUserModel updateUserModel) {
    _updateUserModel = updateUserModel;
    notifyListeners();
  }

  void asyncInit() async {
    final user = await _userService.getCurrentUserProfile();
    avatarLink = user.avatarLink;

    updateUserModel = UpdateUserModel(
      nickname: user.nickname,
      fullName: user.fullName,
      about: user.about,
    );

    nicknameController = TextEditingController(text: user.nickname);
    fullNameController = TextEditingController(text: user.fullName);
    aboutController = TextEditingController(text: user.about);

    nicknameController.addListener(() => updateUserModel = updateUserModel.copyWith(nickname: nicknameController.text));
    fullNameController.addListener(() => updateUserModel = updateUserModel.copyWith(fullName: fullNameController.text));
    aboutController.addListener(() => updateUserModel = updateUserModel.copyWith(about: aboutController.text));

    notifyListeners();
  }

  void onImageSelected(File file) async {
    try {
      avatarFile = file;
      final attach = await _attachService.uploadFile(file);
      updateUserModel = updateUserModel.copyWith(avatar: attach);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to upload image"),
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

  void onSaveButtonPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formGlobalKey.currentState!.validate()) return;

    try {
      await _userService.updateUser(updateUserModel);
      final user = await _userService.getCurrentUserProfile();

      if (user.avatarLink != null) {
        await CachedNetworkImage.evictFromCache(ApiRepository.getUserAvatarPath(user.avatarLink!));
        await DefaultCacheManager().removeFile(ApiRepository.getUserAvatarPath(user.avatarLink!));
      }

      final mainViewModel = context.read<MainViewModel>();
      mainViewModel.user = user;

      Navigator.of(MainViewModel.getTabContext(MainNavigatorRoutes.profile)!).pushNamedAndRemoveUntil(
        NestedNavigatorRoutes.profile,
        (route) => false,
        arguments: user.id,
      );
    } catch (e) {
      if (e is BadRequestException && e.errorResponse?.errors != null) {
        final errors = e.errorResponse!.errors!;
        String errorMessage = "";

        // display errors from server
        for (var element in errors.entries) {
          for (var errorString in element.value) {
            errorMessage += "$errorString\n";
          }
        }

        showError(errorMessage);
      } else {
        showError("failed to save changes");
      }
    }
  }

  String? validateNickname(String? value) {
    if (value == null || value.isEmpty) return "nickname required";
    if (value.length < 2) return "nickname is short";
    if (value.length > 64) return "nickname is too long";
    return null;
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
