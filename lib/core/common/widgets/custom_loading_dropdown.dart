import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomLoadingDropdown extends StatelessWidget {
  final String label;

  const CustomLoadingDropdown({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const CircularProgressIndicator(
              color: AppColors.textSecondary,
              constraints: BoxConstraints(minHeight: 16, minWidth: 16),
              strokeWidth: 2,
            ),
            SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
