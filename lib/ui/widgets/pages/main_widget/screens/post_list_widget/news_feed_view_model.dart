import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/sync_service.dart';
import 'package:social_net/ui/app_navigator.dart';

class NewsFeedViewModel extends ChangeNotifier {
  final BuildContext context;
  final _databaseService = DatabaseService();
  final _syncService = SyncService();
  final Map<int, int> attachPager = <int, int>{};
  List<PostModel>? _posts;

  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? value) {
    _posts = value;
    notifyListeners();
  }

  NewsFeedViewModel(this.context) {
    asyncInit();
  }

  void asyncInit() async {
    try {
      await _syncService.syncPosts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to get list of posts"),
        ),
      );
    }

    posts = await _databaseService.getPosts();
  }

  void onAddPostButtonPressed() async {
    await AppNavigator.navigateTo(RouteAction.push, AppNavigationRoutes.postCreate);
  }

  void onNotificationsButtonPressed() {}
}
