import 'package:flutter/foundation.dart';

class AppMultipartFile {
  final String name;
  final Uint8List? bytes;
  final String? path;

  AppMultipartFile({
    required this.name,
    this.bytes,
    this.path,
  });
}
