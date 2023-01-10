import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/attach_model.dart';

part 'update_user_model.g.dart';

@JsonSerializable()
class UpdateUserModel {
  final String? nickname;
  final String? fullName;
  final String? about;
  final AttachModel? avatar;

  UpdateUserModel({
    this.nickname,
    this.fullName,
    this.about,
    this.avatar,
  });

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) => _$UpdateUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserModelToJson(this);

  UpdateUserModel copyWith({
    String? nickname,
    String? fullName,
    String? about,
    AttachModel? avatar,
  }) {
    return UpdateUserModel(
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      about: about ?? this.about,
      avatar: avatar ?? this.avatar,
    );
  }
}
