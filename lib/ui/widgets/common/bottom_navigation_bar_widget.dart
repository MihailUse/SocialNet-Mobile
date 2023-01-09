import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/ui/navigation/main_navigator.dart';
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
        var icon = MainNavigator.rootTabs.containsKey(tabItem)
            ? Icon(MainNavigator.rootTabs[tabItem]!.icon)
            : Text(tabItem.name);

        if (tabItem == MainNavigatorRoutes.profile) {
          icon = CircleAvatar(
            radius: mainViewModel.currentTab == tabItem ? 12 : 10,
            foregroundImage: mainViewModel.user == null || mainViewModel.user?.avatarLink == null
                ? const AssetImage("./assets/person.jpg") as ImageProvider
                : CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(mainViewModel.user!.avatarLink!)),
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
