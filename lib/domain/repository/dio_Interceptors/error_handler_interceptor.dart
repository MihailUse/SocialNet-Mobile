import 'package:dio/dio.dart';
import 'package:social_net/data/models/errors/error_model.dart';
import 'package:social_net/domain/exceptions/bad_request_exception.dart';
import 'package:social_net/domain/exceptions/connection_exception.dart';
import 'package:social_net/domain/exceptions/internal_server_exception.dart';
import 'package:social_net/domain/exceptions/timeout_exception.dart';
import 'package:social_net/domain/exceptions/un_authorized_exception.dart';

class ErrorHandlerInterceptor extends Interceptor {
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            final data = err.response?.data;
            final badRequestException = BadRequestException(
              requestOptions: err.requestOptions,
              errorResponse: data == null ? null : ErrorModel.fromJson(data as Map<String, dynamic>),
            );

            return handler.reject(badRequestException);

          case 401:
          case 403:
            return handler.next(UnAuthorizedException(requestOptions: err.requestOptions));

          case 500:
            return handler.reject(InternalServerException(requestOptions: err.requestOptions));
        }
        break;

      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return handler.reject(TimeoutException(requestOptions: err.requestOptions));

      case DioErrorType.other:
      default:
        return handler.reject(ConnectionException(requestOptions: err.requestOptions));
    }

    return handler.next(err);
  }
}
