import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/sync_service.dart';
import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this.context, [String? userId]) {
    asyncInit(userId);
  }

  final BuildContext context;
  bool isCurrentUser = false;
  final _syncService = SyncService();
  final _userService = UserService();
  final _databaseService = DatabaseService();

  UserProfileModel? _user;
  UserProfileModel? get user => _user;
  set user(UserProfileModel? value) {
    _user = value;
    notifyListeners();
  }

  void asyncInit(String? userId) async {
    final currentUserId = await LocalStorage.instance.getValue(LocalStorageKeys.currentUserId);
    isCurrentUser = userId == null || currentUserId == userId;

    if (isCurrentUser) {
      final mainViewModel = context.read<MainViewModel>();
      mainViewModel.addListener(() {
        user = mainViewModel.user;
      });
      return;
    }

    try {
      await _syncService.syncUserById(userId ?? currentUserId!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to upload profile"),
        ),
      );
    }

    user = await _databaseService.getUserById(userId ?? currentUserId!);
  }

  void onProfileMenuPressed() async {
    await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profileMenu);
  }

  String parseCount(int count) {
    if (count > 1000) {
      final resCount = (count.toDouble() / 1000).toStringAsFixed(1);
      return "$resCount k";
    }

    return count.toString();
  }

  void changeFollowStatus() async {
    try {
      final isFollowing = await _userService.changeUserFollowStatus(user!.id);
      user = user!.copyWith(isFollowing: isFollowing);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to change status"),
        ),
      );
    }
  }
}
