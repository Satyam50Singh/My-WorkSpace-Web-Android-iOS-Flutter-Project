import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_action_dialog_utils.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_master_list_view_mobile.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/export/excel_exporter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/ticket_category_models/insert_update_ticket_category_request_model.dart';
import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../widgets/ticket_category_master_widgets/build_master_cell.dart';
import '../widgets/ticket_category_master_widgets/category_action_button.dart';
import '../widgets/ticket_category_master_widgets/category_master_table_view_web.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

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

  int totalPages = 0;
  int currentPage = 0;

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
            const SizedBox(height: 8),
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
                        if (kIsWeb) {
                          filteredCategories = categories;
                        } else {
                          filteredCategories = categories.sublist(0, 10);
                        }
                        totalPages = (categories.length / 10).ceil();
                        currentPage = 1;
                      });
                    }
                    if (state is DeleteTicketCategoryFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (!isMobile) {
                      return CategoryMasterTableViewWeb<TicketCategoryEntity>(
                        filteredItems: filteredCategories,
                        headers: _headers,
                        minWidth: 720,
                        cellBuilder: (item, isMobile) {
                          return [
                            DataCell(
                              buildMasterCell(
                                context,
                                item.category ?? '-',
                                isMobile,
                              ),
                            ),
                            DataCell(
                              buildMasterCell(
                                context,
                                item.department ?? '-',
                                isMobile,
                                color: AppColors.textSecondary,
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
                                      _performEditDeleteOperation(
                                        "Delete",
                                        item,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: CategoryMasterListViewMobile(
                            filteredCategories: filteredCategories,
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
    debugPrint('currentPage: $currentPage && totalPages: $totalPages');
    if (currentPage != 1 && currentPage <= totalPages) {
      // 2, 3, 4
      setState(() {
        currentPage--; // 1 // 2
        final startIndex = (currentPage - 1) * 10; // 0 // 2
        final endIndex = startIndex + 10;
        debugPrint('currentPage: $startIndex && totalPages: $endIndex');
        filteredCategories = categories.sublist(startIndex, endIndex);
      });
    }
  }

  void goToNext() {
    debugPrint('currentPage: $currentPage && totalPages: $totalPages');
    if (currentPage <= totalPages) {
      setState(() {
        currentPage++;
        final startIndex = (currentPage - 1) * 10;
        var endIndex = startIndex + 10;
        if (endIndex > categories.length) {
          endIndex = categories.length;
        }
        debugPrint('currentPage: $startIndex && totalPages: $endIndex');
        filteredCategories = categories.sublist(startIndex, endIndex);
      });
    }
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
        itemTitle: c1.category ?? "",
        onPressed: (dialogCtx) {
          Navigator.of(dialogCtx).pop();
          _apiCallForDeleteCategory(c1);
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

  void _apiCallForDeleteCategory(TicketCategoryEntity c1) {
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
  }
}
