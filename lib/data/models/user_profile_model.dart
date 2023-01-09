import 'package:json_annotation/json_annotation.dart';

import 'package:social_net/data/models/attach_model.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String id;
  final String nickname;
  final String? fullName;
  final String? about;
  final String? avatarLink;
  final AttachModel? avatar;
  final bool? isFollowing;
  final int? followerCount;
  final int? followingCount;
  final int? postCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserProfileModel({
    required this.id,
    required this.nickname,
    this.fullName,
    this.about,
    this.avatarLink,
    this.avatar,
    this.isFollowing,
    this.followerCount,
    this.followingCount,
    this.postCount,
    this.createdAt,
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
    String? avatarLink,
    AttachModel? avatar,
    bool? isFollowing,
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
      avatarLink: avatarLink ?? this.avatarLink,
      avatar: avatar ?? this.avatar,
      isFollowing: isFollowing ?? this.isFollowing,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      postCount: postCount ?? this.postCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
