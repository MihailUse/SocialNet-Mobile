import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/utils.dart';

class PostService {
  final _database = DatabaseService();

  Future<String> createPost(CreatePostModel postModel) async {
    return await ApiRepository.instance.api.createPost(postModel);
  }

  Future<bool> changePostLikeStatus(String postId) async {
    return await ApiRepository.instance.api.changePostLikeStatus(postId);
  }

  Future<List<PostModel>> getPosts({
    int? skip,
    int? take = 2,
    DateTime? fromTime,
    bool isPersonal = false,
    String? userId,
    String? tagId,
  }) async {
    List<PostModel> posts;

    try {
      if (isPersonal) {
        posts = await ApiRepository.instance.api.getPersonalPosts(skip, take, fromTime);
      } else if (userId != null) {
        posts = await ApiRepository.instance.api.getUserPosts(userId, skip, take, fromTime);
      } else if (tagId != null) {
        posts = await ApiRepository.instance.api.getPostsByTag(tagId, skip, take, fromTime);
      } else {
        throw ArgumentError("Invalid arguments for getPosts");
      }

      _database.updatePosts(posts, true);
    } catch (e) {
      if (tagId != null) return [];

      posts = await _database.getPosts(
        skip: skip,
        take: take,
        fromTime: fromTime,
        isPersonal: isPersonal,
        userId: userId,
      );
    }

    return posts;
  }
}
