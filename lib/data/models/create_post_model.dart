import 'package:json_annotation/json_annotation.dart';

import 'package:social_net/data/models/attach_model.dart';

part 'create_post_model.g.dart';

@JsonSerializable()
class CreatePostModel {
  final String text;
  final bool isCommentable;
  final List<AttachModel>? attaches;

  const CreatePostModel({
    required this.text,
    required this.isCommentable,
    required this.attaches,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) => _$CreatePostModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);

  CreatePostModel copyWith({
    String? text,
    bool? isCommentable,
    List<AttachModel>? attaches,
  }) {
    return CreatePostModel(
      text: text ?? this.text,
      isCommentable: isCommentable ?? this.isCommentable,
      attaches: attaches ?? this.attaches,
    );
  }
}
