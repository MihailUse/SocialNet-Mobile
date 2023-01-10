import 'package:flutter/material.dart';
import 'package:social_net/data/models/notification_model.dart';
import 'package:social_net/domain/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel(this.context, this.notificationId) {
    asyncInit();
  }

  String? notificationId;
  bool isLoading = false;
  List<NotificationModel>? notifications;
  final BuildContext context;
  final scrollController = ScrollController();
  final _notificationService = NotificationService();

  Future<void> asyncInit() async {
    notifications = await _notificationService.getNotifications();
    scrollController.addListener(loadNotifications);
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.offset;
    final percent = (current / max * 100);

    if (!isLoading && notifications != null && percent > 80) {
      final fromTime = notifications!.isNotEmpty ? notifications!.last.createdAt : null;
      isLoading = true;
      notifyListeners();

      notifications!.addAll(await _notificationService.getNotifications(fromTime: fromTime));

      isLoading = false;
      notifyListeners();
    }
  }

  void removeNotification(DismissDirection details, NotificationModel notification) async {
    try {
      await _notificationService.deleteNotification(notification.id);
      notifications!.removeWhere((element) => element.id == notification.id);
      notifyListeners();
    } catch (e) {
      showError("failed to remove notification");
    }
  }

  void viewNotification() {
    notificationId = null;
    notifyListeners();
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  IconData getNotificationTypeIconData(NotificationType notificationType) {
    switch (notificationType) {
      case NotificationType.likePost:
      case NotificationType.likeComment:
        return Icons.thumb_up_alt_outlined;
      case NotificationType.newFollower:
        return Icons.person_add_outlined;
      case NotificationType.public:
        return Icons.public;
    }
  }
}
