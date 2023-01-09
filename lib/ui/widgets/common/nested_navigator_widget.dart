import 'package:flutter/material.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/camera_widget.dart';
import 'package:social_net/ui/widgets/tab_home/create_post_widget/create_post_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/edit_profile_widget/edit_profile_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/profile_menu_widget/profile_menu_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/profile_widget/profile_widget.dart';
import 'package:social_net/ui/widgets/tab_search/tag_detail/tag_detail_widget.dart';

class NestedNavigatorWidget extends StatelessWidget {
  const NestedNavigatorWidget({super.key, required this.navigatorKey, required this.tabItem});

  final MainNavigatorRoutes tabItem;
  final GlobalKey<NavigatorState> navigatorKey;

  WidgetBuilder _getBuilder(BuildContext context, dynamic route, {Object? arguments}) {
    switch (route) {
      case NestedNavigatorRoutes.root:
        return (_) => MainNavigator.rootTabs[tabItem]!.widget;

      case NestedNavigatorRoutes.profile:
        if (arguments is! String) throw ArgumentError("Invalid ProfileWidget arguments");
        return (_) => ProfileWidget.create(arguments);

      case NestedNavigatorRoutes.profileMenu:
        return (_) => const ProfileMenuWidget();

      case NestedNavigatorRoutes.profileEdit:
        return (_) => EditProfileWidget.create();

      case NestedNavigatorRoutes.postCreate:
        return (_) => CreatePostWidget.create();

      case NestedNavigatorRoutes.camera:
        if (arguments is! CameraWidgetArguments) throw ArgumentError("Invalid CameraWidget arguments");
        return (_) => CameraWidget(
              cameras: arguments.cameras,
              onTakePicture: arguments.onTakePicture,
            );

      case NestedNavigatorRoutes.tag:
        if (arguments is! TagDetailWidgetArguments) throw ArgumentError("Invalid TagDetailWidget arguments");
        return (_) => TagDetailWidget.create(arguments);

      default:
        return (_) => Center(child: Text(tabItem.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: NestedNavigatorRoutes.root,
      onGenerateRoute: (settings) {
        final builder = _getBuilder(context, settings.name, arguments: settings.arguments);
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
