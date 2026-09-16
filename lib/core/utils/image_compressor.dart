import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  ImageCompressor._();

  static const maxImageSize = 3 * 1024 * 1024; // 3MB

  static Future<File?> processedMobileImage(PlatformFile file) async {
    try {
      if (file.path == null) {
        return null;
      }
      final originalFile = File(file.path!);
      final size = await originalFile.length();

      debugPrint(
        'Original mobile size: '
        '${(size / 1024 / 1024).toStringAsFixed(2)} MB',
      );

      // Already below 3 MB.
      if (size <= maxImageSize) {
        return originalFile;
      }

      final tempDir = await getTemporaryDirectory();
      final originalName = originalFile.path.split('/').last;
      final baseName = originalName.contains('.')
          ? originalName.substring(0, originalName.lastIndexOf('.'))
          : originalName;

      int quality = 85;
      while (quality >= 30) {
        final targetPath = '${tempDir.path}/compressed_${baseName}_$quality.jpg';

        final compressedXFile = await FlutterImageCompress.compressAndGetFile(
          originalFile.path,
          targetPath,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        if (compressedXFile != null) {
          final compressedFile = File(compressedXFile.path);
          final compressedSize = await compressedFile.length();

          if (compressedSize <= maxImageSize) {
            debugPrint(
              'Compressed mobile size: '
              '${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB '
              'at quality $quality',
            );
            return compressedFile;
          }
        }

        quality -= 10;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return null;
    }
    return null;
  }
}
