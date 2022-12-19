import 'package:social_net/data/internal/secure_local_storage.dart';
import 'package:social_net/data/models/auth/token_request_model.dart';
import 'package:social_net/data/models/create_user_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class AuthService {
  final _authClient = ApiRepository.instance.auth;

  Future<bool> checkAuth() async {
    final refreshToken = await SecureLocalStorage.instance.getRefreshToken();
    return refreshToken != null;
  }

  Future<void> login(String login, String password) async {
    final tokenRequestModel = TokenRequestModel(email: login, password: password);
    final tokens = await _authClient.getTokens(tokenRequestModel);

    await SecureLocalStorage.instance.setTokens(tokens);
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
    await SecureLocalStorage.instance.clearTokens();
  }
}
