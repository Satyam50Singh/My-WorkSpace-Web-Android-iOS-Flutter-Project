import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/ticket_status_utils.dart';

class ViewTicketDetailHeader extends StatelessWidget {
  final String ticketId;
  final String? ticketStatus;

  const ViewTicketDetailHeader({
    super.key,
    required this.ticketId,
    this.ticketStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = ticketStatus ?? 'Open';
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
            Expanded(
              child: Column(
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
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Ticket ID: $ticketId',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: TicketStatusUtils.getStatusBgColor(statusText),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: TicketStatusUtils.getStatusBorderColor(statusText),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4,
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: TicketStatusUtils.getStatusTextColor(statusText),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
