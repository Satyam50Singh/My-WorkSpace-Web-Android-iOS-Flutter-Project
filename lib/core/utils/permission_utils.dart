import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  PermissionUtils._();

  /// Requests camera permission. Returns true if granted.
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          'Camera permission is permanently denied. Please enable it from Settings.',
        );
      }
      return false;
    }

    final result = await Permission.camera.request();

    if (result.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          'Camera permission is permanently denied. Please enable it from Settings.',
        );
      }
      return false;
    }
    return result.isGranted;
  }

  /// Requests gallery/photos permission. Returns true if granted or limited.
  static Future<bool> requestGalleryPermission(BuildContext context) async {
    const permission = Permission.photos;

    final status = await permission.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          'Photo library permission is permanently denied. Please enable it from Settings.',
        );
      }
      return false;
    }

    final result = await permission.request();

    if (result.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          'Photo library permission is permanently denied. Please enable it from Settings.',
        );
      }
      return false;
    }
    return result.isGranted || result.isLimited;
  }

  /// Shows an alert dialog prompting the user to open app settings.
  static void _showSettingsDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}
