import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';

class ViewTicketDetailHeader extends StatelessWidget {
  final String ticketId;
  final String? ticketStatus;

  const ViewTicketDetailHeader({super.key, required this.ticketId, this.ticketStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.slate.withOpacity(0.2), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.slate.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                context.go(AppRoutes.myTickets);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.slate,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View Ticket Details',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Ticket ID: ${ticketId}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Chip(
              label: Text(
                ticketStatus ?? 'Open',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: getColor(ticketStatus ?? 'Open'),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              visualDensity: VisualDensity.compact,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
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
