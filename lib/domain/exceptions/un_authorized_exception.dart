import 'package:dio/dio.dart';

class UnAuthorizedException extends DioError {
  UnAuthorizedException({required super.requestOptions});
}
