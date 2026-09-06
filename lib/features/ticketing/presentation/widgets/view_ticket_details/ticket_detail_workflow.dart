import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

import '../../../domain/entities/ticket_workflow_entity.dart';
import '../../../domain/entities/view_ticket_detail_v6.dart';
import 'manage_ticket_card.dart';

class TicketDetailWorkflow extends StatelessWidget {
  final List<TicketWorkflowEntity>? workFlowDetail;
  final ViewTicketDetailV6Entity? ticketDetails;
  final Function(String remarks, int isReview) onActionSubmit;

  const TicketDetailWorkflow({
    super.key,
    required this.workFlowDetail,
    required this.ticketDetails,
    required this.onActionSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (workFlowDetail == null || workFlowDetail!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workFlowDetail!.length,
          itemBuilder: (context, index) {
            final workflow = workFlowDetail![index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: isMobile ? 36 : 42,
                            height: isMobile ? 36 : 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryDark,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Group: ${workflow.groupName}',
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  workflow.userName ?? '',
                                  style: TextStyle(fontSize: isMobile ? 14 : 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        ),

        if (ticketDetails?.isReopenReviewAllowed == true)
          ManageTicketCard(onActionSubmit: onActionSubmit),

      ],
    );
  }
}
