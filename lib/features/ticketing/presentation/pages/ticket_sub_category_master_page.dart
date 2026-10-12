import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticket_sub_category_master_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/build_master_cell.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_master_table_view_web.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/export/excel_exporter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../widgets/ticket_category_master_widgets/category_action_button.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketSubCategoryMasterPage extends StatefulWidget {
  const TicketSubCategoryMasterPage({super.key});

  @override
  State<TicketSubCategoryMasterPage> createState() =>
      _TicketSubCategoryMasterPageState();
}

class _TicketSubCategoryMasterPageState
    extends State<TicketSubCategoryMasterPage> {
  List<SubCategoryMasterEntity> subCategories = [];

  List<SubCategoryMasterEntity> filteredSubCategories = [];

  static const List<String> _headers = [
    "Sub-Category Description",
    "Assigned Category",
    "Assigned Priority",
    "Action Status",
  ];

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _apiCallForSubCategoryList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  List<DataCell> _buildSubCategoriesCell(
    SubCategoryMasterEntity item,
    bool isMobile,
  ) {
    return [
      DataCell(buildMasterCell(context, item.subCategory ?? '-', isMobile)),
      DataCell(buildMasterCell(context, item.category ?? '-', isMobile)),
      DataCell(
        buildMasterCell(
          context,
          (item.priority == null || item.priority!.isEmpty)
              ? '-'
              : item.priority!,
          isMobile,
        ),
      ),
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

  void _apiCallForSubCategoryList() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      if (companyId != null) {
        context.read<TicketSubCategoryMasterBloc>().add(
          TicketSubCategoryListRequested(companyID: companyId),
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
              title: 'Ticket Sub-Categories',
              showAddNewBtn: true,
              showExportToExcelBtn: true,
              addNewBtnTitleText: 'Add New Sub-Category',
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
                      hintText: 'Search Here ...',
                      onChanged: _searchOperation,
                    ),
                  ),
                ),
              ],
            ),
          ],

          Expanded(
            child:
                BlocConsumer<
                  TicketSubCategoryMasterBloc,
                  TicketSubCategoryMasterState
                >(
                  listener: (context, state) {
                    if (state is TicketSubCategoryMasterLoading) {
                      LoaderUtils.showLoader(context);
                    }
                    if (state is TicketSubCategoryMasterFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    }
                    if (state is TicketSubCategoryMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        subCategories = state.subCategoryList;
                        filteredSubCategories = subCategories;
                      });
                    }
                  },
                  builder: (context, state) {
                    return CategoryMasterTableViewWeb(
                      filteredItems: filteredSubCategories,
                      headers: _headers,
                      minWidth: 720,
                      cellBuilder: (item, isMobile) =>
                          _buildSubCategoriesCell(item, isMobile),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void _searchOperation(String query) {}

  void _performEditDeleteOperation(
    String action,
    SubCategoryMasterEntity item,
  ) {}

  void _performExportOperation() {
    if (subCategories.isNotEmpty) {
      SnackBarUtils.showFloatingSnackBar(context, 'Downloading excel file...');
      final currentDate = DateTime.now();
      final formattedDate =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      ExcelExporter().export(
        fileName: 'sub_category_master_export_$formattedDate.xlsx',
        sheetName: 'Sub-Category Records',
        headers: ['SubCategory ID', ..._headers],
        dataList: subCategories,
      );
    }
  }

  void _performAddNewCategoryOperation() {}
}
