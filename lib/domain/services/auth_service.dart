import 'package:social_net/data/internal/local_storage.dart';
import 'package:social_net/data/internal/secure_local_storage.dart';
import 'package:social_net/data/models/auth/token_request_model.dart';
import 'package:social_net/data/models/create_user_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/domain/services/notification_service.dart';

class AuthService {
  final _authClient = ApiRepository.instance.auth;
  final _notificationService = NotificationService();

  Future<bool> checkAuth() async {
    final token = await SecureLocalStorage.instance.getToken();
    final refreshToken = await SecureLocalStorage.instance.getRefreshToken();
    final isAuthorized = refreshToken != null && token != null;

    if (isAuthorized) {
      try {
        // await _notificationService.subscribe();
      } catch (e) {}
    }

    return isAuthorized;
  }

  Future<void> login(String login, String password) async {
    final tokenRequestModel = TokenRequestModel(email: login, password: password);
    final tokens = await _authClient.getTokens(tokenRequestModel);

    await SecureLocalStorage.instance.setTokens(tokens);
    // await _notificationService.subscribe();
  }

  Future<void> createUser(String email, String nickname, String password, String passwordRetry) async {
    final tokenRequestModel = CreateUserModel(
      email: email,
      nickname: nickname,
      password: password,
      passwordRetry: passwordRetry,
    );
    final tokens = await _authClient.createUser(tokenRequestModel);
    await SecureLocalStorage.instance.setTokens(tokens);
  }

  Future<void> logout() async {
    await _notificationService.unsubscribe();
    await LocalStorage.instance.remove(LocalStorageKeys.currentUserId);
    await SecureLocalStorage.instance.clearTokens();
  }
}
