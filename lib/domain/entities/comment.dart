import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/converters/boolean_converter.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment implements DbModel<String> {
  @override
  final String id;
  final String text;
  final int likeCount;
  @BooleanConverter()
  final int isLiked;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? postId;
  final String? authorId;

  Comment({
    required this.id,
    required this.text,
    required this.likeCount,
    required this.isLiked,
    required this.createdAt,
    this.updatedAt,
    this.postId,
    this.authorId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  factory Comment.fromMap(Map<String, dynamic> map) {
    final resultMap = {
      ...map,
      "isLiked": map["isLiked"] as int == 1,
    };
    return _$CommentFromJson(resultMap);
  }
  @override
  Map<String, dynamic> toMap() => _$CommentToJson(this);

  factory Comment.fromModel(CommentModel comment, String postId, String authorId) => Comment(
        id: comment.id,
        text: comment.text,
        likeCount: comment.likeCount,
        isLiked: comment.isLiked ? 1 : 0,
        createdAt: comment.createdAt,
        updatedAt: comment.updatedAt,
        postId: postId,
        authorId: authorId,
      );

  Comment copyWith({
    String? id,
    String? text,
    int? likeCount,
    int? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? postId,
    String? authorId,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
    );
  }
}
