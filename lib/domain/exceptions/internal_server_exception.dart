import 'package:dio/dio.dart';

class InternalServerException extends DioError {
  InternalServerException({required super.requestOptions});
}
