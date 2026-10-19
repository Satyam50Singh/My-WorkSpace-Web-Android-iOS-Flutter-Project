import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';

import '../../../../../core/theme/app_colors.dart';

class WorkflowMasterListViewMobile extends StatelessWidget {
  final List<TicketWorkflowMasterEntity> workflowList;
  final Function(String, TicketWorkflowMasterEntity) performEditDeleteOperation;

  const WorkflowMasterListViewMobile({
    super.key,
    required this.workflowList,
    required this.performEditDeleteOperation,
  });

  String getValue(String? value) =>
      (value != null && value.isNotEmpty) ? value : '-';

  Widget _buildWorkflowField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemCount: workflowList.length,
      itemBuilder: (context, index) {
        final item = workflowList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                getValue(item.workflowName),
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                      letterSpacing: .6,
                                    ),
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      performEditDeleteOperation("Edit", item);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      performEditDeleteOperation(
                                        "Delete",
                                        item,
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.btnBgRed,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildWorkflowField(
                                context,
                                'CATEGORY',
                                getValue(item.category),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildWorkflowField(
                                context,
                                'SUBCATEGORY',
                                getValue(item.subCategory),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(children: []),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
