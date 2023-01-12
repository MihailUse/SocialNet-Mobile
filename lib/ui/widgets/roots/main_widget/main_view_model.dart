import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/data/models/notification_payload.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:social_net/domain/services/notification_service.dart';
import 'package:social_net/domain/services/user_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel(this.context) {
    asyncInit();
  }

  MainNavigatorRoutes _currentTab = MainNavigator.initialRoute;
  final BuildContext context;
  final _userService = UserService();

  static final navigationKeys = {
    MainNavigatorRoutes.home: GlobalKey<NavigatorState>(),
    MainNavigatorRoutes.search: GlobalKey<NavigatorState>(),
    MainNavigatorRoutes.profile: GlobalKey<NavigatorState>(),
    MainNavigatorRoutes.notifications: GlobalKey<NavigatorState>(),
  };

  MainNavigatorRoutes get currentTab => _currentTab;
  set currentTab(MainNavigatorRoutes value) {
    _currentTab = value;
    notifyListeners();
  }

  UserProfileModel? _user;
  UserProfileModel? get user => _user;
  set user(UserProfileModel? value) {
    _user = value;
    notifyListeners();
  }

  static BuildContext? getTabContext(MainNavigatorRoutes route) {
    return MainViewModel.navigationKeys[route]!.currentContext;
  }

  Future<void> asyncInit() async {
    // init notifications
    await NotificationService.localNotifications.initialize(
      NotificationService.initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // init current user
    // Future.delayed(const Duration(seconds: 1)).then((value) async {
    var currentUserId = await LocalStorage.instance.getValue(LocalStorageKeys.currentUserId);
    currentUserId ??= await _userService.getCurrentUserId();

    if (currentUserId == null) {
      await AppNavigator.toAuth();
      return;
    }

    try {
      user = await _userService.getUserById(currentUserId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed load profile info"),
        ),
      );
    }
    // });
  }

  void onSelectTab(MainNavigatorRoutes value) {
    if (currentTab == value) {
      // navigate to root tab
      navigationKeys[value]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      currentTab = value;
    }
  }

  static void onDidReceiveNotificationResponse(NotificationResponse details) {
    final notificationTabContext = MainViewModel.getTabContext(MainNavigatorRoutes.notifications);

    if (notificationTabContext != null) {
      final mainViewModel = notificationTabContext.read<MainViewModel>();
      mainViewModel.onSelectTab(MainNavigatorRoutes.notifications);

      if (details.payload != null) {
        final payloadMap = jsonDecode(details.payload!) as Map<String, dynamic>;
        final payload = NotificationPayload.fromJson(payloadMap);
        Navigator.of(notificationTabContext).pushNamedAndRemoveUntil(
          NestedNavigatorRoutes.notification,
          (route) => false,
          arguments: payload.notificationId,
        );
      }
    }
  }
}
