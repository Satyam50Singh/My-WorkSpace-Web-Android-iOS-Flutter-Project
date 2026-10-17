import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final String dialogHeading;
  final String itemTitle;
  final Function(BuildContext) onDeletePressed;

  const DeleteCategoryDialog({
    super.key,
    required this.dialogHeading,
    required this.itemTitle,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orange.withOpacity(.2),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: AppColors.rose,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    dialogHeading,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Are you sure you want to delete ',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: itemTitle ?? "",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: '. This action cannot be undone.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => onDeletePressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text(
                    'Yes, Delete',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
