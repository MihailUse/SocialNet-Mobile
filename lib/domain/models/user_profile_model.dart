import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/domain/models/avatar_model.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String nickname;
  final String? fullName;
  final String about;
  final int followerCount;
  final int followingCount;
  final int postCount;
  final AvatarModel? avatar;

  UserProfileModel({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.nickname,
    this.fullName,
    required this.about,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    this.avatar,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
