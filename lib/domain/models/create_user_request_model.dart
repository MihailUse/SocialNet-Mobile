import 'package:json_annotation/json_annotation.dart';

part 'create_user_request_model.g.dart';

@JsonSerializable()
class CreateUserRequestModel {
  final String email;
  final String nickname;
  final String password;
  final String passwordRetry;

  CreateUserRequestModel({
    required this.email,
    required this.nickname,
    required this.password,
    required this.passwordRetry,
  });

  factory CreateUserRequestModel.fromJson(Map<String, dynamic> json) => _$CreateUserRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserRequestModelToJson(this);
}
