import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/attach_service.dart';
import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/app_navigator.dart';
import 'package:social_net/ui/common/camera_widget.dart';

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel() {
    asyncInit();
  }

  late UserProfileModel _user = UserProfileModel(
    id: "id",
    nickname: "nickname",
    followerCount: 0,
    followingCount: 0,
    postCount: 0,
    createdAt: DateTime.now(),
  );
  final _userService = UserService();
  final _attachService = AttachService();
  final formGlobalKey = GlobalKey<FormState>();
  late final TextEditingController nicknameController;
  late final TextEditingController fullNameController;
  late final TextEditingController aboutController;

  UserProfileModel get user => _user;
  set user(UserProfileModel value) {
    _user = value;
    notifyListeners();
  }

  void asyncInit() async {
    user = await _userService.getCurrentUserProfile();

    nicknameController = TextEditingController(text: user.nickname);
    fullNameController = TextEditingController(text: user.fullName);
    aboutController = TextEditingController(text: user.about);

    nicknameController.addListener(() => user = user.copyWith(nickname: nicknameController.text));
    fullNameController.addListener(() => user = user.copyWith(fullName: fullNameController.text));
    aboutController.addListener(() => user = user.copyWith(about: aboutController.text));
  }

  void onAvatarSelected(File file) async {
    final attach = await _attachService.uploadFile(file);
    await _userService.setUserAvatar(attach);
    user = await _userService.getCurrentUserProfile();
    // TODO:
    await CachedNetworkImage.evictFromCache(ApiRepository.getUserAvatarPath(user.id));
    await DefaultCacheManager().removeFile(ApiRepository.getUserAvatarPath(user.id));
    notifyListeners();
  }

  void onAvatarPressed() async {
    final cameras = await availableCameras();

    await AppNavigator.navigateTo(
      RouteAction.push,
      AppNavigationRoutes.camera,
      arguments: CameraWidgetArguments(onTakePicture: onAvatarSelected, cameras: cameras),
    );
  }
}
