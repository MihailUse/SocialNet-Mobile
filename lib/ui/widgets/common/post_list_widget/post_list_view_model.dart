import 'package:flutter/material.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/services/post_service.dart';

enum PostListType {
  personal,
  postByuser,
  postByTag,
}

class PostListViewModel extends ChangeNotifier {
  PostListViewModel.personal(this.context) {
    postListType = PostListType.personal;

    asyncInit();
  }

  PostListViewModel.postByuser(
    this.context,
    this.userId,
  ) : assert(userId != null, "Argument userId for PostListViewModel.postByTag() is null") {
    postListType = PostListType.postByuser;

    asyncInit();
  }

  PostListViewModel.postByTag(
    this.context,
    this.tagId,
  ) : assert(tagId != null, "Argument tagId for PostListViewModel.postByTag() is null") {
    postListType = PostListType.postByTag;

    asyncInit();
  }

  String? tagId;
  String? userId;
  bool isLoading = false;
  List<PostModel>? posts;
  final BuildContext context;
  late final PostListType postListType;
  final _postService = PostService();
  final scrollController = ScrollController();

  Future<void> asyncInit() async {
    switch (postListType) {
      case PostListType.personal:
        posts = await _postService.getPosts(isPersonal: true);
        break;
      case PostListType.postByuser:
        posts = await _postService.getPosts(userId: userId);
        break;
      case PostListType.postByTag:
        posts = await _postService.getPosts(tagId: tagId);
        break;
    }

    scrollController.addListener(loadNewPosts);
    notifyListeners();
  }

  Future<void> loadNewPosts() async {
    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.offset;
    final percent = (current / max * 100);

    if (!isLoading && posts != null && percent > 80) {
      final fromTime = posts!.isNotEmpty ? posts!.last.createdAt : null;
      isLoading = true;
      notifyListeners();

      switch (postListType) {
        case PostListType.personal:
          posts!.addAll(await _postService.getPosts(isPersonal: true, fromTime: fromTime));
          break;
        case PostListType.postByuser:
          posts!.addAll(await _postService.getPosts(userId: userId, fromTime: fromTime));
          break;
        case PostListType.postByTag:
          posts!.addAll(await _postService.getPosts(tagId: tagId, fromTime: fromTime));
          break;
      }

      isLoading = false;
      notifyListeners();
    }
  }

  onLikeButtonPressed(String postId) async {
    try {
      final likeStatus = await _postService.changePostLikeStatus(postId);
      final postIndex = posts!.indexWhere((element) => element.id == postId);
      posts![postIndex] = posts![postIndex].copyWith(
        isLiked: likeStatus,
        likeCount: likeStatus ? posts![postIndex].likeCount + 1 : posts![postIndex].likeCount - 1,
      );
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to update like status"),
        ),
      );
    }
  }
}
