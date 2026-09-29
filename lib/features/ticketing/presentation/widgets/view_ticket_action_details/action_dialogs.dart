import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';

class ActionDialogs {
  static void showAlreadyAcceptedDialog({
    required BuildContext context,
    required ViewTicketDetailV6Entity ticket,
    required Function(BuildContext) onAcceptTicketPressed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          width: 400,
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
                      child: Icon(Icons.list, color: AppColors.orange),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Ticket Already Accepted',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontSize: 18, color: AppColors.primary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'The ticket has already been accepted by ${ticket?.acceptedByUser}. Do you still want to accept it?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => onAcceptTicketPressed(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                    ),
                    child: const Text(
                      'Yes, Accept',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
