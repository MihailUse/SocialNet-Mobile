import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:social_net/ui/widgets/app.dart';
import 'package:social_net/domain/repository/database_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await DatabaseRepository.instance.init();
  runApp(App(savedThemeMode: savedThemeMode));
}
