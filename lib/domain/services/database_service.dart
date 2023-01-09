import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/user_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/entities/attach.dart';
import 'package:social_net/domain/entities/comment.dart';
import 'package:social_net/domain/entities/db_model.dart';
import 'package:social_net/domain/entities/post.dart';
import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/repository/database_repository.dart';

class DatabaseService {
  Future<void> updateRange<T extends DbModel<dynamic>>(Iterable<T> values) async {
    await DatabaseRepository.instance.inserRange(values);
  }

  Future<List<PostModel>> getPosts() async {
    final resusltPosts = <PostModel>[];
    final posts = (await DatabaseRepository.instance.getAll<Post>()).map((e) => Post.fromMap(e)).toList();

    for (var post in posts) {
      final author = await DatabaseRepository.instance.get<User>(post.authorId).then((value) => User.fromMap(value!));
      final avatar = await DatabaseRepository.instance.get<Attach>(author.avatarId);
      final attaches = await DatabaseRepository.instance.getAll<Attach>(whereMap: {"postId": post.id});
      final popularComment = await DatabaseRepository.instance.get<Comment>(post.popularCommentId);

      resusltPosts.add(PostModel(
        id: post.id,
        text: post.text,
        isCommentable: post.isCommentable == 1,
        likeCount: post.likeCount as int,
        commentCount: post.commentCount as int,
        isLiked: post.isLiked == 1,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        popularComment: popularComment == null ? null : CommentModel.fromJson(popularComment),
        author: UserModel.fromJson(author.toJson()).copyWith(avatar: avatar == null ? null : AttachModel.fromJson(avatar)),
        attaches: attaches.map((e) => AttachModel.fromJson(e)).toList(),
      ));
    }

    return resusltPosts;
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

  Future<List<Tag>> searchTags(String search, [int? skip, int? take]) async {
    Map<String, dynamic> whereMap = {
      "name LIKE": "%$search%",
    };

    final tagMaps = await DatabaseRepository.instance.getAll<Tag>(
      whereMap: whereMap,
      skip: skip,
      take: take,
    );
    return tagMaps.map((e) => Tag.fromMap(e)).toList();
  }

  Future<Tag?> getTagById(String tagId) async {
    final tagMap = await DatabaseRepository.instance.get<Tag>(tagId);
    if (tagMap == null) return null;
    return Tag.fromMap(tagMap);
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
}
