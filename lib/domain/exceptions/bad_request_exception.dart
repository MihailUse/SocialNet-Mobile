import 'package:dio/dio.dart';
import 'package:social_net/data/models/errors/error_model.dart';

class BadRequestException extends DioError {
  final ErrorModel? errorResponse;

  BadRequestException({required super.requestOptions, this.errorResponse});
}
