import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/converters/notification_type_converter.dart';
import 'package:social_net/data/models/notification_model.dart';
import 'package:social_net/domain/entities/db_model.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification implements DbModel<String> {
  @override
  final String id;
  final String title;
  final String? subTitle;
  final String? body;
  final String toUserId;
  final String? fromUserId;
  @NotificationTypeConverter()
  final NotificationType notificationType;
  final DateTime? viewedAt;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    this.subTitle,
    this.body,
    required this.toUserId,
    this.fromUserId,
    required this.notificationType,
    this.viewedAt,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  factory Notification.fromMap(Map<String, dynamic> map) => _$NotificationFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$NotificationToJson(this);

  factory Notification.fromModel(NotificationModel notification) => Notification(
        id: notification.id,
        title: notification.title,
        subTitle: notification.subTitle,
        body: notification.body,
        toUserId: notification.toUserId,
        fromUserId: notification.fromUserId,
        notificationType: notification.notificationType,
        viewedAt: notification.viewedAt,
        createdAt: notification.createdAt,
      );
}
