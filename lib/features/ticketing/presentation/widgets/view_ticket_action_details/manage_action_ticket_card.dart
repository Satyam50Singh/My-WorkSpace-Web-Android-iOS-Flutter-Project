import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';

class ManageActionTicketCard extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;
  final Function() onAcceptTicket;
  final Function() onTransferTicket;
  final Function() onInProgressTicket;
  final Function() onHoldTicket;
  final Function() onCloseTicket;

  const ManageActionTicketCard({
    super.key,
    this.ticketDetails,
    required this.onAcceptTicket,
    required this.onTransferTicket,
    required this.onInProgressTicket,
    required this.onHoldTicket,
    required this.onCloseTicket,
  });

  @override
  Widget build(BuildContext context) {
    final isAcceptAllowed = ticketDetails?.isAcceptAllowed ?? false;
    final isActionAllowed = ticketDetails?.isActionAllowed ?? false;
    final isAcceptedByAnotherUser =
        ticketDetails?.isAcceptedByAnotherUser ?? true;

    final status =
        ticketDetails?.ticketActionStatus?.trim().toLowerCase() ?? '';
    debugPrint('Status: $status');
    final isHoldStatus = status.contains('hold');
    final isInProgressStatus = status.contains('progress');

    final List<Widget> buttons = [];

    if (isAcceptAllowed) {
      buttons.add(
        ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: onAcceptTicket,
          label: Text(
            'Accept Ticket',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    if ((!isAcceptedByAnotherUser || isActionAllowed) && !isHoldStatus) {
      buttons.add(
        ElevatedButton.icon(
          icon: const Icon(Icons.account_tree),
          onPressed: onTransferTicket,
          label: Text(
            'Transfer',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.btnBgRed,
            foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    if (isActionAllowed) {
      if (!isInProgressStatus && !isHoldStatus) {
        buttons.add(
          ElevatedButton.icon(
            icon: const Icon(Icons.play_circle_outline),
            onPressed: onInProgressTicket,
            label: Text(
              'In Progress',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      }

      if (!isHoldStatus) {
        buttons.add(
          ElevatedButton.icon(
            icon: const Icon(Icons.pause_circle_outline),
            onPressed: onHoldTicket,
            label: Text(
              'Hold',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amberDark,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      }

      buttons.add(
        ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: onCloseTicket,
          label: Text(
            'Close',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.btnBgGreen,
            foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Take Action',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Divider(color: Colors.grey.shade200, thickness: 1),
              const SizedBox(height: 16),
              Wrap(spacing: 16, runSpacing: 12, children: buttons),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
