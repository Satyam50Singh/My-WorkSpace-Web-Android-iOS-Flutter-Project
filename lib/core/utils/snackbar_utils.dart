import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SnackBarUtils {
  SnackBarUtils._();

  static void showFloatingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        showCloseIcon: true,
        closeIconColor: AppColors.background,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      ),
    );
  }
}
