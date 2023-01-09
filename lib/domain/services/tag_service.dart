import 'package:social_net/data/models/tag_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class TagService {
  Future<bool> changeTagFollowStatus(String tagId) {
    return ApiRepository.instance.api.changeTagFollowStatus(tagId);
  }

  Future<TagModel> getTagById(String tagId) {
    return ApiRepository.instance.api.getTagById(tagId);
  }
}
