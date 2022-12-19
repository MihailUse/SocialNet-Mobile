import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

@JsonSerializable()
class TagModel {
  final String id;
  final String name;
  final int postCount;
  final int followerCount;

  TagModel({
    required this.id,
    required this.name,
    required this.postCount,
    required this.followerCount,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) => _$TagModelFromJson(json);
  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}
