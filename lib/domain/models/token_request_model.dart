import 'package:json_annotation/json_annotation.dart';

part 'token_request_model.g.dart';

@JsonSerializable()
class TokenRequestModel {
  final String email;
  final String password;

  TokenRequestModel({
    required this.email,
    required this.password,
  });

  factory TokenRequestModel.fromJson(Map<String, dynamic> json) => _$TokenRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenRequestModelToJson(this);
}
