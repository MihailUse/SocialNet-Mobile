import 'package:dio/dio.dart';
import 'package:social_net/domain/models/error_response_model.dart';

class BadRequestException extends DioError {
  final ErrorResponseModel? errorResponse;

  BadRequestException({required super.requestOptions, this.errorResponse});
}
