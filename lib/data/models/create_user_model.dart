import 'package:json_annotation/json_annotation.dart';

part 'create_user_model.g.dart';

@JsonSerializable()
class CreateUserModel {
  final String email;
  final String nickname;
  final String password;
  final String passwordRetry;

  CreateUserModel({
    required this.email,
    required this.nickname,
    required this.password,
    required this.passwordRetry,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) => _$CreateUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserModelToJson(this);
}
