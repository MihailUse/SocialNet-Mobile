import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class UserService {
  Future<UserProfileModel> getCurrentUserProfile() {
    return ApiRepository.instance.api.getCurrentUserProfile();
  }

  Future<void> setUserAvatar(AttachModel attach) {
    return ApiRepository.instance.api.setUserAvatar(attach);
  }
}
