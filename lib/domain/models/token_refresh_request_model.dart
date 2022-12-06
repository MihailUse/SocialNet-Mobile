import 'package:json_annotation/json_annotation.dart';

part 'token_refresh_request_model.g.dart';

@JsonSerializable()
class TokenRefreshRequestModel {
  final String refreshToken;

  TokenRefreshRequestModel({
    required this.refreshToken,
  });

  factory TokenRefreshRequestModel.fromJson(Map<String, dynamic> json) => _$TokenRefreshRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenRefreshRequestModelToJson(this);
}
