import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/workflow_card.dart';

class WorkflowDetailsSection extends StatefulWidget {
  final List<TicketWorkflowEntity> workFlowList;
  final bool initialExpanded;

  const WorkflowDetailsSection({
    super.key,
    required this.workFlowList,
    this.initialExpanded = false,
  });

  @override
  State<WorkflowDetailsSection> createState() => _WorkflowDetailsSectionState();
}

class _WorkflowDetailsSectionState extends State<WorkflowDetailsSection> {
  late bool _showWorkFlowDetails;

  @override
  void initState() {
    super.initState();
    _showWorkFlowDetails = widget.initialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _showWorkFlowDetails
                  ? AppColors.primary.withOpacity(0.05)
                  : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showWorkFlowDetails = !_showWorkFlowDetails;
                });
              },
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'WORK DETAIL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _showWorkFlowDetails
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _showWorkFlowDetails,
            child: Column(
              children: [
                const Divider(
                  thickness: 1,
                  color: AppColors.background,
                ),
                if (widget.workFlowList.isEmpty) ...[
                  const SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Select a Sub Category to view the workflow.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.workFlowList.length,
                    itemBuilder: (context, index) {
                      return WorkflowCard(
                        workflow: widget.workFlowList[index],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
