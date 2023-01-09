import 'package:flutter/cupertino.dart';
import 'package:social_net/ui/widgets/roots/camera_widget/camera_widget.dart';
import 'package:social_net/ui/widgets/roots/auth_widget/auth_widget.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_widget.dart';
import 'package:social_net/ui/widgets/roots/registration_widget/registration_widget.dart';

abstract class AppNavigatorRoutes {
  static const loader = "/";
  static const main = "/main";
  static const auth = "/auth";
  static const registration = "/registration";
  static const camera = "/camera";
}

class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> toLoader() async {
    await navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigatorRoutes.loader, (route) => false);
  }

  static Future<void> toAuth() async {
    await navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigatorRoutes.auth, (route) => false);
  }

  static Future<void> toRegistration() async {
    await navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppNavigatorRoutes.registration, (route) => false);
  }

  static Future<void> toMain() async {
    await navigatorKey.currentState?.pushNamedAndRemoveUntil(AppNavigatorRoutes.main, (route) => false);
  }

  static Future<void> toCamera(Object arguments) async {
    await navigatorKey.currentState?.pushNamed(AppNavigatorRoutes.camera, arguments: arguments);
  }

  static void toLast() {
    navigatorKey.currentState?.pop();
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case AppNavigatorRoutes.auth:
        return PageRouteBuilder<AuthWidget>(pageBuilder: ((_, __, ___) => AuthWidget.create()));

      case AppNavigatorRoutes.registration:
        return PageRouteBuilder<RegistrationWidget>(
            pageBuilder: ((_, __, ___) => RegistrationWidget.create()));

      case AppNavigatorRoutes.main:
        return PageRouteBuilder<MainWidget>(pageBuilder: ((_, __, ___) => MainWidget.create()));

      case AppNavigatorRoutes.camera:
        if (arguments is! CameraWidgetArguments) throw ArgumentError("Invalid CameraWidgetArguments");
        return PageRouteBuilder<CameraWidget>(
            pageBuilder: ((_, __, ___) => CameraWidget(
                  cameras: arguments.cameras,
                  onTakePicture: arguments.onTakePicture,
                )));

      default:
        return null;
    }
  }
}
