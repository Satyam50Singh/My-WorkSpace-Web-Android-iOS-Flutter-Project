import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

import '../../../../../core/routes/app_routes.dart';

class AddNewRequestHeader extends StatelessWidget {
  final VoidCallback onSaveTap;
  bool isSaveEnabled = false;

  AddNewRequestHeader({
    super.key,
    required this.onSaveTap,
    required this.isSaveEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600 && width < 1200;
    final isMobile = width < 600;
    return Container(
      decoration: BoxDecoration(color: AppColors.primaryDark),

      height: 64,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: isMobile ? 4.0 : 16.0,
          right: isMobile ? 4.0 : 8.0,
        ),
        child: Row(
          children: [
            if (isMobile)
              SizedBox(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () {
                    context.go(AppRoutes.myTickets);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            SizedBox(width: 8),

            Text(
              'New Request',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 80,
                minHeight: isMobile ? 36 : 40,
              ),
              child: ElevatedButton(
                onPressed: isSaveEnabled ? onSaveTap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.white.withOpacity(0.12),
                  disabledForegroundColor: AppColors.white.withOpacity(0.38),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            SizedBox(width: 8),
            if (!isMobile)
              SizedBox(
                height: 24,
                width: 24,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
