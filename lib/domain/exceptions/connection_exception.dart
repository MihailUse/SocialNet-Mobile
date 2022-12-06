import 'package:dio/dio.dart';

class ConnectionException extends DioError {
  ConnectionException({required super.requestOptions});
}
