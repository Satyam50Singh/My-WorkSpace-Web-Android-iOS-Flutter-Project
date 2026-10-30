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
        final isMobile = MediaQuery.sizeOf(context).width < 600;
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
              insetPadding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Assign User/Group',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                          ),

                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              context.pop();
                            },
                            color: AppColors.white,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.rose.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(height: 2, color: AppColors.background),
                      SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedView = 0;
                                filteredUserList = usersList;
                              });
                            },
                            label: Text(
                              'User Details',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: isMobile
                                ? null
                                : Icon(
                                    Icons.person,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              shadowColor: AppColors.white,
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
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedView = 1;
                                filteredGroupUserList = groupUserList;
                              });
                            },
                            label: Text(
                              'User Group Details',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            icon: isMobile
                                ? null
                                : Icon(
                                    Icons.group,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              shadowColor: AppColors.white,
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
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(height: 2, color: AppColors.background),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchBar(
                              hintText: 'Search user by name, code, department',
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value.trim().toLowerCase();
                                });
                              },
                            ),
                          ),
                          Spacer(),
                          WorkflowOutlinedButton(
                            icon: Icons.person_add_alt_1,
                            btnTitle: 'Assign Selected',
                            onPressed: () {
                              context.pop();
                              if (selectedView == 0) {
                                onAssignSelectedPressed(selectedUserIds, 0);
                              } else {
                                onAssignSelectedPressed({}, selectedGroupID);
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      if (selectedView == 0)
                        Expanded(
                          child:
                              CategoryMasterTableViewWeb<
                                WorkflowUserItemEntity
                              >(
                                filteredItems: filteredUserList,
                                headers: headers,
                                minWidth: 720,
                                cellBuilder: (item, isMobile) {
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
                                        context,
                                        getValue(item.userName),
                                        isMobile,
                                      ),
                                    ),
                                    DataCell(
                                      buildMasterCell(
                                        context,
                                        getValue(item.userCode),
                                        isMobile,
                                      ),
                                    ),
                                    DataCell(
                                      buildMasterCell(
                                        context,
                                        getValue(item.department),
                                        isMobile,
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
                                minWidth: 720,
                                cellBuilder: (item, isMobile) {
                                  return [
                                    DataCell(
                                      Center(
                                        child: Radio<int>(
                                          value: item.groupID!,
                                          groupValue: selectedGroupID,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedGroupID = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      buildMasterCell(
                                        context,
                                        getValue(item.groupName),
                                        isMobile,
                                      ),
                                    ),
                                    DataCell(
                                      buildMasterCell(
                                        context,
                                        getValue(item.groupUsers),
                                        isMobile,
                                      ),
                                    ),
                                  ];
                                },
                              ),
                        ),
                      SizedBox(height: 16),
                    ],
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
