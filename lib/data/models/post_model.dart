import 'package:json_annotation/json_annotation.dart';

import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String? text;
  final bool isCommentable;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel author;
  final List<AttachModel>? attaches;
  final CommentModel? popularComment;

  PostModel({
    required this.id,
    this.text,
    required this.isCommentable,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.createdAt,
    this.updatedAt,
    required this.author,
    this.attaches,
    this.popularComment,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostModel copyWith({
    String? id,
    String? text,
    bool? isCommentable,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? author,
    List<AttachModel>? attaches,
    CommentModel? popularComment,
  }) {
    return PostModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isCommentable: isCommentable ?? this.isCommentable,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      attaches: attaches ?? this.attaches,
      popularComment: popularComment ?? this.popularComment,
    );
  }
}
