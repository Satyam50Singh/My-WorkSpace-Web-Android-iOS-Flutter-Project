import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class WorkflowOutlinedButton extends StatelessWidget {
  final String btnTitle;
  final IconData? icon;
  final VoidCallback onPressed;

  const WorkflowOutlinedButton({
    super.key,
    required this.btnTitle,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: Text(
        btnTitle,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: icon != null
          ? Icon(icon, size: 16, color: AppColors.textSecondary)
          : null,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
