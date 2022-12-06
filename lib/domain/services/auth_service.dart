import 'package:social_net/domain/clients/local/session_client.dart';
import 'package:social_net/domain/models/token_request_model.dart';
import 'package:social_net/domain/models/token_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class AuthService {
  final _sessionClient = SessionClient();
  final _authClient = ApiRepository.auth;

  Future<bool> checkAuth() async {
    final refreshToken = await _sessionClient.getRefreshToken();
    return refreshToken != null;
  }

  Future<void> login(String login, String password) async {
    final TokenRequestModel tokenRequestModel = TokenRequestModel(email: login, password: password);
    final TokenModel tokens = await _authClient.getTokens(tokenRequestModel);

    await _sessionClient.setTokens(tokens);
  }

  Future<void> logout() async {
    await _sessionClient.clearTokens();
  }
}
