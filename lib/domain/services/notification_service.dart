import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_net/data/models/notification_model.dart';
import 'package:social_net/data/models/notification_token_model.dart';
import 'package:social_net/domain/entities/notification.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/utils.dart';

enum NotificationChannel {
  main,
}

class NotificationService {
  final _database = DatabaseService();
  static final localNotifications = FlutterLocalNotificationsPlugin();
  static const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  static final channels = {
    NotificationChannel.main: AndroidNotificationChannel(
      NotificationChannel.main.name,
      'Main Notifications',
    ),
  };

  Future<List<NotificationModel>> getNotifications({
    int? skip,
    int? take = 10,
    DateTime? fromTime,
  }) async {
    List<NotificationModel> notifications;

    try {
      notifications = await ApiRepository.instance.api.getNotifications(skip, take, fromTime);
      _database.updateNotifications(notifications);
    } catch (e) {
      notifications = await _database.getNotifications(skip, take, fromTime);
    }

    return notifications;
  }

  Future<void> subscribe() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      token.console();
      await ApiRepository.instance.api.subscribe(NotificationTokenModel(token));
    }
  }

  Future<void> unsubscribe() async {
    try {
      await ApiRepository.instance.api.unsubscribe();
    } catch (e) {
      e.toString().console();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    await ApiRepository.instance.api.deleteNotification(notificationId);
    await _database.delete<Notification>(notificationId);
  }
}
