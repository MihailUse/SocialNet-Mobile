import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({super.key});

  void onlogoutButtonPressed() async {
    final authService = AuthService();
    await authService.logout();
    await AppNavigator.toAuth();
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

    void onEditProfileButtonPressed() async {
      await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profileEdit);
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
                if (mode == AdaptiveThemeMode.dark) {
                  return const Icon(Icons.light_mode);
                }

                return const Icon(Icons.dark_mode);
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
            ),
          ),
        ],
      ),
    );
  }
}
