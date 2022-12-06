import 'package:dio/dio.dart';
import 'package:social_net/domain/clients/local/session_client.dart';
import 'package:social_net/domain/clients/remote/api_client.dart';
import 'package:social_net/domain/clients/remote/auth_client.dart';
import 'package:social_net/domain/config.dart';
import 'package:social_net/domain/exceptions/un_authorized_exception.dart';
import 'package:social_net/domain/models/token_refresh_request_model.dart';
import 'package:social_net/domain/repository/dio_Interceptors/error_handler_interceptor.dart';
import 'package:social_net/ui/app_navigator.dart';

class ApiRepository {
  static final _sessionClient = SessionClient();
  static final _baseOptions = BaseOptions();
  static AuthClient? _authClient;
  static ApiClient? _apiClient;

  static AuthClient get auth {
    _authClient ??= AuthClient(
      _createAuthClientDio(),
      baseUrl: Config.apiBaseUrl,
    );

    return _authClient!;
  }

  static ApiClient get api {
    _apiClient ??= ApiClient(
      _createApiClientDio(),
      baseUrl: Config.apiBaseUrl,
    );

    return _apiClient!;
  }

  static Dio _createAuthClientDio() {
    final dio = Dio(_baseOptions);

    dio.interceptors.addAll(<Interceptor>{
      ErrorHandlerInterceptor(),
      // _createAuthInterceptor(dio),
    });

    return dio;
  }

  static Dio _createApiClientDio() {
    final dio = Dio(_baseOptions);

    dio.interceptors.addAll(<Interceptor>{
      ErrorHandlerInterceptor(),
      _createApiInterceptor(dio),
    });

    return dio;
  }

  static InterceptorsWrapper _createAuthInterceptor(Dio dio) {
    return InterceptorsWrapper(onError: (e, handler) {
      if (e is UnAuthorizedException) {
        _sessionClient.clearTokens();
        AppNavigator.toLoader();
      }

      return handler.next(e);
    });
  }

  // TODO: refactor this method
  static QueuedInterceptorsWrapper _createApiInterceptor(Dio dio) {
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
