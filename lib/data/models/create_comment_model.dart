import 'package:json_annotation/json_annotation.dart';

part 'create_comment_model.g.dart';

@JsonSerializable()
class CreateCommentModel {
  final String text;
  final String postId;

  CreateCommentModel({
    required this.text,
    required this.postId,
  });

  factory CreateCommentModel.fromJson(Map<String, dynamic> json) => _$CreateCommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateCommentModelToJson(this);
}
