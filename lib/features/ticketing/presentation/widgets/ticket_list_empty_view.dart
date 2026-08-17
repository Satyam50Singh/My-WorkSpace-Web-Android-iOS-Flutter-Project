import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TicketListEmptyView extends StatelessWidget {
  const TicketListEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info, color: AppColors.slate, size: 48),
            Text(
              'No tickets found matching current filters',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
            ),
            Text(
              'Try resetting filters or changing tabs',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.slate,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
