import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_net/data/models/notification_payload.dart';
import 'package:social_net/domain/repository/database_repository.dart';
import 'package:social_net/domain/services/notification_service.dart';
import 'package:social_net/firebase_options.dart';
import 'package:social_net/utils.dart';

Future<void> initApp() async {
  await DatabaseRepository.instance.init();
  await NotificationService.localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(NotificationService.channels[NotificationChannel.main]!);
  await initFireBase();
}

Future<void> initFireBase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    carPlay: false,
    announcement: false,
    criticalAlert: true,
    provisional: false,
  );

  FirebaseMessaging.onMessage.listen(catchMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(catchMessage);
}

void catchMessage(RemoteMessage message) async {
  "Got a message whilst in the foreground!".console();
  "Message data: ${message.data}".console();

  if (message.notification != null) {
    final notification = message.notification!;
    final channel = NotificationService.channels[NotificationChannel.main]!;

    await NotificationService.localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
      ),
      payload: message.data["data"] as String
    );
  }
}
