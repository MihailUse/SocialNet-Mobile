import 'package:dio/dio.dart';

class TimeoutException extends DioError {
  TimeoutException({required super.requestOptions});
}