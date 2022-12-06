import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_net/domain/models/token_model.dart';

abstract class _SessionProviderKeys {
  static const token = "api_key";
  static const refreshToken = "api_refresh_token";
}

class SessionClient {
  static final SessionClient _instance = SessionClient._internal();
  SessionClient._internal();

  factory SessionClient() {
    return _instance;
  }

  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: _SessionProviderKeys.token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _SessionProviderKeys.refreshToken);
  }

  Future<void> setTokens(TokenModel tokens) async {
    await _storage.write(key: _SessionProviderKeys.token, value: tokens.accessToken);
    await _storage.write(key: _SessionProviderKeys.refreshToken, value: tokens.refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _SessionProviderKeys.token);
    await _storage.delete(key: _SessionProviderKeys.refreshToken);
  }
}
