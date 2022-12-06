import 'package:social_net/domain/models/user_profile_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class UserService {
  Future<UserProfileModel> getCurrentUserProfile() {
    return ApiRepository.api.getCurrentUserProfile();
  }
}
