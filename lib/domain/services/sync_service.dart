import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/domain/entities/attach.dart';
import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/repository/database_repository.dart';

class SyncService {
  final _api = ApiRepository.instance.api;

  Future<void> syncUserById(String userId) async {
    final userProfile = await _api.getUserProfile(userId);

    final user = User.fromJson(userProfile.toJson()).copyWith(avatarId: userProfile.avatar?.id);
    if (userProfile.avatar != null) {
      final attach = Attach.fromJson(userProfile.avatar!.toJson());
      await DatabaseRepository.instance.insert(attach);
    }

    await DatabaseRepository.instance.insert(user);
  }

  Future<void> syncCurrentUser() async {
    final userProfile = await _api.getCurrentUserProfile();
    LocalStorage.instance.setValue(LocalStorageKeys.currentUserId, userProfile.id);

    final user = User.fromJson(userProfile.toJson()).copyWith(avatarId: userProfile.avatar?.id);
    if (userProfile.avatar != null) {
      final attach = Attach.fromJson(userProfile.avatar!.toJson());
      await DatabaseRepository.instance.insert(attach);
    }

    await DatabaseRepository.instance.insert(user);
  }

  Future<void> syncSearchTags({String search = "", int skip = 0, int take = 20}) async {
    final tags = (await _api.searchTags(search, skip, take)).map((e) => Tag.fromJson(e.toJson()));
    await DatabaseRepository.instance.inserRange(tags);
  }

  Future<void> syncSearchUsers({String search = "", int skip = 0, int take = 20}) async {
    final userProfiles = await _api.searchUsers(search, skip, take);
    final users = userProfiles.map((e) => User.fromJson(e.toJson()).copyWith(
          avatarId: e.avatar?.id,
          avatarLink: e.avatarLink,
        ));
    final userAvatars = userProfiles.where((e) => e.avatar != null).map((e) => Attach.fromJson(e.avatar!.toJson()));

    await DatabaseRepository.instance.inserRange(userAvatars);
    await DatabaseRepository.instance.inserRange(users);
  }

  Future<void> syncTagById(String tagId) async {
    final tag = await _api.getTagById(tagId);
    await DatabaseRepository.instance.insert(Tag.fromJson(tag.toJson()));
  }
}
