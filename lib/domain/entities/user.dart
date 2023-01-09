import 'package:json_annotation/json_annotation.dart';

import 'package:social_net/data/converters/boolean_converter.dart';
import 'package:social_net/data/models/user_model.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements DbModel<String> {
  @override
  final String id;
  final String nickname;
  final String? fullName;
  final String? about;
  final String? avatarLink;
  @BooleanConverter()
  final num? isFollowing;
  final int? followerCount;
  final int? followingCount;
  final int? postCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  String? avatarId;

  User({
    required this.id,
    required this.nickname,
    this.fullName,
    this.about,
    this.avatarLink,
    this.isFollowing,
    this.followerCount,
    this.followingCount,
    this.postCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.avatarId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(Map<String, dynamic> map) {
    final resultMap = {
      ...map,
      "isFollowing": (map["isFollowing"] ?? 0) as num == 1,
    };
    return _$UserFromJson(resultMap);
  }
  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);

  factory User.fromModel(UserModel user) => User(
      id: user.id,
      nickname: user.nickname,
      fullName: user.fullName,
      avatarLink: user.avatarLink,
      deletedAt: user.deletedAt,
      avatarId: user.avatar?.id);

  User copyWith({
    String? id,
    String? nickname,
    String? fullName,
    String? about,
    String? avatarLink,
    num? isFollowing,
    int? followerCount,
    int? followingCount,
    int? postCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? avatarId,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      about: about ?? this.about,
      avatarLink: avatarLink ?? this.avatarLink,
      isFollowing: isFollowing ?? this.isFollowing,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      postCount: postCount ?? this.postCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}
