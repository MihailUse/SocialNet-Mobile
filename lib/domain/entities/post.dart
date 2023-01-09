import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/converters/boolean_converter.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel<String> {
  @override
  final String id;
  final String? text;
  @BooleanConverter()
  final num isCommentable;
  final num likeCount;
  final num commentCount;
  @BooleanConverter()
  final num isLiked;
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
      "isCommentable": map["isCommentable"] as num == 1,
      "isLiked": map["isLiked"] as num == 1,
    };
    return _$PostFromJson(resultMap);
  }
  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);

  Post copyWith({
    String? id,
    String? text,
    num? isCommentable,
    num? likeCount,
    num? commentCount,
    num? isLiked,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorId: authorId ?? this.authorId,
      popularCommentId: popularCommentId ?? this.popularCommentId,
    );
  }
}
