import 'package:json_annotation/json_annotation.dart';

part 'notification_token_model.g.dart';

@JsonSerializable()
class NotificationTokenModel {
  final String token;

  NotificationTokenModel(this.token);

  factory NotificationTokenModel.fromJson(Map<String, dynamic> json) => _$NotificationTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationTokenModelToJson(this);
}