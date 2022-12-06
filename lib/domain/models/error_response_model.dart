import 'package:json_annotation/json_annotation.dart';

part 'error_response_model.g.dart';

@JsonSerializable()
class ErrorResponseModel {
  final String type;
  final String title;
  final int status;
  final String traceId;
  final Map<String, List<String>>? errors;

  ErrorResponseModel({
    required this.type,
    required this.title,
    required this.status,
    required this.traceId,
    this.errors,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => _$ErrorResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseModelToJson(this);
}
