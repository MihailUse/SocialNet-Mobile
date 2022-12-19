import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag implements DbModel<String> {
  @override
  final String id;
  final String name;
  final int postCount;
  final int followerCount;

  Tag({
    required this.id,
    required this.name,
    required this.postCount,
    required this.followerCount,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  factory Tag.fromMap(Map<String, dynamic> map) => _$TagFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$TagToJson(this);
}
