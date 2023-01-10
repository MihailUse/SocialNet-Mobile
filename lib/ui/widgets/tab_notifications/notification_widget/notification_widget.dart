import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:social_net/data/models/notification_model.dart';
import 'package:social_net/ui/widgets/tab_notifications/notification_widget/notification_view_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    return GestureDetector(
      onTap: viewModel.viewNotification,
      child: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: CustomScrollView(
          controller: viewModel.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverAppBar(
              title: Text("Notifications"),
            ),
            if (viewModel.notifications == null || viewModel.notifications!.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child:
                      viewModel.notifications == null ? const CircularProgressIndicator() : const Text("notifications not found"),
                ),
              )
            else
              SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    viewModel.notifications!.length,
                    (index) => _NotificationCardWidget(notification: viewModel.notifications![index]),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  static Widget create([String? notificationId]) => ChangeNotifierProvider<NotificationViewModel>(
        lazy: false,
        create: (context) => NotificationViewModel(context, notificationId),
        child: const NotificationWidget(),
      );
}

class _NotificationCardWidget extends StatelessWidget {
  const _NotificationCardWidget({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<NotificationViewModel>();

    return Dismissible(
      key: Key(notification.id),
      onDismissed: (details) => viewModel.removeNotification(details, notification),
      child: Card(
        shape: RoundedRectangleBorder(
          side: viewModel.notificationId == notification.id ? const BorderSide(color: Colors.blue, width: 2.0) : BorderSide.none,
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Icon(viewModel.getNotificationTypeIconData(notification.notificationType)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    if (notification.subTitle != null) Text(notification.subTitle!, style: Theme.of(context).textTheme.subtitle2),
                    if (notification.body != null) Text(notification.body!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    DateFormat.yMEd().format(notification.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
