import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_sub_category_models/insert_update_sub_category_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticket_sub_category_master_bloc/ticket_sub_category_master_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/build_master_cell.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_master_table_view_web.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/sub_category_master_list_view_mobile.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/export/excel_exporter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../widgets/ticket_category_master_widgets/category_action_button.dart';
import '../widgets/ticket_category_master_widgets/category_action_dialog_utils.dart';
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

  int totalPages = 0;
  int currentPage = 0;

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
    final priorityText = (item.priority == null || item.priority!.isEmpty)
        ? 'Minor'
        : item.priority!;

    return [
      DataCell(buildMasterCell(context, item.subCategory ?? '-', isMobile)),
      DataCell(buildMasterCell(context, item.category ?? '-', isMobile)),
      DataCell(
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: priorityText == 'Major'
                  ? AppColors.btnBgRed.withValues(alpha: 0.1)
                  : AppColors.amber.withValues(alpha: 0.1),
              border: Border.all(
                color: priorityText == 'Major'
                    ? AppColors.btnBgRed
                    : AppColors.amber,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    color: priorityText == 'Major'
                        ? AppColors.btnBgRed
                        : AppColors.orange,
                    size: 8,
                  ),
                  SizedBox(width: 4),
                  Text(
                    priorityText,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12,
                      color: priorityText == 'Major'
                          ? AppColors.btnBgRed
                          : AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

          if (isMobile) ...[
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      hintText: 'Search...',
                      onChanged: _searchOperation,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: _performAddNewCategoryOperation,
                    icon: const Icon(Icons.add, color: AppColors.white),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  ),
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
                  TicketSubCategoryMasterBloc,
                  TicketSubCategoryMasterState
                >(
                  listener: (context, state) {
                    if (state is TicketSubCategoryMasterLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is TicketSubCategoryMasterFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is TicketSubCategoryMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        subCategories = state.subCategoryList;
                        if (kIsWeb) {
                          filteredSubCategories = subCategories;
                        } else {
                          filteredSubCategories = subCategories.sublist(0, 10);
                        }
                        totalPages = (subCategories.length / 10).ceil();
                        currentPage = 1;
                      });
                    } else if (state is DeleteTicketSubCategoryLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is DeleteTicketSubCategoryFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is DeleteTicketSubCategorySuccess) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        'Sub-Category deleted successfully',
                      );
                      _apiCallForSubCategoryList();
                    }
                  },
                  builder: (context, state) {
                    if (!isMobile) {
                      return CategoryMasterTableViewWeb<
                        SubCategoryMasterEntity
                      >(
                        filteredItems: filteredSubCategories,
                        headers: _headers,
                        minWidth: 720,
                        cellBuilder: (item, isMobile) =>
                            _buildSubCategoriesCell(item, isMobile),
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
                          child: SubCategoryMasterListViewMobile(
                            filteredCategories: filteredSubCategories,
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
        filteredSubCategories = subCategories.sublist(startIndex, endIndex);
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
        if (endIndex > subCategories.length) {
          endIndex = subCategories.length;
        }
        debugPrint('startIndex: $startIndex && endIndex: $endIndex');
        filteredSubCategories = subCategories.sublist(startIndex, endIndex);
      });
    } else {
      debugPrint('No more pages to load');
    }
  }

  void _searchOperation(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    if (value.isNotEmpty && value.isNotEmpty) {
      final searchText = value.toLowerCase();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          filteredSubCategories = subCategories.where((category) {
            return (category.category!.toLowerCase().contains(searchText) ||
                category.subCategory!.toLowerCase().contains(searchText) ||
                category.priority!.toLowerCase().contains(searchText));
          }).toList();
          totalPages = (filteredSubCategories.length / 10).ceil();
          currentPage = 1;
        });
        debugPrint(
          'filteredCategories: ${filteredSubCategories.map((e) => {'categoryId': e.categoryID, 'categoryName': e.category, 'subCategoryId': e.subCategoryID, 'subCategoryName': e.subCategory, 'priority': e.priority}).toList()}',
        );
      });
    } else if (value.isEmpty) {
      setState(() {
        filteredSubCategories = subCategories;
        totalPages = (filteredSubCategories.length / 10).ceil();
        currentPage = 1;
      });
    }
  }

  void _performEditDeleteOperation(String action, SubCategoryMasterEntity c1) {
    if (action == "Edit") {
      CategoryActionDialogUtils.showAddSubNewCategoryDialog(
        buildContext: context,
        subCategory: c1,
        onSuccess: _apiCallForSubCategoryList,
      );
    } else if (action == "Delete") {
      CategoryActionDialogUtils.showDeleteCategoryDialog(
        context: context,
        dialogHeading: 'Delete Sub-Category',
        itemTitle: c1.subCategory ?? "",
        onPressed: (dialogCtx) {
          Navigator.of(dialogCtx).pop();
          _apiCallForDeleteSubCategory(c1);
        },
      );
    }
  }

  void _apiCallForDeleteSubCategory(SubCategoryMasterEntity c1) {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;
      final loggedInUserID = employee.userID?.toString() ?? "0";
      final action = 'D';
      final categoryID = c1.categoryID ?? 0;
      final subCategoryID = c1.subCategoryID ?? 0;
      final subCategory = c1.subCategory ?? "";
      final priority = c1.priority ?? "";
      debugPrint(
        'companyID: $companyID, loggedInUserID: $loggedInUserID, action: $action, categoryID: $categoryID, subCategoryID: $subCategoryID, subCategory: $subCategory, priority: $priority',
      );
      final payload = InsertUpdateSubCategoryRequestModel(
        categoryID: categoryID,
        subCategoryID: subCategoryID,
        subCategory: subCategory,
        companyID: companyID,
        loggedInUserID: loggedInUserID,
        action: action,
        priority: priority,
      );
      context.read<TicketSubCategoryMasterBloc>().add(
        InsertUpdateSubCategoryRequested(payload: payload),
      );
    }
  }

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

  void _performAddNewCategoryOperation() {
    CategoryActionDialogUtils.showAddSubNewCategoryDialog(
      buildContext: context,
      onSuccess: _apiCallForSubCategoryList,
    );
  }
}
