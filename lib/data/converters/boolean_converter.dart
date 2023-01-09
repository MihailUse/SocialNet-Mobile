import 'package:json_annotation/json_annotation.dart';

class BooleanConverter implements JsonConverter<num, bool> {
  const BooleanConverter();

  @override
  num fromJson(bool object) => object ? 1 : 0;

  @override
  bool toJson(num json) => json == 1;
}
