import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Converts the color to a hex string in the format #RRGGBB
  String toHex() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
