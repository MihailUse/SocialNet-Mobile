import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/create_comment_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/database_service.dart';

class CommentService {
  final _database = DatabaseService();

  Future<List<CommentModel>> getPostComments(String postId, [int? skip, int? take = 10]) async {
    List<CommentModel> comments;

    try {
      comments = await ApiRepository.instance.api.getPostComments(postId, skip, take);
      _database.updatePostComments(comments, postId);
    } catch (e) {
      comments = await _database.getPostComments(postId, skip, take);
    }

    return comments;
  }

  createComment(String postId, String text) async {
    await ApiRepository.instance.api.createComment(CreateCommentModel(text: text, postId: postId));
  }
}
