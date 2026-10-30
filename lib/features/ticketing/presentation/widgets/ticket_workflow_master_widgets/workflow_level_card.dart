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
  String selectedUsersNames = '', selectedGroupName = '';
  Set<int> selectedUserIds = {};
  int selectedGroupID = -1;
  late final TextEditingController _escalateTimeController;

  @override
  void initState() {
    super.initState();
    _escalateTimeController = TextEditingController();
    loadInitialData();
  }

  @override
  void didUpdateWidget(covariant WorkflowLevelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workflowLevel != widget.workflowLevel ||
        oldWidget.usersList != widget.usersList ||
        oldWidget.groupUserList != widget.groupUserList) {
      loadInitialData();
    }
  }

  @override
  void dispose() {
    _escalateTimeController.dispose();
    super.dispose();
  }

  void loadInitialData() {
    if (widget.workflowLevel.userId != null &&
        widget.workflowLevel.userId != "0" &&
        widget.workflowLevel.userId!.isNotEmpty) {
      selectedUserIds = widget.workflowLevel.userId!
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .where((e) => e != 0)
          .toSet();
    } else {
      selectedUserIds = {};
    }

    if (widget.workflowLevel.groupId != null &&
        widget.workflowLevel.groupId != 0) {
      selectedGroupID = widget.workflowLevel.groupId!;
    } else {
      selectedGroupID = -1;
    }

    final escalateVal =
        widget.workflowLevel.escalateTime != null &&
            widget.workflowLevel.escalateTime != 0
        ? widget.workflowLevel.escalateTime.toString()
        : '';
    if (_escalateTimeController.text != escalateVal) {
      _escalateTimeController.text = escalateVal;
    }

    selectedUsersNames = widget.usersList
        .where((user) => selectedUserIds.contains(user.userID))
        .map((user) => user.userName)
        .join(', ');
    selectedGroupName = widget.groupUserList
        .where((group) => group.groupID == selectedGroupID)
        .map((group) => group.groupName)
        .join(', ');
  }

  void _clearAssignedUsersOrGroups() {
    setState(() {
      selectedUsersNames = '';
      selectedGroupName = '';
      selectedUserIds.clear();
      selectedGroupID = -1;
      widget.workflowLevel.userId = "0";
      widget.workflowLevel.groupId = 0;
    });
  }

  void onTapOfAssignUserBtn() {
    WorkflowAssignUserDialog.showAssignUserDialog(
      context: context,
      usersList: widget.usersList,
      groupUserList: widget.groupUserList,
      selectedUserIds: selectedUserIds,
      selectedGroupID: selectedGroupID,
      onAssignSelectedPressed: (userIDs, groupID) {
        setState(() {
          selectedUserIds = userIDs;
          selectedGroupID = groupID;
          selectedUsersNames = widget.usersList
              .where((user) => selectedUserIds.contains(user.userID))
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
  }

  Widget _buildHeader(
    BuildContext context,
    String label, {
    bool isMobile = false,
  }) {
    return isMobile
        ? Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        : Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
  }

  Widget _buildMobileCheckboxTile({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: AppColors.background),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.drag_indicator, color: AppColors.background),
                const SizedBox(width: 16),
                Text(
                  'Level ${widget.workflowLevel.level}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      widget.onDeletePressed(widget.workflowLevel.level),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.btnBgRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            WorkflowOutlinedButton(
              btnTitle: 'Assign User',
              icon: Icons.person_add_alt_1_outlined,
              onPressed: onTapOfAssignUserBtn,
            ),
            const SizedBox(height: 8),

            // DESKTOP / TABLET VIEW
            if (!isMobile)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: AppColors.background),
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
                            flex: 2,
                            child: _buildHeader(context, 'User/Group'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeader(context, 'Email'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeader(context, 'SMS'),
                          ),
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
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 8),
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
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildHeader(
                                context,
                                selectedUsersNames.isNotEmpty
                                    ? selectedUsersNames
                                    : selectedGroupName,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Checkbox(
                                  value: widget.workflowLevel.isEmail != 0,
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
                                  value: widget.workflowLevel.isSMS != 0,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.workflowLevel.isSMS =
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
                                  value:
                                      widget.workflowLevel.isAppNotification !=
                                      0,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.workflowLevel.isAppNotification =
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
                                  value:
                                      widget.workflowLevel.isWebNotification !=
                                      0,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.workflowLevel.isWebNotification =
                                          (value == true) ? 1 : 0;
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
                                    controller: _escalateTimeController,
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
                                    maxLines: 1,
                                    onChanged: (value) {
                                      widget.workflowLevel.escalateTime =
                                          int.tryParse(value) ?? 0;
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
                                  onPressed: _clearAssignedUsersOrGroups,
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

            // MOBILE VIEW
            if (isMobile)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: AppColors.background),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User/Group: ',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: selectedUsersNames.isNotEmpty
                                ? Text(
                                    selectedUsersNames,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryDark,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : selectedGroupName.isNotEmpty
                                ? Text(
                                    selectedGroupName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryDark,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    'No users/groups assigned',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.textHint,
                                        ),
                                  ),
                          ),
                          if (selectedUsersNames.isNotEmpty ||
                              selectedGroupName.isNotEmpty)
                            InkWell(
                              onTap: _clearAssignedUsersOrGroups,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: AppColors.btnBgRed,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMobileCheckboxTile(
                              label: 'Email',
                              value: widget.workflowLevel.isEmail != 0,
                              onChanged: (val) {
                                setState(() {
                                  widget.workflowLevel.isEmail = (val == true)
                                      ? 1
                                      : 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMobileCheckboxTile(
                              label: 'SMS',
                              value: widget.workflowLevel.isSMS != 0,
                              onChanged: (val) {
                                setState(() {
                                  widget.workflowLevel.isSMS = (val == true)
                                      ? 1
                                      : 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMobileCheckboxTile(
                              label: 'App Notification',
                              value:
                                  widget.workflowLevel.isAppNotification != 0,
                              onChanged: (val) {
                                setState(() {
                                  widget.workflowLevel.isAppNotification =
                                      (val == true) ? 1 : 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMobileCheckboxTile(
                              label: 'Web Notification',
                              value:
                                  widget.workflowLevel.isWebNotification != 0,
                              onChanged: (val) {
                                setState(() {
                                  widget.workflowLevel.isWebNotification =
                                      (val == true) ? 1 : 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Escalation Time (min.)',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _escalateTimeController,
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
                                  widget.workflowLevel.escalateTime =
                                      int.tryParse(value) ?? 0;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
