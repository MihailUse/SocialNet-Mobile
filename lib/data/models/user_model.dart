import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String nickname;
  final String? avatarLink;
  final String? fullName;
  final DateTime? deletedAt;
  final AttachModel? avatar;

  UserModel({
    required this.id,
    required this.nickname,
    this.avatarLink,
    this.fullName,
    this.deletedAt,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user, [AttachModel? avatar]) => UserModel(
        id: user.id,
        nickname: user.nickname,
        avatarLink: user.avatarLink,
        fullName: user.fullName,
        deletedAt: user.deletedAt,
        avatar: avatar,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  UserModel copyWith({
    String? id,
    String? nickname,
    String? avatarLink,
    String? fullName,
    DateTime? deletedAt,
    AttachModel? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarLink: avatarLink ?? this.avatarLink,
      fullName: fullName ?? this.fullName,
      deletedAt: deletedAt ?? this.deletedAt,
      avatar: avatar ?? this.avatar,
    );
  }
}
