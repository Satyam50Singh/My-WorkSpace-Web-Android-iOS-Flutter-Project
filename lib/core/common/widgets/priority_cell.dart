import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PriorityCell extends StatelessWidget {
  final String priorityText;

  const PriorityCell({super.key, required this.priorityText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: priorityText == 'Major'
              ? AppColors.btnBgRed.withValues(alpha: 0.1)
              : AppColors.amber.withValues(alpha: 0.1),
          border: Border.all(
            color: priorityText == 'Major'
                ? AppColors.btnBgRed
                : AppColors.amber,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: priorityText == 'Major'
                    ? AppColors.btnBgRed
                    : AppColors.orange,
                size: 8,
              ),
              SizedBox(width: 4),
              Text(
                priorityText.isNotEmpty ? priorityText : 'Minor',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 12,
                  color: priorityText == 'Major'
                      ? AppColors.btnBgRed
                      : AppColors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
