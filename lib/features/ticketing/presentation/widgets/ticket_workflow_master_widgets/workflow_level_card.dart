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

  String selectedUsersNames = '', selectedGroupName = '';
  Set<int> selectedUserIds = {};
  int selectedGroupID = -1;

  @override
  void initState() {
    super.initState();
    selectedUsersNames = widget.usersList
        .where((user) => selectedUserIds.contains(user.userID))
        .map((user) => user.userName)
        .join(', ');
    selectedGroupName = widget.groupUserList
        .where((group) => group.groupID == selectedGroupID)
        .map((group) => group.groupName)
        .join(', ');
    // selectedGroups = widget.groupUserList
    //     .where((group) => group.isSelected)
    //     .map((user) => user.groupName)
    //     .join(', ');
    debugPrint('Selected Users: $selectedUsersNames');
    // debugPrint('Selected Groups: $selectedGroups');
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
                debugPrint(
                  '----------------------------------------------------',
                );
                debugPrint('Assign User button pressed');
                debugPrint('Users: ${widget.usersList.length}');
                debugPrint('Groups: ${widget.groupUserList.length}');
                debugPrint(
                  '----------------------------------------------------',
                );
                WorkflowAssignUserDialog.showAssignUserDialog(
                  context: context,
                  usersList: widget.usersList,
                  groupUserList: widget.groupUserList,
                  selectedUserIds: selectedUserIds,
                  selectedGroupID: selectedGroupID,
                  onAssignSelectedPressed: (userIDs, groupID) {
                    // Handle the assign selected action here
                    setState(() {
                      selectedUserIds = userIDs;
                      selectedGroupID = groupID;
                      selectedUsersNames = widget.usersList
                          .where(
                            (user) => selectedUserIds.contains(user.userID),
                          )
                          .map((user) => user.userName)
                          .join(', ');
                      final selectedUserIDs = selectedUserIds.join(',');
                      selectedGroupName = widget.groupUserList
                          .where((group) => group.groupID == selectedGroupID)
                          .map((group) => group.groupName)
                          .join(', ');
                      widget.workflowLevel.userId = selectedUserIDs.isNotEmpty
                          ? selectedUserIDs
                          : '0';
                      widget.workflowLevel.groupId = selectedGroupID != -1
                          ? selectedGroupID
                          : 0;
                      debugPrint('Selected Users: $selectedUsersNames');
                      debugPrint('Selected Groups: $selectedGroupID');
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
                  if (selectedUsersNames.isEmpty &&
                      selectedGroupName.isEmpty) ...[
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
                  ] else if (selectedUsersNames.isNotEmpty ||
                      selectedGroupName.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          if (selectedUsersNames.isNotEmpty) ...[
                            Expanded(
                              flex: 1,
                              child: _buildHeader(context, selectedUsersNames),
                            ),
                          ] else if (selectedGroupName.isNotEmpty) ...[
                            Expanded(
                              flex: 1,
                              child: _buildHeader(context, selectedGroupName),
                            ),
                          ],
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Checkbox(
                                value: (widget.workflowLevel.isEmail == 0
                                    ? false
                                    : true),
                                onChanged: (value) {
                                  setState(() {
                                    widget.workflowLevel.isEmail =
                                        (value == true) ? 1 : 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Checkbox(
                                value: widget.workflowLevel.isSMS == 0
                                    ? false
                                    : true,
                                onChanged: (value) {
                                  setState(() {
                                    widget.workflowLevel.isSMS = value == true
                                        ? 1
                                        : 0;
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
                                    widget.workflowLevel.isAppNotification == 0
                                    ? false
                                    : true,
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
                                    widget.workflowLevel.isWebNotification == 0
                                    ? false
                                    : true,
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
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    hintText: 'Min',
                                  ),
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.workflowLevel.escalateTime =
                                          int.parse(value);
                                    });
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
                                onPressed: () {
                                  debugPrint(
                                    'selectedUsersNames: $selectedUsersNames & selectedGroups: $selectedGroupName',
                                  );
                                  setState(() {
                                    selectedUsersNames = '';
                                    selectedGroupName = '';
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
