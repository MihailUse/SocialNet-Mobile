import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/user_model.dart';
import 'package:social_net/domain/entities/attach.dart';
import 'package:social_net/domain/entities/comment.dart';
import 'package:social_net/domain/entities/db_model.dart';
import 'package:social_net/domain/entities/post.dart';
import 'package:social_net/domain/entities/user.dart';
import 'package:social_net/domain/repository/database_repository.dart';

class DatabaseService {
  Future<void> updateRange<T extends DbModel<dynamic>>(Iterable<T> values) async {
    await DatabaseRepository.instance.inserRange(values);
  }

  Future<List<PostModel>> getPosts() async {
    var resusltPosts = <PostModel>[];
    var posts = (await DatabaseRepository.instance.getAll<Post>()).map((e) => Post.fromMap(e)).toList();
    
    for (var post in posts) {
      var author = await DatabaseRepository.instance.get<User>(post.authorId);
      var attaches = await DatabaseRepository.instance.getAll<Attach>(whereMap: {"postId": post.id});
      var popularComment = await DatabaseRepository.instance.get<Comment>(post.popularCommentId);

      resusltPosts.add(PostModel(
        id: post.id,
        text: post.text,
        isCommentable: post.isCommentable == 1,
        likeCount: post.likeCount as int,
        commentCount: post.commentCount as int,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        popularComment: popularComment == null ? null : CommentModel.fromJson(popularComment),
        author: UserModel.fromJson(author!),
        attaches: attaches.map((e) => AttachModel.fromJson(e)).toList(),
      ));
    }

    return resusltPosts;
  }
}
