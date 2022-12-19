import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/domain/entities/attach.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String nickname;
  final String? fullName;
  final DateTime? deletedAt;
  final AttachModel? avatar;

  UserModel({
    required this.id,
    required this.nickname,
    this.fullName,
    this.deletedAt,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
