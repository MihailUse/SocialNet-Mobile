import 'package:flutter/material.dart';
import 'package:social_net/ui/app_navigator.dart';

class ProfileViewModel extends ChangeNotifier {
  void onProfileMenuPressed() {
    AppNavigator.navigateTo(RouteAction.push, AppNavigationRoutes.profileMenu);
  }

  String parseCount(int count) {
    if (count > 1000) {
      final resCount = (count.toDouble() / 1000).toStringAsFixed(1);
      return "$resCount k";
    }

    return count.toString();
  }
}
