import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ManageActionTicketCard extends StatelessWidget {
  final bool isAcceptAllowed;
  final bool isActionAllowed;
  final Function() onAcceptTicket;
  final Function() onTransferTicket;
  final Function() onInProgressTicket;
  final Function() onHoldTicket;
  final Function() onCloseTicket;

  const ManageActionTicketCard({
    super.key,
    required this.isAcceptAllowed,
    required this.isActionAllowed,
    required this.onAcceptTicket,
    required this.onTransferTicket,
    required this.onInProgressTicket,
    required this.onHoldTicket,
    required this.onCloseTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primaryDark,
                  ),
                  SizedBox(width: 8),
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
              SizedBox(height: 4),
              Divider(color: Colors.grey.shade200, thickness: 1),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAcceptAllowed)
                    ElevatedButton.icon(
                      icon: Icon(Icons.check_circle_outline),
                      onPressed: onAcceptTicket,
                      label: Text(
                        'Accept Ticket',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.white, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.account_tree),
                    onPressed: onTransferTicket,
                    label: Text(
                      'Transfer',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  if (isActionAllowed) ...[
                    ElevatedButton.icon(
                      icon: Icon(Icons.play_circle_outline),
                      onPressed: onInProgressTicket,
                      label: Text(
                        'In Progress',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.white, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.pause_circle_outline),
                      onPressed: onHoldTicket,
                      label: Text(
                        'Hold',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.white, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.check_circle_outline),
                      onPressed: onCloseTicket,
                      label: Text(
                        'Close',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.white, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
