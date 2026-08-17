import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class StatusCell extends StatelessWidget {
  final String text;

  const StatusCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: getColor(text),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: getColor(text),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Color getColor(String text) {
    return text.toLowerCase() == "closed"
        ? AppColors.success.withValues(alpha: 0.3)
        : text.toLowerCase() == "parked"
        ? AppColors.rose.withValues(alpha: 0.3)
        : text.toLowerCase() == "hold"
        ? AppColors.amber.withValues(alpha: 0.3)
        : text.toLowerCase() == "expired"
        ? AppColors.slate.withValues(alpha: 0.3)
        : AppColors.primary.withValues(alpha: 0.3);
  }
}
