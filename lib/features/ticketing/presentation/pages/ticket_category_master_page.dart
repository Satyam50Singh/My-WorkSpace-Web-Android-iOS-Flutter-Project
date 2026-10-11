import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_action_dialog_utils.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_data_source.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/export/excel_exporter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/ticket_category_models/insert_update_ticket_category_request_model.dart';
import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';
import '../widgets/ticketing_my_request_action/ticket_list_empty_view.dart';

class TicketCategoryMasterPage extends StatefulWidget {
  const TicketCategoryMasterPage({super.key});

  @override
  State<TicketCategoryMasterPage> createState() =>
      _TicketCategoryMasterPageState();
}

class _TicketCategoryMasterPageState extends State<TicketCategoryMasterPage> {
  List<TicketCategoryEntity> categories = [];

  List<TicketCategoryEntity> filteredCategories = [];

  static const List<String> _headers = [
    "Category Description",
    "Assigned Department",
    "Action Status",
  ];

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _apiCallForCategoryList();
  }

  void _apiCallForCategoryList() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      if (companyId != null) {
        context.read<TicketCategoryMasterBloc>().add(
          TicketCategoryListRequested(companyID: companyId),
        );
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  DataColumn2 _buildColumnHeaderCell(String header) {
    return DataColumn2(
      label: Center(
        child: Text(
          header,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
          softWrap: false,
          maxLines: 1,
        ),
      ),
    );
  }

  void searchOperation(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    if (value.isNotEmpty && value.isNotEmpty) {
      final searchText = value.toLowerCase();
      debugPrint('searchText: $searchText');
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          filteredCategories = categories.where((category) {
            return (category.category!.toLowerCase().contains(searchText) ||
                category.department!.toLowerCase().contains(searchText));
          }).toList();
        });
        debugPrint('filteredCategories: ${filteredCategories.toString()}');
      });
    } else if (value.isEmpty) {
      filteredCategories = categories;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

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
              title: 'Ticket Categories',
              showAddNewBtn: true,
              showExportToExcelBtn: true,
              addNewBtnTitleText: 'Add New Category',
              onTapExportToExcel: _performExportOperation,
              onTapAddNewRequest: _performAddNewCategoryOperation,
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
                      hintText: 'Search...',
                      onChanged: searchOperation,
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
                      onChanged: searchOperation,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: _performAddNewCategoryOperation,
                    icon: const Icon(Icons.add, color: AppColors.white),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      backgroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.outlined(
                    onPressed: _performExportOperation,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Expanded(
            child:
                BlocConsumer<
                  TicketCategoryMasterBloc,
                  TicketCategoryMasterState
                >(
                  listener: (context, state) {
                    if (state is TicketCategoryMasterLoading) {
                      LoaderUtils.showLoader(context);
                    }
                    if (state is TicketCategoryMasterFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    }
                    if (state is TicketCategoryMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        categories = state.categoryList;
                        filteredCategories = categories;
                      });
                    }
                    if (state is InsertUpdateTicketCategorySuccess) {
                      LoaderUtils.hideLoader(context);
                      _apiCallForCategoryList();
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: isMobile ? 08 : 32,
                        bottom: 32,
                      ),
                      child: PaginatedDataTable2(
                        minWidth: 640,
                        headingRowColor: WidgetStateColor.resolveWith(
                          (states) => AppColors.primaryDark,
                        ),
                        headingRowDecoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        columns: _headers.map((header) {
                          return _buildColumnHeaderCell(header);
                        }).toList(),
                        source: CategoryDataSource(
                          context,
                          filteredCategories,
                          0,
                          onActionBtnPressed: (c1, action) {
                            _performEditDeleteOperation(action, c1);
                          },
                        ),
                        onRowsPerPageChanged: (value) {
                          if (value == null) return;
                        },
                        dataRowHeight: 54,
                        empty: const TicketListEmptyView(),
                        renderEmptyRowsInTheEnd: false,
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void _performEditDeleteOperation(String action, TicketCategoryEntity c1) {
    if (action == "Edit") {
      CategoryActionDialogUtils.showAddNewCategoryDialog(
        buildContext: context,
        selectedCategory: c1,
        onSuccess: _apiCallForCategoryList,
      );
    } else if (action == "Delete") {
      CategoryActionDialogUtils.showDeleteCategoryDialog(
        context: context,
        category: c1,
        onPressed: (dialogCtx) {
          Navigator.of(dialogCtx).pop();
          final state = context.read<EmployeeDetailCubit>().state;
          if (state is EmployeeDetailFetched) {
            final employee = state.employeeDetail;
            final companyID = employee.companyId ?? 0;
            final loggedInUserID = employee.userID?.toString() ?? "0";
            final action = 'D';
            final category = c1.category ?? "";
            final departmentID = c1.departmentID ?? 0;
            final categoryID = c1.categoryID ?? 0;
            debugPrint(
              'companyID: $companyID, loggedInUserID: $loggedInUserID, action: $action, category: $category, departmentID: $departmentID, categoryID: $categoryID',
            );
            final payload = InsertUpdateTicketCategoryRequestModel(
              categoryID: categoryID,
              category: category,
              departmentID: departmentID,
              companyID: companyID,
              loggedInUserID: loggedInUserID,
              action: action,
            );
            context.read<TicketCategoryMasterBloc>().add(
              InsertUpdateCategoryRequested(payload: payload),
            );
          }
        },
      );
    }
  }

  void _performExportOperation() {
    if (categories.isNotEmpty) {
      SnackBarUtils.showFloatingSnackBar(context, 'Downloading excel file...');
      final currentDate = DateTime.now();
      final formattedDate =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      ExcelExporter().export(
        fileName: 'category_master_export_$formattedDate.xlsx',
        sheetName: 'Category Records',
        headers: ['Category ID', ..._headers],
        dataList: categories,
      );
    }
  }

  void _performAddNewCategoryOperation() {
    CategoryActionDialogUtils.showAddNewCategoryDialog(
      buildContext: context,
      onSuccess: _apiCallForCategoryList,
    );
  }
}
