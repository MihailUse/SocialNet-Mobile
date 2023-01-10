import 'package:flutter/foundation.dart';

extension StringExtension on String {
  void console() {
    if (kDebugMode) {
      print(this);
    }
  }
}

extension Iso8061SerializableDateTime on DateTime {
  String toJson() => toIso8601String();
}
