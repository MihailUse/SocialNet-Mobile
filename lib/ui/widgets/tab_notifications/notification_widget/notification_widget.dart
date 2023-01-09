import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/tab_notifications/notification_widget/notification_view_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("notification_widget"),
    );
  }

  static Widget create() => ChangeNotifierProvider<NotificationViewModel>(
        lazy: false,
        create: (_) => NotificationViewModel(),
        child: const NotificationWidget(),
      );
}
