import 'package:social_net/domain/entities/attach.dart';
import 'package:social_net/domain/entities/comment.dart';
import 'package:social_net/domain/entities/post.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/repository/database_repository.dart';

class SyncService {
  final _api = ApiRepository.instance.api;

  Future<void> syncPosts({int skip = 0, int take = 20}) async {
    final postModels = await _api.getPosts(skip, take); // TODO: getPersonalPosts

    // convert to database entity type
    final authors =
        postModels.map((e) => User.fromJson(e.author.toJson()).copyWith(avatarId: e.author.avatar?.id)).toSet();
    final authosAvatars =
        postModels.map((e) => e.author).where((e) => e.avatar != null).map((e) => Attach.fromJson(e.avatar!.toJson()));
    final popularComments = postModels
        .where((e) => e.popularComment != null)
        .map((e) => Comment.fromJson(e.popularComment!.toJson()).copyWith(postId: e.id, authorId: e.author.id))
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
}
