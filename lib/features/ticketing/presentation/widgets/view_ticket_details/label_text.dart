import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class LabelText extends StatelessWidget {
  final String label;
  final double? fontSize;

  const LabelText({super.key, required this.label, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: AppColors.textSecondary.withOpacity(0.8),
        fontWeight: FontWeight.w900,
        fontSize: fontSize ?? 12,
      ),
      textAlign: TextAlign.start,
      maxLines: 1,
      softWrap: true,
    );
  }
}
