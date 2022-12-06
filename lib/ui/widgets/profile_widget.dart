import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/models/user_profile_model.dart';

import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/common/user_avatar_widget.dart';

class _UserState {
  final String nickname;
  final String? fullName;
  final String? about;
  final String? avatarPath;
  final String postCount;
  final String followerCount;
  final String followingCount;

  _UserState({
    required this.nickname,
    this.fullName,
    this.about,
    this.avatarPath,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
  });
}

class _ViewModel extends ChangeNotifier {
  final _userService = UserService();
  _UserState user = _UserState(
    nickname: "...",
    about: "...",
    postCount: "...",
    followerCount: "...",
    followingCount: "...",
  );

  _ViewModel() {
    asyncInit();
  }

  void asyncInit() async {
    UserProfileModel userProfile = await _userService.getCurrentUserProfile();

    user = _UserState(
      nickname: userProfile.nickname,
      fullName: userProfile.fullName,
      about: userProfile.about,
      avatarPath: userProfile.avatar?.link,
      postCount: _parseCount(userProfile.postCount),
      followerCount: _parseCount(userProfile.followerCount),
      followingCount: _parseCount(userProfile.followingCount),
    );
    notifyListeners();
  }

  String _parseCount(int count) {
    if (count > 1000) {
      final resCount = (count.toDouble() / 1000).toStringAsFixed(1);
      return "$resCount k";
    }

    return count.toString();
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((_ViewModel value) => value.user);

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: UserAvatarWidget(path: user.avatarPath),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      user.nickname,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ProfileCountWidget(
                          value: user.postCount,
                          description: "publications",
                        ),
                        _ProfileCountWidget(
                          value: user.followerCount,
                          description: "followers",
                        ),
                        _ProfileCountWidget(
                          value: user.followingCount,
                          description: "followings",
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (user.about != null) const _AboutTextWidget()
        ],
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        lazy: false,
        create: (_) => _ViewModel(),
        child: const ProfileWidget(),
      );
}

class _AboutTextWidget extends StatelessWidget {
  const _AboutTextWidget();

  @override
  Widget build(BuildContext context) {
    final about = context.select((_ViewModel value) => value.user.about);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(about!),
    );
  }
}

class _ProfileCountWidget extends StatelessWidget {
  const _ProfileCountWidget({required this.value, required this.description});

  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
