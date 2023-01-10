import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/converters/boolean_converter.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel<String> {
  @override
  final String id;
  final String? text;
  @BooleanConverter()
  final int isCommentable;
  final int likeCount;
  final int commentCount;
  @BooleanConverter()
  final int isLiked;
  @BooleanConverter()
  final int isPersonal;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? authorId;
  final String? popularCommentId;

  Post({
    required this.id,
    this.text,
    required this.isCommentable,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.isPersonal,
    this.authorId,
    this.popularCommentId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) {
    final resultMap = {
      ...map,
      "isCommentable": map["isCommentable"] as int == 1,
      "isLiked": map["isLiked"] as int == 1,
      "isPersonal": map["isPersonal"] as int == 1,
    };
    return _$PostFromJson(resultMap);
  }
  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);

  factory Post.fromModel(PostModel post, String authorId, bool isPersonal, [String? popularCommentId]) => Post(
        id: post.id,
        text: post.text,
        isCommentable: post.isCommentable ? 1 : 0,
        likeCount: post.likeCount,
        commentCount: post.commentCount,
        isLiked: post.isLiked ? 1 : 0,
        isPersonal: isPersonal ? 1 : 0,
        authorId: authorId,
        popularCommentId: popularCommentId,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      );

  Post copyWith({
    String? id,
    String? text,
    int? isCommentable,
    int? likeCount,
    int? commentCount,
    int? isLiked,
    int? isPersonal,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authorId,
    String? popularCommentId,
  }) {
    return Post(
      id: id ?? this.id,
      text: text ?? this.text,
      isCommentable: isCommentable ?? this.isCommentable,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isPersonal: isPersonal ?? this.isPersonal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorId: authorId ?? this.authorId,
      popularCommentId: popularCommentId ?? this.popularCommentId,
    );
  }
}
