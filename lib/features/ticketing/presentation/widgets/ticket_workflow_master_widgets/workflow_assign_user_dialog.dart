import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_search_bar.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_workflow_master_widgets/workflow_outlined_button.dart';

import '../../../domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';
import '../ticket_category_master_widgets/build_master_cell.dart';
import '../ticket_category_master_widgets/category_master_table_view_web.dart';

class WorkflowAssignUserDialog {
  static void showAssignUserDialog({
    required BuildContext context,
    required List<WorkflowUserItemEntity> usersList,
    required List<WorkflowGroupItemEntity> groupUserList,
    required Set<int> selectedUserIds,
    required int selectedGroupID,
    required Function(Set<int>, int) onAssignSelectedPressed,
  }) {
    var selectedView = selectedUserIds.isEmpty ? 0 : 1;
    var searchQuery = '';

    const List<String> headers = [
      "Select",
      "User Name",
      "User Code",
      "Department",
    ];

    const List<String> groupTableHeader = [
      "Select",
      "Group Name",
      "User Details",
    ];

    showDialog(
      context: context,
      fullscreenDialog: true,
      barrierDismissible: false,
      builder: (ctx) {
        String getValue(String? value) =>
            (value != null && value.isNotEmpty) ? value : '-';
        final screenSize = MediaQuery.sizeOf(ctx);
        final isMobile = screenSize.width < 600;

        return StatefulBuilder(
          builder: (ctx, setState) {
            List<WorkflowUserItemEntity> filteredUserList = searchQuery.isEmpty
                ? usersList
                : usersList.where((u) {
                    final name = (u.userName ?? '').toLowerCase();
                    final code = (u.userCode ?? '').toLowerCase();
                    final dept = (u.department ?? '').toLowerCase();
                    return name.contains(searchQuery) ||
                        code.contains(searchQuery) ||
                        dept.contains(searchQuery);
                  }).toList();

            List<WorkflowGroupItemEntity> filteredGroupUserList =
                searchQuery.isEmpty
                ? groupUserList
                : groupUserList.where((g) {
                    final name = (g.groupName ?? '').toLowerCase();
                    final users = (g.groupUsers ?? '').toLowerCase();
                    return name.contains(searchQuery) ||
                        users.contains(searchQuery);
                  }).toList();

            return Dialog(
              insetPadding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
              child: SizedBox(
                width: isMobile ? screenSize.width : 800,
                height: screenSize.height * 0.85,
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assign User/Group',
                              style: Theme.of(ctx).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ctx.pop();
                              },
                              color: AppColors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.rose.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.background),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedView = 0;
                                    filteredUserList = usersList;
                                  });
                                },
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'User Details',
                                    style: TextStyle(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 12 : 14,
                                    ),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.person,
                                  color: AppColors.primaryDark,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 8 : 12,
                                    horizontal: isMobile ? 4 : 8,
                                  ),
                                  shape: LinearBorder.bottom(
                                    side: BorderSide(
                                      color: selectedView == 0
                                          ? AppColors.primaryDark
                                          : AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedView = 1;
                                    filteredGroupUserList = groupUserList;
                                  });
                                },
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'User Group Details',
                                    style: TextStyle(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 12 : 14,
                                    ),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.group,
                                  color: AppColors.primaryDark,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 8 : 12,
                                    horizontal: isMobile ? 4 : 8,
                                  ),
                                  shape: LinearBorder.bottom(
                                    side: BorderSide(
                                      color: selectedView == 1
                                          ? AppColors.primaryDark
                                          : AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (isMobile) ...[
                          CustomSearchBar(
                            hintText: 'Search by name, code, department',
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.trim().toLowerCase();
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: WorkflowOutlinedButton(
                              icon: Icons.person_add_alt_1,
                              btnTitle: 'Assign Selected',
                              onPressed: () {
                                ctx.pop();
                                if (selectedView == 0) {
                                  onAssignSelectedPressed(selectedUserIds, 0);
                                } else {
                                  onAssignSelectedPressed({}, selectedGroupID);
                                }
                              },
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: CustomSearchBar(
                                  hintText:
                                      'Search user by name, code, department',
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value.trim().toLowerCase();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              WorkflowOutlinedButton(
                                icon: Icons.person_add_alt_1,
                                btnTitle: 'Assign Selected',
                                onPressed: () {
                                  ctx.pop();
                                  if (selectedView == 0) {
                                    onAssignSelectedPressed(selectedUserIds, 0);
                                  } else {
                                    onAssignSelectedPressed(
                                      {},
                                      selectedGroupID,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),

                        if (selectedView == 0)
                          Expanded(
                            child:
                                CategoryMasterTableViewWeb<
                                  WorkflowUserItemEntity
                                >(
                                  filteredItems: filteredUserList,
                                  headers: headers,
                                  minWidth: 600,
                                  cellBuilder: (item, isCellMobile) {
                                    final isChecked =
                                        item.userID != null &&
                                        selectedUserIds.contains(item.userID);
                                    return [
                                      DataCell(
                                        Center(
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (isSelected) {
                                              setState(() {
                                                if (item.userID != null) {
                                                  if (isSelected == true) {
                                                    selectedUserIds.add(
                                                      item.userID!,
                                                    );
                                                  } else {
                                                    selectedUserIds.remove(
                                                      item.userID!,
                                                    );
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        buildMasterCell(
                                          ctx,
                                          getValue(item.userName),
                                          isCellMobile,
                                        ),
                                      ),
                                      DataCell(
                                        buildMasterCell(
                                          ctx,
                                          getValue(item.userCode),
                                          isCellMobile,
                                        ),
                                      ),
                                      DataCell(
                                        buildMasterCell(
                                          ctx,
                                          getValue(item.department),
                                          isCellMobile,
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                          ),
                        if (selectedView == 1)
                          Expanded(
                            child:
                                CategoryMasterTableViewWeb<
                                  WorkflowGroupItemEntity
                                >(
                                  filteredItems: filteredGroupUserList,
                                  headers: groupTableHeader,
                                  minWidth: 600,
                                  cellBuilder: (item, isCellMobile) {
                                    return [
                                      DataCell(
                                        Center(
                                          child: Radio<int>(
                                            value: item.groupID ?? 0,
                                            groupValue: selectedGroupID,
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  selectedGroupID = value;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        buildMasterCell(
                                          ctx,
                                          getValue(item.groupName),
                                          isCellMobile,
                                        ),
                                      ),
                                      DataCell(
                                        buildMasterCell(
                                          ctx,
                                          getValue(item.groupUsers),
                                          isCellMobile,
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
