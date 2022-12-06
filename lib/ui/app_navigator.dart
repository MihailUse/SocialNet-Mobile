import 'package:flutter/cupertino.dart';
import 'package:social_net/ui/widgets/loader_widget.dart';
import 'package:social_net/ui/widgets/auth_widget.dart';
import 'package:social_net/ui/widgets/main_widget.dart';

import 'constants/app_navigation_routes.dart';

class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static void toLoader() async {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigationRoutes.loader, ((route) => false));
  }

  static void toAuth() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigationRoutes.auth, ((route) => false));
  }

  static void toMain() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigationRoutes.main, ((route) => false));
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppNavigationRoutes.auth:
        return PageRouteBuilder<AuthWidget>(
          pageBuilder: ((_, __, ___) => AuthWidget.create()),
          transitionDuration: Duration.zero,
        );

      case AppNavigationRoutes.main:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => MainWidget.create()));

      case AppNavigationRoutes.loader:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => LoaderWidget.create()));

      default:
        return null;
    }
  }
}
