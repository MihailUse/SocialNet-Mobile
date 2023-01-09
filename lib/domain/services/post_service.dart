import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class PostService {
  Future<String> createPost(CreatePostModel postModel) async {
    return await ApiRepository.instance.api.createPost(postModel);
  }

  Future<bool> changePostLikeStatus(String postId) async {
    return await ApiRepository.instance.api.changePostLikeStatus(postId);
  }
}
