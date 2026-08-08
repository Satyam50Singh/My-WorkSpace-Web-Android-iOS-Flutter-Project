import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CompanyLogoWebCard extends StatelessWidget {
  const CompanyLogoWebCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_mall, size: 48, color: AppColors.primary),
          Text(
            'Work Sphere',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w900,
              fontSize: 36,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Streamline mall operations \n— tasks, tickets, and checklists in one place',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
