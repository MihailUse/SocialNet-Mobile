import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:social_net/ui/app_navigator.dart';
import 'package:social_net/ui/themes/dark.dart';
import 'package:social_net/ui/themes/light.dart';
import 'package:social_net/ui/widgets/pages/loader_widget/loader_widget.dart';

class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const App({super.key, this.savedThemeMode});

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
        home: LoaderWidget.create(),
        navigatorKey: AppNavigator.navigatorKey,
        onGenerateRoute: AppNavigator.onGenerateRoute,
      ),
    );
  }
}
