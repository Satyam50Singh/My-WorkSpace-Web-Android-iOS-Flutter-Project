import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticket_workflow_master_bloc/ticket_workflow_master_bloc.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/loader_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../widgets/ticket_category_master_widgets/build_master_cell.dart';
import '../widgets/ticket_category_master_widgets/category_action_button.dart';
import '../widgets/ticket_category_master_widgets/category_master_table_view_web.dart';
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

  static const List<String> _headers = [
    "Workflow Description",
    "Category",
    "Sub Category",
    "No of Level",
    "Action Status",
  ];

  @override
  void initState() {
    _apiCallForFetchingTicketWorkflow();
    super.initState();
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
              onTapAddNewRequest: () {},
            ),
            SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: isMobile ? 408 : 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearchBar(
                      hintText: 'Search Here ...',
                      onChanged: (value) {},
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
                      hintText: 'Search...',
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: AppColors.white),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.download_sharp,
                      color: AppColors.primaryDark,
                    ),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(24, 24),
                      backgroundColor: AppColors.white,
                      side: const BorderSide(
                        color: AppColors.primaryDark,
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          Expanded(
            child: BlocConsumer<TicketWorkflowMasterBloc, TicketWorkflowMasterState>(
              listener: (context, state) {
                debugPrint('state: $state');
                if (state is TicketWorkflowMasterLoading) {
                  LoaderUtils.showLoader(context);
                } else if (state is TicketWorkflowMasterFailure) {
                  LoaderUtils.hideLoader(context);
                  SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
                } else if (state is TicketWorkflowMasterSuccess) {
                  LoaderUtils.hideLoader(context);
                  setState(() {
                    workflowList = state.ticketWorkflowList!;
                    if (kIsWeb) {
                      filteredWorkflows = workflowList;
                    } else {
                      filteredWorkflows = workflowList.sublist(0, 10);
                    }
                    totalPages = (workflowList.length / 10).ceil();
                    currentPage = 1;
                  });
                }
              },
              builder: (context, state) {
                return CategoryMasterTableViewWeb<TicketWorkflowMasterEntity>(
                  filteredItems: filteredWorkflows,
                  headers: _headers,
                  minWidth: 720,
                  cellBuilder: (item, isMobile) =>
                      _buildWorkflowCell(item, isMobile),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DataCell> _buildWorkflowCell(
    TicketWorkflowMasterEntity item,
    bool isMobile,
  ) {
    return [
      DataCell(buildMasterCell(context, item.workflowName ?? '-', isMobile)),
      DataCell(buildMasterCell(context, item.category ?? '-', isMobile)),
      DataCell(buildMasterCell(context, item.subCategory ?? '-', isMobile)),
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
  ) {}
}
