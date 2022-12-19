import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  final String type;
  final String title;
  final int status;
  final String traceId;
  final Map<String, List<String>>? errors;

  ErrorModel({
    required this.type,
    required this.title,
    required this.status,
    required this.traceId,
    this.errors,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
