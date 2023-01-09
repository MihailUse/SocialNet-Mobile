import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/post_service.dart';
import 'package:social_net/domain/services/sync_service.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.context) {
    asyncInit();

    scrollController.addListener(updateList);
  }

  var _isNewPostLoading = false;
  final BuildContext context;
  final _syncService = SyncService();
  final _postService = PostService();
  final _databaseService = DatabaseService();
  final scrollController = ScrollController();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? value) {
    _posts = value;
    notifyListeners();
  }

  Future<void> asyncInit() async {
    try {
      await _syncService.syncPersonalPosts();
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
    await Navigator.of(context).pushNamed(NestedNavigatorRoutes.postCreate);
  }

  void onNotificationsButtonPressed() {
    final mainViewModel = context.read<MainViewModel>();
    mainViewModel.onSelectTab(MainNavigatorRoutes.notifications);
  }

  void onCommentButtonPressed(String postId) async {}
  void onLikeButtonPressed(String postId) async {
    final isLiked = await _postService.changePostLikeStatus(postId);
    var post = posts!.singleWhere((element) => element.id == postId);
    post = post.copyWith(likeCount: isLiked ? post.likeCount + 1 : post.likeCount - 1);
    notifyListeners();
  }

  Future<void> updateList() async {
    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.offset;
    final percent = (current / max * 100);

    if ((!_isNewPostLoading && percent > 80) || current == max) {
      _isNewPostLoading = true;
      refreshIndicatorKey.currentState?.show();
      posts?.addAll(posts?.sublist(0, 3) ?? []);
    }

    _isNewPostLoading = false;
  }
}
