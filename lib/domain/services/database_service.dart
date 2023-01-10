import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/notification_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/tag_model.dart';
import 'package:social_net/data/models/user_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/entities/attach.dart';
import 'package:social_net/domain/entities/comment.dart';
import 'package:social_net/domain/entities/db_model.dart';
import 'package:social_net/domain/entities/notification.dart';
import 'package:social_net/domain/entities/post.dart';
import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/repository/database_repository.dart';

class DatabaseService {
  Future<void> updateRange<T extends DbModel<dynamic>>(Iterable<T> values) async {
    await DatabaseRepository.instance.inserRange(values);
  }

  Future<UserProfileModel?> getUserById(String userId) async {
    final userMap = await DatabaseRepository.instance.get<User>(userId);
    if (userMap == null) return null;

    final user = User.fromMap(userMap);
    final attachMap = await DatabaseRepository.instance.get<Attach>(user.avatarId);

    return UserProfileModel(
      id: user.id,
      nickname: user.nickname,
      fullName: user.fullName,
      about: user.about,
      avatar: attachMap == null ? null : AttachModel.fromJson(attachMap),
      isFollowing: user.isFollowing == 1,
      followerCount: user.followerCount,
      followingCount: user.followingCount,
      postCount: user.postCount,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      deletedAt: user.deletedAt,
    );
  }

  Future<List<User>> searchUsers(String search, [int? skip, int? take]) async {
    Map<String, dynamic> whereMap = {
      "nickname LIKE": "%$search%",
    };

    final userMaps = await DatabaseRepository.instance.getAll<User>(
      whereMap: whereMap,
      skip: skip,
      take: take,
    );

    return userMaps.map((e) => User.fromMap(e)).toList();
  }

  Future<List<TagModel>> searchTags(String search, [int? skip, int? take]) async {
    Map<String, dynamic> whereMap = {
      "name LIKE": "%$search%",
    };

    final tagMaps = await DatabaseRepository.instance.getAll<Tag>(
      whereMap: whereMap,
      skip: skip,
      take: take,
    );
    return tagMaps.map((e) => Tag.fromMap(e)).map((e) => TagModel.fromEntity(e)).toList();
  }

  Future<TagModel?> getTagById(String tagId) async {
    final tagMap = await DatabaseRepository.instance.get<Tag>(tagId);
    if (tagMap == null) return null;
    return TagModel.fromEntity(Tag.fromMap(tagMap));
  }

  Future<List<CommentModel>> getPostComments(String postId, [int? skip, int? take]) async {
    List<CommentModel> comments = [];

    final commentMaps = await DatabaseRepository.instance.getAll<Comment>(
      whereMap: {"postId": postId},
      skip: skip,
      take: take,
    );

    for (var commentMap in commentMaps) {
      final comment = Comment.fromMap(commentMap);
      final author = await DatabaseRepository.instance.get<User>(comment.authorId).then((value) => User.fromMap(value!));
      final avatar = await DatabaseRepository.instance.get<Attach>(author.avatarId).then((value) => Attach.fromMap(value!));
      final userModel = UserModel.fromEntity(author, AttachModel.fromEntity(avatar));

      comments.add(CommentModel.fromEntity(comment, userModel));
    }

    return comments;
  }

  Future<void> updatePostComments(List<CommentModel> comments, String postId) async {
    List<User> entityUsers = [];
    List<Attach> entityAvatars = [];
    List<Comment> entityComments = [];

    for (final comment in comments) {
      final author = User.fromModel(comment.author);
      if (comment.author.avatar != null) entityAvatars.add(Attach.fromModel(comment.author.avatar!));

      entityUsers.add(author);
      entityComments.add(Comment.fromModel(comment, postId, author.id));
    }

    await DatabaseRepository.instance.inserRange(entityAvatars);
    await DatabaseRepository.instance.inserRange(entityUsers);
    await DatabaseRepository.instance.inserRange(entityComments);
  }

  void updatePosts(List<PostModel> postModels, bool isPersonal) async {
    final authors = postModels.map((e) => User.fromModel(e.author)).toSet();
    final avatars = postModels.where((e) => e.author.avatar != null).map((e) => Attach.fromModel(e.author.avatar!));
    final posts = postModels.map((e) => Post.fromModel(e, e.author.id, isPersonal, e.popularComment?.id));
    final attaches = postModels.where((e) => e.attaches != null).expand((e) => e.attaches!.map((x) => Attach.fromModel(x, e.id)));
    final popularComments = postModels
        .where((e) => e.popularComment != null)
        .map((e) => Comment.fromModel(e.popularComment!, e.id, e.author.id))
        .toList();

    await DatabaseRepository.instance.inserRange(avatars);
    await DatabaseRepository.instance.inserRange(authors);
    await DatabaseRepository.instance.inserRange(posts);
    await DatabaseRepository.instance.inserRange(attaches);
    await DatabaseRepository.instance.inserRange(popularComments);
  }

  Future<List<PostModel>> getPosts({
    int? skip,
    int? take,
    DateTime? fromTime,
    bool isPersonal = false,
    String? userId,
  }) async {
    final posts = await DatabaseRepository.instance.getPosts(
      skip: skip,
      take: take,
      fromTime: fromTime,
      isPersonal: isPersonal,
      userId: userId,
    );
    final resusltPosts = <PostModel>[];

    for (final post in posts) {
      final author = await DatabaseRepository.instance.get<User>(post.authorId).then((value) => User.fromMap(value!));
      final avatar = await DatabaseRepository.instance.get<Attach>(author.avatarId).then((value) => Attach.fromMap(value!));
      final attaches = await DatabaseRepository.instance
          .getAll<Attach>(whereMap: {"postId": post.id}).then((value) => value.map((e) => AttachModel.fromJson(e)).toList());

      CommentModel? popularComment;
      if (post.popularCommentId != null) {
        final authorPopularComment =
            await DatabaseRepository.instance.get<User>(post.authorId).then((value) => User.fromMap(value!));
        final authorAvatarPopularComment = await DatabaseRepository.instance
            .get<Attach>(authorPopularComment.avatarId)
            .then((value) => Attach.fromMap(value!))
            .then((value) => AttachModel.fromEntity(value));

        popularComment = await DatabaseRepository.instance
            .get<Comment>(post.popularCommentId)
            .then((value) => Comment.fromMap(value!))
            .then((value) =>
                CommentModel.fromEntity(value, UserModel.fromEntity(authorPopularComment, authorAvatarPopularComment)));
      }

      resusltPosts.add(PostModel.fromEntity(
        post,
        UserModel.fromEntity(author, AttachModel.fromEntity(avatar)),
        attaches,
        popularComment,
      ));
    }

    return resusltPosts;
  }

  Future<void> updateNotifications(List<NotificationModel> notifications) async {
    await DatabaseRepository.instance.inserRange(notifications.map((e) => Notification.fromModel(e)));
  }

  Future<List<NotificationModel>> getNotifications(int? skip, int? take, DateTime? fromTime) async {
    final notifications = await DatabaseRepository.instance.getNotifications(skip, take, fromTime);
    return notifications.map((e) => NotificationModel.fromEntity(e)).toList();
  }

  Future<void> delete<T extends DbModel<dynamic>>(dynamic id) async {
    await DatabaseRepository.instance.delete<T>(id);
  }
}
