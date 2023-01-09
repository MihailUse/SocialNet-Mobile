import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/user_model.dart';
import 'package:social_net/domain/entities/comment.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String id;
  final String text;
  final int likeCount;
  final bool isLiked;
  final UserModel author;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentModel({
    required this.id,
    required this.text,
    required this.likeCount,
    required this.isLiked,
    required this.author,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  factory CommentModel.fromEntity(Comment comment, UserModel author) => CommentModel(
        id: comment.id,
        text: comment.text,
        likeCount: comment.likeCount,
        isLiked: comment.isLiked == 1,
        author: author,
        createdAt: comment.createdAt,
      );
}
