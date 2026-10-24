import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/workflow_level_model.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_workflow_master_widgets/workflow_outlined_button.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';
import 'workflow_assign_user_dialog.dart';

class WorkflowLevelCard extends StatefulWidget {
  final WorkflowLevelModel workflowLevel;
  final List<WorkflowUserItemEntity> usersList;
  final List<WorkflowGroupItemEntity> groupUserList;
  final Function(int) onDeletePressed;

  const WorkflowLevelCard({
    super.key,
    required this.workflowLevel,
    required this.usersList,
    required this.groupUserList,
    required this.onDeletePressed,
  });

  @override
  State<WorkflowLevelCard> createState() => _WorkflowLevelCardState();
}

class _WorkflowLevelCardState extends State<WorkflowLevelCard> {
  Set<int> _parseIds(String? idString) {
    if (idString == null || idString.isEmpty || idString == "0") return {};
    return idString
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .where((id) => id > 0)
        .toSet();
  }

  Set<int> get _selectedUserIds => _parseIds(widget.workflowLevel.userId);
  Set<int> get _selectedGroupIds {
    final gId = widget.workflowLevel.groupId;
    if (gId != null && gId > 0) {
      return <int>{gId};
    }
    return <int>{};
  }

  String get _selectedUsersNames {
    final userIds = _selectedUserIds;
    if (userIds.isEmpty) return '';
    return widget.usersList
        .where((user) => user.userID != null && userIds.contains(user.userID))
        .map((user) => user.userName ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');
  }

  String get _selectedGroups {
    final gId = widget.workflowLevel.groupId;
    if (gId == null || gId <= 0) return '';
    return widget.groupUserList
        .where((group) => group.groupID == gId)
        .map((group) => group.groupName ?? '')
        .where((name) => name.isNotEmpty)
        .join('');
  }

  String get _assignedDisplay {
    final users = _selectedUsersNames;
    final groups = _selectedGroups;
    if (users.isNotEmpty) {
      return users;
    } else if (groups.isNotEmpty) {
      return groups;
    }
    return '';
  }

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

  Widget _buildCellText(BuildContext context, String label) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignedDisplay = _assignedDisplay;
    debugPrint('Level ${widget.workflowLevel.level} Assigned: $assignedDisplay');
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
                  'Level ${widget.workflowLevel.level}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacer(),
                IconButton(
                  onPressed: widget.onDeletePressed(widget.workflowLevel.level),
                  icon: Icon(Icons.delete_outline, color: AppColors.btnBgRed),
                ),
              ],
            ),
            SizedBox(height: 8),
            WorkflowOutlinedButton(
              btnTitle: 'Assign User',
              icon: Icons.person_add_alt_1_outlined,
              onPressed: () {
                WorkflowAssignUserDialog.showAssignUserDialog(
                  context: context,
                  usersList: widget.usersList,
                  groupUserList: widget.groupUserList,
                  initialSelectedUserIds: _selectedUserIds,
                  initialSelectedGroupIds: _selectedGroupIds,
                  onAssignSelectedPressed: (selectedUserIds, selectedGroupIds) {
                    setState(() {
                      if (selectedUserIds.isNotEmpty) {
                        widget.workflowLevel.userId = selectedUserIds.join(',');
                        widget.workflowLevel.groupId = 0;
                      } else if (selectedGroupIds.isNotEmpty) {
                        widget.workflowLevel.userId = "0";
                        widget.workflowLevel.groupId = selectedGroupIds.first;
                      } else {
                        widget.workflowLevel.userId = "0";
                        widget.workflowLevel.groupId = 0;
                      }
                      debugPrint('Updated Level ${widget.workflowLevel.level} userIds: ${widget.workflowLevel.userId}, groupId: ${widget.workflowLevel.groupId}');
                    });
                  },
                );
              },
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
                          child: _buildHeader(context, 'Email'),
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
                          flex: 1,
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
                  if (assignedDisplay.isEmpty) ...[
                    SizedBox(
                      height: 64,
                      child: Center(
                        child: Text(
                          'No users assigned. Click "Assign User" to add one.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textHint,
                              ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildCellText(context, assignedDisplay),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Checkbox(
                                value: widget.workflowLevel.isEmail == 1,
                                onChanged: (value) {
                                  setState(() {
                                    widget.workflowLevel.isEmail =
                                        value == true ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Checkbox(
                                value: widget.workflowLevel.isSMS == 1,
                                onChanged: (value) {
                                  setState(() {
                                    widget.workflowLevel.isSMS =
                                        value == true ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Checkbox(
                                value:
                                    widget.workflowLevel.isAppNotification == 1,
                                onChanged: (value) {
                                  setState(() {
                                    widget.workflowLevel.isAppNotification =
                                        value == true ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Checkbox(
                                value:
                                    widget.workflowLevel.isWebNotification == 1,
                                onChanged: (value) {
                                  setState(() {
                                    widget.workflowLevel.isWebNotification =
                                        value == true ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: SizedBox(
                                height: 42,
                                width: 80,
                                child: TextField(
                                  controller: TextEditingController(
                                    text: widget.workflowLevel.escalateTime
                                            ?.toString() ??
                                        '',
                                  )..selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: widget.workflowLevel
                                                .escalateTime
                                                ?.toString()
                                                .length ??
                                            0,
                                      ),
                                    ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    hintText: 'Min',
                                  ),
                                  onChanged: (value) {
                                    widget.workflowLevel.escalateTime =
                                        int.tryParse(value.trim());
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_sweep_outlined,
                                  color: AppColors.btnBgRed,
                                ),
                                tooltip: 'Remove Assigned User/Group',
                                onPressed: () {
                                  setState(() {
                                    widget.workflowLevel.userId = "0";
                                    widget.workflowLevel.groupId = 0;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
