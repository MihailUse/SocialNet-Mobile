import 'package:flutter/material.dart';
import 'package:social_net/ui/widgets/tab_home/home_widget/home_widget.dart';
import 'package:social_net/ui/widgets/tab_notifications/notification_widget/notification_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/profile_widget/profile_widget.dart';
import 'package:social_net/ui/widgets/tab_search/search_widget/search_widget.dart';

enum MainNavigatorRoutes {
  home,
  search,
  notifications,
  profile,
}

class RootTab {
  RootTab(this.widget, this.icon);

  final Widget widget;
  final IconData icon;
}

class MainNavigator {
  static const MainNavigatorRoutes initialRoute = MainNavigatorRoutes.home;

  static final Map<MainNavigatorRoutes, RootTab> rootTabs = {
    MainNavigatorRoutes.home: RootTab(HomeWidget.create(), Icons.home_outlined),
    MainNavigatorRoutes.search: RootTab(SearchWidget.create(), Icons.search_outlined),
    MainNavigatorRoutes.notifications: RootTab(NotificationWidget.create(), Icons.notifications_outlined),
    MainNavigatorRoutes.profile: RootTab(ProfileWidget.create(), Icons.person_outline_outlined),
  };
}
