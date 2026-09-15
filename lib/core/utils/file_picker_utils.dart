import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerUtils {
  FilePickerUtils._();

  static const allowedExtensions = ['png', 'jpg', 'jpeg', 'webp'];

  static Future<void> pickFile(
    bool isMobile, {
    required List<String>? allowedExtensions,
    required bool allowMultiple,
    required Function(List<Map<String, File?>>) selectFile,
    required Function(List<Map<String, Uint8List?>>) selectWebFile,
  }) async {
    List<Map<String, File?>> selectedFiles = [];
    List<Map<String, Uint8List?>> selectedWebFiles = [];

    List<PlatformFile> files = await FilePicker.pickFiles(
      type: Platform.isIOS ? FileType.image : FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (files.isEmpty) return;

    if (kIsWeb) {
      for (PlatformFile file in files) {
        final bytes = await file.readAsBytes();
        selectedWebFiles.add({file.name: bytes});
      }
      selectWebFile(selectedWebFiles);
    } else {
      for (PlatformFile file in files) {
        if (file.path != null) {
          final f1 = File(file.path!);
          selectedFiles.add({f1.path: f1});
        }
      }
      selectFile(selectedFiles);
    }
  }
}
