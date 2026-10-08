import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CategoryActionButton extends StatelessWidget {
  final String btnTitle;
  final Color btnColor;
  final Color btnTextColor;
  final IconData icon;
  final void Function() onPressed;

  const CategoryActionButton({
    super.key,
    required this.btnTitle,
    required this.btnColor,
    required this.btnTextColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return isMobile
        ? IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: btnColor, size: 16),
          )
        : OutlinedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            label: Text(
              btnTitle,
              style: TextStyle(color: btnColor, fontSize: 13),
            ),
            onPressed: onPressed,
            icon: Icon(icon, color: btnColor, size: 16),
          );
  }
}
