import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/view_ticket_detail_v6.dart';
import 'label_text.dart';

class RequestorProfileCard extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;

  const RequestorProfileCard({super.key, this.ticketDetails});

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '--';

    final nameParts = name.trim().split(RegExp(r'\s+'));
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
          .toUpperCase();
    }

    return nameParts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: 348,
          ),
          child: Card(
            elevation: 2,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Requestor Profile',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                          SizedBox(height: 2),
                          LabelText(
                            label: 'Reporter Contact Details',
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ],
                  ),

                  Divider(
                    color: AppColors.border,
                    thickness: 0.5,
                    height: 24,
                    indent: 0,
                    endIndent: 0,
                  ),

                  // SizedBox(height: 24,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.slate.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getInitials(
                                ticketDetails?.raisedByUser?.toString(),
                              ),
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${ticketDetails?.raisedByUser}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          LabelText(label: 'Ticket Creator', fontSize: 10),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    color: AppColors.border,
                    thickness: 0.5,
                    height: 24,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: AppColors.slate,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      LabelText(label: 'Email Address'),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ticketDetails?.raisedByEmailID?.toString() ?? '',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.border,
                    thickness: 0.5,
                    height: 24,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: AppColors.slate,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      LabelText(label: 'Contact No.'),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ticketDetails?.raisedByMobileNo?.toString() ?? '',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
