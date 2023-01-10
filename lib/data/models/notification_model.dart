import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/converters/notification_type_converter.dart';
import 'package:social_net/domain/entities/notification.dart';

part 'notification_model.g.dart';

enum NotificationType {
  likePost,
  likeComment,
  newFollower,
  public,
}

@JsonSerializable()
class NotificationModel {
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

  NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  factory NotificationModel.fromEntity(Notification notification) => NotificationModel(
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
