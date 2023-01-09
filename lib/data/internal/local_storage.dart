import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageKeys {
  static const currentUserId = "current_user_id";
}

class LocalStorage {
  LocalStorage._();
  static final instance = LocalStorage._();

  Future<String?> getValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<void> setValue(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  Future<void> remove(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }
}
