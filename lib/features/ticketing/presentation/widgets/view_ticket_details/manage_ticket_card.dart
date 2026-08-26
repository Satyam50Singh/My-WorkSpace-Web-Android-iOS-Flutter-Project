import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/utils/custom_dialog_utils.dart';

import '../../../../../core/theme/app_colors.dart';

class ManageTicketCard extends StatelessWidget {
  const ManageTicketCard({super.key});

  void _submitReviewOrReOpen(String remarks) {

  }

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
                    Icons.monitor_heart_outlined,
                    color: AppColors.primaryDark,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Manage Ticket',
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
                  ElevatedButton.icon(
                    icon: Icon(Icons.play_circle_outline_outlined),
                    onPressed: () {
                      CustomDialogUtils.showReopenTicketDialog(
                        context,
                        "Reopen Ticket",
                        Icons.play_circle_outline_outlined,
                        'Submit',
                        'Enter reopen remarks...',
                        (remarks) {
                          _submitReviewOrReOpen(remarks);
                        },
                      );
                    },
                    label: Text('Reopen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.check_circle_outline_outlined),
                    onPressed: () {
                      CustomDialogUtils.showReopenTicketDialog(
                        context,
                        "Review Ticket",
                        Icons.check_circle_outline_outlined,
                        'Submit',
                        'Enter review remarks...',
                        (remarks) {
                          _submitReviewOrReOpen(remarks);
                        },
                      );
                    },
                    label: Text('Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
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
