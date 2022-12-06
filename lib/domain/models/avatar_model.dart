import 'package:json_annotation/json_annotation.dart';

part 'avatar_model.g.dart';

@JsonSerializable()
class AvatarModel {
  final String id;
  final String name;
  final String mimeType;
  final int size;
  final String link;

  AvatarModel({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.size,
    required this.link,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) => _$AvatarModelFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarModelToJson(this);
}
