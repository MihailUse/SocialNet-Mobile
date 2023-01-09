import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_net/init_app.dart';
import 'package:social_net/ui/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  // get savedThemeMode for AdaptiveTheme and remove key from SharedPreferences
  // for disable double build on startup
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(AdaptiveTheme.prefKey);

  runApp(AppWidget(savedThemeMode: savedThemeMode));
}
