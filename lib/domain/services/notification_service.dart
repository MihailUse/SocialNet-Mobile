import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_net/data/models/notification_token_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/utils.dart';

class NotificationService {
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
}
