import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
import 'package:social_net/ui/widgets/common/user_avatar_widget.dart';
import 'package:social_net/ui/widgets/roots/main_widget/main_view_model.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  final MainNavigatorRoutes currentTab;
  final ValueChanged<MainNavigatorRoutes> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final mainViewModel = context.watch<MainViewModel>();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: MainNavigatorRoutes.values.indexOf(currentTab),
      items: MainNavigatorRoutes.values.map((tabItem) {
        Widget icon =
            MainNavigator.rootTabs.containsKey(tabItem) ? Icon(MainNavigator.rootTabs[tabItem]!.icon) : Text(tabItem.name);

        if (tabItem == MainNavigatorRoutes.profile) {
          icon = UserAvatarWidget(
            avatarLink: mainViewModel.user?.avatarLink,
            radius: mainViewModel.currentTab == MainNavigatorRoutes.profile ? 14 : 10,
          );
        }

        return BottomNavigationBarItem(icon: icon, label: tabItem.name);
      }).toList(),
      onTap: (value) {
        FocusScope.of(context).unfocus();
        onSelectTab(MainNavigatorRoutes.values[value]);
      },
    );
  }
}
