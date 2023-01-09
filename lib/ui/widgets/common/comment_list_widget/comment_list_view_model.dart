import 'package:flutter/material.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/domain/services/comment_service.dart';

class CommentListViewModel extends ChangeNotifier {
  CommentListViewModel(this.context, this.postId) {
    asyncInit();
  }

  List<CommentModel>? comments;
  String createCommentText = "";
  bool _showCreateComment = false;
  final String postId;
  final BuildContext context;
  final scrollController = ScrollController();
  final _commentService = CommentService();

  bool get showCreateComment => _showCreateComment;
  set showCreateComment(bool showCreateComment) {
    _showCreateComment = showCreateComment;
    notifyListeners();
  }

  Future<void> asyncInit() async {
    comments = await _commentService.getPostComments(postId);
    notifyListeners();
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void onCreateButtonPresed() async {
    if (createCommentText.length < 2) {
      showError("comment is too short");
      return;
    }

    try {
      await _commentService.createComment(postId, createCommentText);
    } catch (e) {
      showError("failed to create comment");
    }
    
    comments = await _commentService.getPostComments(postId, 0, comments!.length + 10);
    showCreateComment = false;
  }
}
