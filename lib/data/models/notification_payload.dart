import 'package:json_annotation/json_annotation.dart';

part 'notification_payload.g.dart';

@JsonSerializable()
class NotificationPayload {
  final String? fromUserId;
  final String notificationId;

  NotificationPayload({
    this.fromUserId,
    required this.notificationId,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) => _$NotificationPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);
}
