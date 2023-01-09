import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';
import 'package:social_net/ui/themes/dark.dart';
import 'package:social_net/ui/themes/light.dart';
import 'package:social_net/ui/widgets/roots/loader_widget/loader_widget.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: LightAppTheme,
      dark: DarkAppTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (lightTheme, darkTheme) => MaterialApp(
        title: 'Social Net',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: LoaderWidget(),
        navigatorKey: AppNavigator.navigatorKey,
        onGenerateRoute: AppNavigator.onGenerateRoute,
      ),
    );
  }
}
