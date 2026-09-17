import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'image_compressor.dart';

class FilePickerUtils {
  FilePickerUtils._();

  static const allowedExtensions = ['png', 'jpg', 'jpeg', 'webp'];
  static const maxImageSize = 3 * 1024 * 1024; // 3MB

  static Future<void> pickFile(
    bool isMobile, {
    required List<String>? allowedExtensions,
    required bool allowMultiple,
    required Function(List<Map<String, File?>>) selectFile,
    required Function(List<Map<String, Uint8List?>>) selectWebFile,
  }) async {
    List<Map<String, File?>> selectedFiles = [];
    List<Map<String, Uint8List?>> selectedWebFiles = [];

    debugPrint('Platform: ${isMobile ? 'Mobile' : 'Web'}');

    final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    List<PlatformFile> files = await FilePicker.pickFiles(
      type: isIOS ? FileType.image : FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (files.isEmpty) return;

    if (kIsWeb) {
      for (PlatformFile file in files) {
        final Uint8List bytes = await file.readAsBytes();
        final compressedBytes = await ImageCompressor.processWebImage(
          file.name,
          bytes,
        );
        if (compressedBytes != null) {
          selectedWebFiles.add({file.name: compressedBytes});
        } else {
          debugPrint('File not processed: ${file.name}');
        }
      }
      selectWebFile(selectedWebFiles);
    } else {
      for (PlatformFile file in files) {
        if (file.path != null) {
          final processedFile = await ImageCompressor.processedMobileImage(
            file,
          );
          if (processedFile != null) {
            selectedFiles.add({processedFile.path: processedFile});
          } else {
            debugPrint('File not processed: ${file.name}');
          }
        }
      }
      selectFile(selectedFiles);
    }
  }
}
