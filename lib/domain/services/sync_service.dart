import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/domain/entities/attach.dart';
import 'package:social_net/domain/entities/comment.dart';
import 'package:social_net/domain/entities/post.dart';
import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/repository/database_repository.dart';

class SyncService {
  final _api = ApiRepository.instance.api;

  Future<void> syncPersonalPosts({int skip = 0, int take = 20}) async {
    final postModels = await _api.getPersonalPosts(skip, take);

    // convert to database entity type
    final authors = postModels
        .map((e) => User.fromJson(e.author.toJson()).copyWith(avatarId: e.author.avatar?.id))
        .toSet();
    final authosAvatars = postModels
        .map((e) => e.author)
        .where((e) => e.avatar != null)
        .map((e) => Attach.fromJson(e.avatar!.toJson()));
    final popularComments = postModels
        .where((e) => e.popularComment != null)
        .map(
            (e) => Comment.fromJson(e.popularComment!.toJson()).copyWith(postId: e.id, authorId: e.author.id))
        .toList();
    final posts = postModels.map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id));
    final attaches = postModels
        .where((e) => e.attaches != null)
        .expand((e) => e.attaches!.map((x) => Attach.fromJson(x.toJson()).copyWith(postId: e.id)));

    await DatabaseRepository.instance.inserRange(authosAvatars);
    await DatabaseRepository.instance.inserRange(attaches);
    await DatabaseRepository.instance.inserRange(authors);
    await DatabaseRepository.instance.inserRange(popularComments);
    await DatabaseRepository.instance.inserRange(posts);
  }

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
    final users = userProfiles.map((e) => User.fromJson(e.toJson()).copyWith(avatarId: e.avatar?.id));
    final userAvatars =
        userProfiles.where((e) => e.avatar != null).map((e) => Attach.fromJson(e.avatar!.toJson()));

    await DatabaseRepository.instance.inserRange(userAvatars);
    await DatabaseRepository.instance.inserRange(users);
  }

  Future<void> syncTagById(String tagId) async {
    final tag = await _api.getTagById(tagId);
    await DatabaseRepository.instance.insert(Tag.fromJson(tag.toJson()));
  }
}
