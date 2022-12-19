import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_net/data/models/auth/token_model.dart';

abstract class _SecureLocalStorageKeys {
  static const token = "api_key";
  static const refreshToken = "api_refresh_token";
}

class SecureLocalStorage {
  SecureLocalStorage._();
  static final SecureLocalStorage instance = SecureLocalStorage._();

  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: _SecureLocalStorageKeys.token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _SecureLocalStorageKeys.refreshToken);
  }

  Future<void> setTokens(TokenModel tokens) async {
    await _storage.write(key: _SecureLocalStorageKeys.token, value: tokens.accessToken);
    await _storage.write(key: _SecureLocalStorageKeys.refreshToken, value: tokens.refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _SecureLocalStorageKeys.token);
    await _storage.delete(key: _SecureLocalStorageKeys.refreshToken);
  }
}
