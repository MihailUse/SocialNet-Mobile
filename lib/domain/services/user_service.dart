import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/data/models/update_user_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/database_service.dart';

class UserService {
  final _database = DatabaseService();

  Future<UserProfileModel> getCurrentUserProfile() async {
    try {
      return ApiRepository.instance.api.getCurrentUserProfile();
    } catch (e) {
      final currentUserId = await getCurrentUserId();

      try {
        return await ApiRepository.instance.api.getUserProfile(currentUserId);
      } catch (e) {
        final user = await _database.getUserById(currentUserId);
        if (user == null) throw Exception("failed to load user profile");
        return user;
      }
    }
  }

  Future<bool> changeUserFollowStatus(String followingId) {
    return ApiRepository.instance.api.changeUserFollowStatus(followingId);
  }

  Future<bool> isCurrenUser(String userId) async {
    final currentUserId = await LocalStorage.instance.getValue(LocalStorageKeys.currentUserId);
    return userId == currentUserId;
  }

  Future<String> getCurrentUserId() async {
    return (await LocalStorage.instance.getValue(LocalStorageKeys.currentUserId))!;
  }

  Future<UserProfileModel> getUserById(String userId) async {
    try {
      return await ApiRepository.instance.api.getUserProfile(userId);
    } catch (e) {
      final user = await _database.getUserById(userId);
      if (user == null) throw Exception("failed to load user profile");
      return user;
    }
  }

  Future<void> updateUser(UpdateUserModel updateUserModel) async {
    await ApiRepository.instance.api.updateUser(updateUserModel);
  }
}
