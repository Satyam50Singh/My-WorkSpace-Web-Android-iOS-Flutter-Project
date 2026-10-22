import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/workflow_level_model.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_workflow_master_widgets/workflow_outlined_button.dart';

import '../../../../../core/theme/app_colors.dart';

class WorkflowLevelCard extends StatelessWidget {
  final WorkflowLevelModel workflowLevel;
  final Function(int) onDeletePressed;

  const WorkflowLevelCard({
    super.key,
    required this.workflowLevel,
    required this.onDeletePressed,
  });

  Widget _buildHeader(BuildContext context, String label) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: AppColors.background),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.drag_indicator, color: AppColors.background),
                SizedBox(width: 16),
                Text(
                  'Level ${workflowLevel.level}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacer(),
                IconButton(
                  onPressed: onDeletePressed(workflowLevel.level),
                  icon: Icon(Icons.delete_outline, color: AppColors.btnBgRed),
                ),
              ],
            ),
            SizedBox(height: 8),
            WorkflowOutlinedButton(
              btnTitle: 'Assign User',
              icon: Icons.person_add_alt_1_outlined,
              onPressed: () {},
            ),
            SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: AppColors.background),
              ),

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildHeader(context, 'User/Group'),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildHeader(context, 'Email	'),
                        ),
                        Expanded(flex: 1, child: _buildHeader(context, 'SMS')),
                        Expanded(
                          flex: 1,
                          child: _buildHeader(context, 'App Notification'),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildHeader(context, 'Web Notification'),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildHeader(
                            context,
                            'Escalation Time (min.)',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildHeader(context, 'Action'),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: AppColors.border),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 64,
                    child: Center(
                      child: Text(
                        'No users assigned. Click "Assign User" to add one.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
