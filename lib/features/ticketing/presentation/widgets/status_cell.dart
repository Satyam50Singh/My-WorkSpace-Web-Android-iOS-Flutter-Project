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
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text),
    );
  }
}
