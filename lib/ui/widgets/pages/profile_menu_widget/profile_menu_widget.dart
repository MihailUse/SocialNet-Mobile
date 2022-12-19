import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:social_net/data/internal/secure_local_storage.dart';
import 'package:social_net/ui/app_navigator.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({Key? key}) : super(key: key);

  void onEditProfileButtonPressed() async {
    await AppNavigator.navigateTo(RouteAction.push, AppNavigationRoutes.profileEdit);
  }

  void onlogoutButtonPressed() async {
    await SecureLocalStorage.instance.clearTokens();
    AppNavigator.navigateTo(RouteAction.pushAndRemoveUntil, AppNavigationRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    void onSettingsButtonPressed() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("In progress"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                ? AdaptiveTheme.of(context).setDark()
                : AdaptiveTheme.of(context).setLight(),
            icon: ValueListenableBuilder(
              valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
              builder: (_, mode, child) {
                switch (mode) {
                  case AdaptiveThemeMode.light:
                  case AdaptiveThemeMode.system:
                    return const Icon(Icons.dark_mode);
                  case AdaptiveThemeMode.dark:
                    return const Icon(Icons.light_mode);
                }
              },
            ),
            tooltip: "Change theme",
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(onPressed: onEditProfileButtonPressed, child: const Text('Edit profile')),
          TextButton(onPressed: onSettingsButtonPressed, child: const Text('Settings')),
          TextButton(
              onPressed: onlogoutButtonPressed,
              child: Text(
                'Exit',
                style: TextStyle(color: Theme.of(context).errorColor),
              )),
        ],
      ),
    );
  }
}
