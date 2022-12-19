import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageKeys {
  static const appTheme = "app_theme";
}

class LocalStorage {
  LocalStorage._();
  static final LocalStorage instance = LocalStorage._();

  final _defaultValues = {
    LocalStorageKeys.appTheme: "light",
  };

  Future<String> getValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? _defaultValues[key]!;
  }

  Future<void> setValue(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }
}
