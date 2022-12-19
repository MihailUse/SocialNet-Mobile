import 'package:json_annotation/json_annotation.dart';

import 'package:social_net/data/models/attach_model.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String id;
  final String nickname;
  final String? fullName;
  final String? about;
  final AttachModel? avatar;
  final int followerCount;
  final int followingCount;
  final int postCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserProfileModel({
    required this.id,
    required this.nickname,
    this.fullName,
    this.about,
    this.avatar,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileModel copyWith({
    String? id,
    String? nickname,
    String? fullName,
    String? about,
    AttachModel? avatar,
    int? followerCount,
    int? followingCount,
    int? postCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      about: about ?? this.about,
      avatar: avatar ?? this.avatar,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      postCount: postCount ?? this.postCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
