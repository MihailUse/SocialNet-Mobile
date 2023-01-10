import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/post_list_widget/post_list_view_model.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this.context, String? userId) {
    asyncInit(userId);

    postListViewModel = PostListViewModel.personal(context);
  }

  final BuildContext context;
  bool isCurrentUser = false;
  final _userService = UserService();
  late PostListViewModel postListViewModel;
  late final mainViewModel = context.read<MainViewModel>();

  UserProfileModel? _user;
  UserProfileModel? get user => _user;
  set user(UserProfileModel? value) {
    _user = value;
    notifyListeners();
  }

  @override
  void dispose() {
    if (isCurrentUser) {
      mainViewModel.removeListener(mainViewModelListener);
    }
    super.dispose();
  }

  void mainViewModelListener() => user = mainViewModel.user;

  void asyncInit(String? userId) async {
    userId ??= await _userService.getCurrentUserId();
    isCurrentUser = await _userService.isCurrenUser(userId);

    if (isCurrentUser) {
      mainViewModel.addListener(mainViewModelListener);
    }

    postListViewModel = PostListViewModel.postByuser(context, userId);
    postListViewModel.addListener(notifyListeners);

    try {
      user = await _userService.getUserById(userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to upload profile"),
        ),
      );
    }
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
