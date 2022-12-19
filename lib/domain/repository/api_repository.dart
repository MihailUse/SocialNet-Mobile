import 'package:dio/dio.dart';
import 'package:social_net/data/clients/api_client.dart';
import 'package:social_net/data/clients/auth_client.dart';
import 'package:social_net/data/internal/secure_local_storage.dart';
import 'package:social_net/domain/config.dart';
import 'package:social_net/domain/exceptions/un_authorized_exception.dart';
import 'package:social_net/data/models/auth/token_refresh_request_model.dart';
import 'package:social_net/domain/repository/dio_Interceptors/error_handler_interceptor.dart';
import 'package:social_net/ui/app_navigator.dart';

class ApiRepository {
  ApiRepository._() {
    var apiDio = Dio(_baseOptions);
    var authDio = Dio(_baseOptions);

    apiDio.interceptors.addAll(<Interceptor>{
      ErrorHandlerInterceptor(),
      _createApiInterceptor(apiDio),
    });

    authDio.interceptors.add(ErrorHandlerInterceptor());

    api = ApiClient(apiDio);
    auth = AuthClient(authDio);
  }

  late final ApiClient api;
  late final AuthClient auth;
  final _baseOptions = BaseOptions(baseUrl: Config.apiBaseUrl);
  final _sessionClient = SecureLocalStorage.instance;
  static final ApiRepository instance = ApiRepository._();

  static String getUserAvatarPath(String userId) {
    return "${Config.apiBaseUrl}/api/Attach/GetUserAvatar?userId=$userId";
  }

  static String getPostAttachPath(String postId, String attachId) {
    return "${Config.apiBaseUrl}/api/Attach/GetPostAttach?postId=$postId&attachId=$attachId";
  }

  // TODO: refactor this method
  QueuedInterceptorsWrapper _createApiInterceptor(Dio dio) {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _sessionClient.getToken();

        if (token == null) {
          _sessionClient.clearTokens();
          AppNavigator.toLoader();
          return;
        }

        options.headers.addAll({"Authorization": "Bearer $token"});
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e is UnAuthorizedException) {
          try {
            final refreshToken = await _sessionClient.getRefreshToken();

            if (refreshToken == null) {
              _sessionClient.clearTokens();
              AppNavigator.toLoader();
              return handler.next(e);
            }

            // get new tokens and save
            final tokens = await auth.getTokensByRefresh(TokenRefreshRequestModel(refreshToken: refreshToken));
            await _sessionClient.setTokens(tokens);

            // set header
            e.requestOptions.headers["Authorization"] = "Bearer ${tokens.accessToken}";
          } catch (err) {
            _sessionClient.clearTokens();
            AppNavigator.toLoader();
            return handler.next(e);
          }

          return handler.resolve(await dio.fetch(e.requestOptions));
        }

        return handler.next(e);
      },
    );
  }
}
