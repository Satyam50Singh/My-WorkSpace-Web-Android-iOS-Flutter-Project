import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticket_workflow_master_bloc/ticket_workflow_master_bloc.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/loader_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../widgets/ticket_category_master_widgets/build_master_cell.dart';
import '../widgets/ticket_category_master_widgets/category_action_button.dart';
import '../widgets/ticket_category_master_widgets/category_action_dialog_utils.dart';
import '../widgets/ticket_category_master_widgets/category_master_table_view_web.dart';
import '../widgets/ticket_workflow_master_widgets/workflow_master_list_view_mobile.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketWorkflowMasterPage extends StatefulWidget {
  const TicketWorkflowMasterPage({super.key});

  @override
  State<TicketWorkflowMasterPage> createState() =>
      _TicketWorkflowMasterPageState();
}

class _TicketWorkflowMasterPageState extends State<TicketWorkflowMasterPage> {
  List<TicketWorkflowMasterEntity> workflowList = [];
  List<TicketWorkflowMasterEntity> filteredWorkflows = [];

  int totalPages = 0;
  int currentPage = 0;

  Timer? _debounceTimer;

  static const List<String> _headers = [
    "Workflow Description",
    "Category",
    "Sub Category",
    "No of Level",
    "Action Status",
  ];

  late final TextEditingController _searchController;

  @override
  void initState() {
    _apiCallForFetchingTicketWorkflow();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _debounceTimer?.cancel();
    _searchController.dispose();
  }

  void _apiCallForFetchingTicketWorkflow() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      if (companyId != null) {
        context.read<TicketWorkflowMasterBloc>().add(
          TicketWorkflowListRequested(companyID: companyId),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
      },
      child: Column(
        children: [
          if (!isMobile) ...[
            TicketingMyRequestWebAppBar(
              title: 'Ticket Workflow',
              showAddNewBtn: true,
              showExportToExcelBtn: false,
              addNewBtnTitleText: 'Add New Workflow',
              onTapExportToExcel: () {},
              onTapAddNewRequest: () => goToAddNewWorkflowPage(null),
            ),
            SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearchBar(
                      searchController: _searchController,
                      hintText: 'Search Here ...',
                      onChanged: _searchOperation,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (isMobile) ...[
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      searchController: _searchController,
                      hintText: 'Search...',
                      onChanged: _searchOperation,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: () => goToAddNewWorkflowPage(null),
                    icon: const Icon(Icons.add, color: AppColors.white),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          Expanded(
            child:
                BlocConsumer<
                  TicketWorkflowMasterBloc,
                  TicketWorkflowMasterState
                >(
                  listener: (context, state) {
                    debugPrint('state: $state');
                    if (state is TicketWorkflowMasterLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is TicketWorkflowMasterFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is TicketWorkflowMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        _searchController.clear();
                        workflowList = state.ticketWorkflowList!;
                        if (kIsWeb) {
                          filteredWorkflows = workflowList;
                        } else {
                          if (workflowList.length < 10) {
                            filteredWorkflows = workflowList;
                          } else {
                            filteredWorkflows = workflowList.sublist(0, 10);
                          }
                        }
                        totalPages = (workflowList.length / 10).ceil();
                        currentPage = 1;
                      });
                    } else if (state is DeleteWorkflowMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        'Workflow deleted successfully',
                      );
                      _apiCallForFetchingTicketWorkflow();
                    }
                  },
                  builder: (context, state) {
                    if (!isMobile) {
                      return CategoryMasterTableViewWeb<
                        TicketWorkflowMasterEntity
                      >(
                        filteredItems: filteredWorkflows,
                        headers: _headers,
                        minWidth: 720,
                        cellBuilder: (item, isMobile) =>
                            _buildWorkflowCell(item, isMobile),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: goToPrevious,
                                  icon: Icon(Icons.chevron_left_rounded),
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(24, 24),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '$currentPage of $totalPages',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: goToNext,
                                  icon: Icon(Icons.chevron_right_rounded),
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(24, 24),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: WorkflowMasterListViewMobile(
                            workflowList: filteredWorkflows,
                            performEditDeleteOperation:
                                _performEditDeleteOperation,
                          ),
                        ),
                      ],
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void goToPrevious() {
    if (currentPage != 1 && currentPage <= totalPages) {
      debugPrint('currentPage: $currentPage && totalPages: $totalPages');
      setState(() {
        currentPage--;
        final startIndex = (currentPage - 1) * 10;
        final endIndex = startIndex + 10;
        debugPrint('startIndex: $startIndex && endIndex: $endIndex');
        filteredWorkflows = workflowList.sublist(startIndex, endIndex);
      });
    }
  }

  void goToNext() {
    if (currentPage != totalPages && currentPage <= totalPages) {
      debugPrint('currentPage: $currentPage && totalPages: $totalPages');
      setState(() {
        currentPage++;
        final startIndex = (currentPage - 1) * 10;
        var endIndex = startIndex + 10;
        if (endIndex > workflowList.length) {
          endIndex = workflowList.length;
        }
        debugPrint('startIndex: $startIndex && endIndex: $endIndex');
        filteredWorkflows = workflowList.sublist(startIndex, endIndex);
      });
    } else {
      debugPrint('No more pages to load');
    }
  }

  List<DataCell> _buildWorkflowCell(
    TicketWorkflowMasterEntity item,
    bool isMobile,
  ) {
    String getValue(String? value) =>
        (value != null && value.isNotEmpty) ? value : '-';

    return [
      DataCell(buildMasterCell(context, getValue(item.workflowName), isMobile)),
      DataCell(buildMasterCell(context, getValue(item.category), isMobile)),
      DataCell(buildMasterCell(context, getValue(item.subCategory), isMobile)),
      DataCell(buildMasterCell(context, item.noOfLevels.toString(), isMobile)),
      DataCell(
        Row(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            CategoryActionButton(
              btnTitle: 'Edit',
              btnColor: AppColors.primary,
              btnTextColor: AppColors.white,
              icon: Icons.edit,
              onPressed: () {
                _performEditDeleteOperation("Edit", item);
              },
            ),
            SizedBox(width: 8),
            CategoryActionButton(
              btnTitle: 'Delete',
              btnColor: AppColors.rose,
              btnTextColor: AppColors.white,
              icon: Icons.delete,
              onPressed: () {
                _performEditDeleteOperation("Delete", item);
              },
            ),
          ],
        ),
      ),
    ];
  }

  void _performEditDeleteOperation(
    String action,
    TicketWorkflowMasterEntity item,
  ) {
    if (action == 'Edit') {
      goToAddNewWorkflowPage(item);
    } else if (action == 'Delete') {
      CategoryActionDialogUtils.showDeleteCategoryDialog(
        context: context,
        dialogHeading: 'Delete Workflow',
        itemTitle: item.workflowName ?? "",
        onPressed: (dialogCtx) {
          Navigator.of(dialogCtx).pop();
          _apiCallForDeleteWorkflow(item);
        },
      );
    }
  }

  void _searchOperation(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    if (value.isNotEmpty) {
      final searchText = value.toLowerCase();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          filteredWorkflows = workflowList.where((workflow) {
            final category = workflow.category?.toLowerCase() ?? "";
            final subCategory = workflow.subCategory?.toLowerCase() ?? "";
            final workflowName = workflow.workflowName?.toLowerCase() ?? "";
            final noOfLevels = workflow.noOfLevels?.toString() ?? "";

            return (category.contains(searchText) ||
                subCategory.contains(searchText) ||
                workflowName.contains(searchText) ||
                noOfLevels.contains(searchText));
          }).toList();
          totalPages = (filteredWorkflows.length / 10).ceil();
          currentPage = 1;
        });
        debugPrint(
          'filteredWorkflows: ${filteredWorkflows.map((e) => {'workflowId': e.workflowID, 'workflowName': e.workflowName, 'categoryId': e.categoryID, 'categoryName': e.category, 'subCategoryId': e.subCategoryID, 'subCategoryName': e.subCategory}).toList()}',
        );
      });
    } else if (value.isEmpty) {
      setState(() {
        filteredWorkflows = workflowList;
        totalPages = (filteredWorkflows.length / 10).ceil();
        currentPage = 1;
      });
    }
  }

  void _apiCallForDeleteWorkflow(TicketWorkflowMasterEntity item) {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;
      final loggedInUserID = employee.userID?.toString() ?? "0";
      final action = 'D';
      final categoryID = item.categoryID ?? 0;
      final subCategoryID = item.subCategoryID ?? 0;
      final workflowId = item.workflowID ?? 0;
      final workflowName = item.workflowName ?? "";
      final workflowDetails = [];
      debugPrint(
        'companyID: $companyID, loggedInUserID: $loggedInUserID, action: $action, categoryID: $categoryID, subCategoryID: $subCategoryID, workflowId: $workflowId, workflowName: $workflowName',
      );
      final payload = InsertUpdateWorkflowRequestModel(
        categoryId: categoryID,
        subCategoryId: subCategoryID,
        workflowId: workflowId,
        workflowName: workflowName,
        companyId: companyID,
        loggedInUserId: loggedInUserID,
        action: action,
        workflowDetails: workflowDetails,
      );
      context.read<TicketWorkflowMasterBloc>().add(
        DeleteWorkflowListRequested(payload: payload),
      );
    }
  }

  void goToAddNewWorkflowPage(TicketWorkflowMasterEntity? item) async {
    final result = await context.pushNamed<bool>(
      'add-new-workflow',
      extra: item,
    );
    if (result == true) {
      debugPrint('navigated with true');
      _searchController.clear();
      _apiCallForFetchingTicketWorkflow();
    }
  }
}
