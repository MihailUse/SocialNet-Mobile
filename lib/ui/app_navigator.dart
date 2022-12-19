import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:social_net/ui/common/camera_widget.dart';
import 'package:social_net/ui/widgets/pages/create_post_widget/create_post_widget.dart';
import 'package:social_net/ui/widgets/pages/edit_profile_widget/edit_profile_widget.dart';
import 'package:social_net/ui/widgets/pages/loader_widget/loader_widget.dart';
import 'package:social_net/ui/widgets/pages/auth_widget/auth_widget.dart';
import 'package:social_net/ui/widgets/pages/main_widget/main_widget.dart';
import 'package:social_net/ui/widgets/pages/profile_menu_widget/profile_menu_widget.dart';
import 'package:social_net/ui/widgets/pages/registration_widget/registration_widget.dart';

enum RouteAction {
  push,
  pushAndRemoveUntil,
}

abstract class AppNavigationRoutes {
  static const loader = "/";
  static const main = "/main";
  static const auth = "/auth";
  static const camera = "/camera";
  static const registration = "/registration";
  static const postCreate = "/post/create";
  static const profileMenu = "/profile/menu";
  static const profileEdit = "/profile/edit";
}

class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static void toLoader() async {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigationRoutes.loader, (route) => false);
  }

  static Future<void> navigateTo(RouteAction action, String route, {Object? arguments}) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) throw Exception("navigator is null");

    switch (action) {
      case RouteAction.push:
        return navigator.pushNamed(route, arguments: arguments);
      case RouteAction.pushAndRemoveUntil:
        return navigator.pushNamedAndRemoveUntil(route, (route) => false, arguments: arguments);
    }
  }

  static void toLast() {
    navigatorKey.currentState?.pop();
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppNavigationRoutes.auth:
        return PageRouteBuilder<AuthWidget>(
          pageBuilder: ((_, __, ___) => AuthWidget.create()),
          transitionDuration: Duration.zero,
        );

      case AppNavigationRoutes.registration:
        return PageRouteBuilder<AuthWidget>(pageBuilder: ((_, __, ___) => RegistrationWidget.create()));

      case AppNavigationRoutes.main:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => MainWidget.create());

      case AppNavigationRoutes.loader:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => LoaderWidget.create());

      case AppNavigationRoutes.profileMenu:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const ProfileMenuWidget());

      case AppNavigationRoutes.profileEdit:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => EditProfileWidget.create());

      case AppNavigationRoutes.postCreate:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => CreatePostWidget.create());

      case AppNavigationRoutes.camera:
        return PageRouteBuilder(pageBuilder: (_, __, ___) {
          final arguments = settings.arguments as CameraWidgetArguments;
          return CameraWidget(onTakePicture: arguments.onTakePicture, cameras: arguments.cameras);
        });

      default:
        return null;
    }
  }
}
