import 'package:json_annotation/json_annotation.dart';
import 'package:social_net/data/models/notification_model.dart';

class NotificationTypeConverter implements JsonConverter<NotificationType, int> {
  const NotificationTypeConverter();

  @override
  NotificationType fromJson(int object) => NotificationType.values[object];

  @override
  int toJson(NotificationType json) => json.index;
}
