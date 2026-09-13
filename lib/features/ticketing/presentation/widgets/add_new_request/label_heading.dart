import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

class LabelHeading extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isRequired;

  const LabelHeading({
    super.key,
    required this.label,
    required this.icon,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
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
