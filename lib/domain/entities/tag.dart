import 'package:json_annotation/json_annotation.dart';

import 'package:social_net/data/converters/boolean_converter.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag implements DbModel<String> {
  @override
  final String id;
  final String name;
  final int postCount;
  final int followerCount;
  @BooleanConverter()
  final bool isFollowed;

  Tag({
    required this.id,
    required this.name,
    required this.postCount,
    required this.followerCount,
    required this.isFollowed,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  factory Tag.fromMap(Map<String, dynamic> map) {
    final resultMap = {
      ...map,
      "isFollowed": map["isFollowed"] as num == 1,
    };
    return _$TagFromJson(resultMap);
  }
  @override
  Map<String, dynamic> toMap() => _$TagToJson(this);

  Tag copyWith({
    String? id,
    String? name,
    int? postCount,
    int? followerCount,
    bool? isFollowed,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      postCount: postCount ?? this.postCount,
      followerCount: followerCount ?? this.followerCount,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}
