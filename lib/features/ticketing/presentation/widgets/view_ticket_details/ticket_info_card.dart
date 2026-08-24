import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/label_text.dart';

import '../../../../../core/common/widgets/custom_chip.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/view_ticket_detail_v6.dart';

class TicketInfoCard extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;

  const TicketInfoCard({super.key, this.ticketDetails});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: isMobile ? 16.0 : 8.0,
        bottom: 16.0,
      ),
      child: Card(
        elevation: 2,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.confirmation_num_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket Information',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        LabelText(
                          label: 'Basic Details & Status',
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.slate.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Level ${ticketDetails?.level}/${ticketDetails?.level}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.slate,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Ticket No.'),
                        SizedBox(height: 4),
                        Text(
                          'TKT${ticketDetails!.ticketID}',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Ticket Type.'),
                        SizedBox(height: 4),
                        Text(
                          ticketDetails!.ticketType.toString(),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 16,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'DESCRIPTION'),
                        SizedBox(height: 4),
                        Text(
                          ticketDetails!.ticketMessage.toString(),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 16,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'REPORTED DATE'),
                        SizedBox(height: 4),
                        Text(
                          ticketDetails!.ticketDate!.toString(),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 16,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Ticket Status'),
                        SizedBox(height: 4),
                        CustomChip(
                          status: ticketDetails!.ticketStatus.toString(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Action Status'),
                        SizedBox(height: 4),
                        CustomChip(
                          status: ticketDetails!.ticketActionStatus.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 16,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Closure Remarks'),
                        SizedBox(height: 4),
                        Text(
                          ticketDetails!.closureRemarks!.toString().isEmpty
                              ? 'No remarks'
                              : ticketDetails!.closureRemarks!.toString(),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
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
