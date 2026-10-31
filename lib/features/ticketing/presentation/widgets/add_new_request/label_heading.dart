import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

class LabelHeading extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isRequired;
  final Color iconColor;
  final bool isUppercase;

  const LabelHeading({
    super.key,
    required this.label,
    required this.icon,
    this.isRequired = true,
    this.iconColor = AppColors.primary,
    this.isUppercase = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          isUppercase ? label.toUpperCase() : label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.rose,
            ),
          ),
        ],
      ],
    );
  }
}
