import 'package:json_annotation/json_annotation.dart';

class BooleanConverter implements JsonConverter<int, bool> {
  const BooleanConverter();

  @override
  int fromJson(bool object) => object ? 1 : 0;

  @override
  bool toJson(int json) => json == 1;
}
