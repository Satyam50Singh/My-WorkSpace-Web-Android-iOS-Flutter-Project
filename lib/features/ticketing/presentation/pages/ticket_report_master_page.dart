import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_report_models/fetch_ticket_report_web_request_model.dart';

import '../../../../core/common/widgets/custom_date_range_picker.dart';
import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/ticket_report_entities/fetch_cat_sub_cat_loc_dept_type_list_entity.dart';
import '../../domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import '../blocs/ticket_report_master_bloc/ticket_report_master_bloc.dart';
import '../widgets/ticket_report_master_widget/ticket_report_count_horizontal_list.dart';
import '../widgets/ticket_report_master_widget/ticket_report_filter_dropdown.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketReportMasterPage extends StatefulWidget {
  const TicketReportMasterPage({super.key});

  @override
  State<TicketReportMasterPage> createState() => _TicketReportMasterPageState();
}

class _TicketReportMasterPageState extends State<TicketReportMasterPage> {
  late final TextEditingController? _searchController;
  TicketReportStatusCountEntity? _ticketReportStatusCount;

  DateTimeRange selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  List<TicketReportCategoryEntity>? categoryList;
  TicketReportCategoryEntity? _selectedCategory;
  List<TicketReportSubCategoryEntity>? subCategoryList;
  List<TicketReportSubCategoryEntity>? filteredSubCategoryList;
  TicketReportSubCategoryEntity? _selectedSubCategory;
  List<TicketReportLocationEntity>? locationList;
  TicketReportLocationEntity? _selectedLocation;
  List<TicketReportDepartmentEntity>? departmentList;
  TicketReportDepartmentEntity? _selectedDepartment;
  List<TicketReportTicketTypeEntity>? ticketTypeList;
  TicketReportTicketTypeEntity? _selectedTicketType;

  String? _currentFromDate;
  String? _currentToDate;
  String _currentActionStatus = '';

  @override
  void initState() {
    _searchController = TextEditingController();

    apiCallForFetchCatSubCatLocDeptTypeList();
    apiCallForFetchTicketReportWeb();

    super.initState();
  }

  void apiCallForFetchCatSubCatLocDeptTypeList() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;
      context.read<TicketReportMasterBloc>().add(
        FetchCatSubCatLocDeptTypeListRequested(companyID: companyID),
      );
    }
  }

  void apiCallForFetchTicketReportWeb() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;
      final dateFormatter = DateFormat("dd/MM/yyyy");
      debugPrint('_currentActionStatus: $_currentActionStatus');

      final payload = FetchTicketReportWebRequestModel(
        companyID: companyID,
        fromDate: _currentFromDate ?? dateFormatter.format(DateTime.now()),
        toDate: _currentToDate ?? dateFormatter.format(DateTime.now()),
        ticketType: _currentActionStatus.isEmpty ? "All" : "",
        actionStatus: _currentActionStatus,
        categoryId: _selectedCategory?.categoryID ?? 0,
        subCategoryId: _selectedSubCategory?.subCategoryID ?? 0,
        locationId: _selectedLocation?.locationID ?? 0,
        departmentId: _selectedDepartment?.departmentID ?? 0,
      );

      context.read<TicketReportMasterBloc>().add(
        FetchTicketReportWebRequested(payload: payload),
      );
    }
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  List<Widget> _buildFilters() {
    return [
      if (categoryList != null) ...[
        TicketReportFilterDropdown<TicketReportCategoryEntity>(
          items: categoryList ?? [],
          selectedValue: _selectedCategory,
          label: 'Category',
          hintText: 'All Categories',
          searchHintText: 'Search Category...',
          icon: Icons.bookmark_border,
          iconColor: AppColors.btnBgGreen,
          itemAsString: (item) => item.categoryDesc ?? '',
          compareFn: (a, b) => a.categoryID == b.categoryID,
          onSelected: (value) {
            if (value != null && value.categoryID != 0) {
              setState(() {
                _selectedCategory = value;
                filteredSubCategoryList = subCategoryList
                    ?.where((element) => element.categoryID == value.categoryID)
                    .toList();
                _selectedSubCategory = null;
                apiCallForFetchTicketReportWeb();
              });
            }
          },
        ),
      ],
      SizedBox(width: 8),
      if (subCategoryList != null) ...[
        TicketReportFilterDropdown<TicketReportSubCategoryEntity>(
          items: filteredSubCategoryList ?? [],
          selectedValue: _selectedSubCategory,
          label: 'Sub-Category',
          hintText: 'All Sub-Categories',
          searchHintText: 'Search Sub-Category...',
          icon: Icons.local_offer_outlined,
          iconColor: AppColors.orange,
          itemAsString: (item) => item.subCategoryDesc ?? '',
          compareFn: (a, b) => a.subCategoryID == b.subCategoryID,
          onSelected: (value) {
            if (value != null && value.subCategoryID != 0) {
              setState(() {
                _selectedSubCategory = value;
                apiCallForFetchTicketReportWeb();
              });
            }
          },
        ),
      ],
      SizedBox(width: 8),
      if (locationList != null) ...[
        TicketReportFilterDropdown<TicketReportLocationEntity>(
          items: locationList ?? [],
          selectedValue: _selectedLocation,
          label: 'Location',
          hintText: 'All Locations',
          searchHintText: 'Search Location...',
          icon: Icons.location_pin,
          iconColor: AppColors.violet,
          itemAsString: (item) => item.locationDesc ?? '',
          compareFn: (a, b) => a.locationID == b.locationID,
          onSelected: (value) {
            if (value != null && value.locationID != 0) {
              setState(() {
                _selectedLocation = value;
                apiCallForFetchTicketReportWeb();
              });
            }
          },
        ),
      ],
      SizedBox(width: 8),
      if (departmentList != null) ...[
        TicketReportFilterDropdown<TicketReportDepartmentEntity>(
          items: departmentList ?? [],
          selectedValue: _selectedDepartment,
          label: 'Department',
          hintText: 'All Departments',
          searchHintText: 'Search Department...',
          icon: Icons.apartment_outlined,
          iconColor: AppColors.violet,
          itemAsString: (item) => item.department ?? '',
          compareFn: (a, b) => a.departmentID == b.departmentID,
          onSelected: (value) {
            if (value != null && value.departmentID != 0) {
              setState(() {
                _selectedDepartment = value;
                apiCallForFetchTicketReportWeb();
              });
            }
          },
        ),
      ],
      SizedBox(width: 8),
      if (ticketTypeList != null) ...[
        TicketReportFilterDropdown<TicketReportTicketTypeEntity>(
          items: ticketTypeList ?? [],
          selectedValue: _selectedTicketType,
          label: 'Ticket Type',
          hintText: 'All Types',
          searchHintText: 'Search Ticket Type...',
          icon: Icons.tune_outlined,
          iconColor: AppColors.orange,
          itemAsString: (item) => item.ticketType ?? '',
          compareFn: (a, b) => a.ticketTypeID == b.ticketTypeID,
          onSelected: (value) {
            if (value != null && value.ticketTypeID != 0) {
              setState(() {
                _selectedTicketType = value;
                apiCallForFetchTicketReportWeb();
              });
            }
          },
        ),
      ],
    ];
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
              title: 'Ticket Report',
              showAddNewBtn: false,
              showExportToExcelBtn: true,
              addNewBtnTitleText: '',
              onTapExportToExcel: () {},
              onTapAddNewRequest: () {},
            ),
            SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomDateRangePicker(
                          selectedRange: selectedRange,
                          onDateRangeChanged:
                              (fromDate, toDate, updatedDateRange) {
                                _currentFromDate = fromDate;
                                _currentToDate = toDate;

                                setState(() {
                                  selectedRange = updatedDateRange;
                                });

                                apiCallForFetchTicketReportWeb();
                              },
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            label: Text('Reset'),
                            onPressed: _resetAllFilterValues,
                            icon: Icon(Icons.filter_alt_off),
                            style: IconButton.styleFrom(
                              elevation: 4,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 16,
                              ),
                              backgroundColor: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 272,
                          maxHeight: 48,
                        ),
                        child: CustomSearchBar(
                          searchController: _searchController,
                          hintText: 'Search by ticket details...',
                          onChanged: _searchOperation,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          Expanded(
            child:
                BlocConsumer<TicketReportMasterBloc, TicketReportMasterState>(
                  listener: (context, state) {
                    if (state is TicketReportMasterLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is FetchCatSubCatLocDeptTypeListFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is FetchCatSubCatLocDeptTypeListSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        categoryList = state.data?.category ?? [];
                        subCategoryList = state.data?.subcategory ?? [];
                        filteredSubCategoryList = state.data?.subcategory ?? [];
                        locationList = state.data?.location ?? [];
                        departmentList = state.data?.department ?? [];
                        ticketTypeList = state.data?.ticketType ?? [];
                      });
                    } else if (state is FetchTicketReportWebFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is FetchTicketReportWebSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        _ticketReportStatusCount =
                            state.data?.statusCount?.isNotEmpty == true
                            ? state.data?.statusCount![0]
                            : null;
                      });
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          if (_ticketReportStatusCount != null) ...[
                            TicketReportCountHorizontalList(
                              ticketRequestCount: _ticketReportStatusCount,
                              onPressed: (actionStatus) {
                                _currentActionStatus = actionStatus;
                                apiCallForFetchTicketReportWeb();
                                setState(() {
                                  _currentActionStatus = actionStatus;
                                });
                              },
                              selectedStatus: _currentActionStatus,
                            ),

                            SizedBox(height: 16),
                          ],

                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.tune),
                                      SizedBox(width: 8),
                                      Text(
                                        'Filter Settings',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: _resetAllFilterValues,
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isMobile =
                                          constraints.maxWidth < 600;

                                      final filters = _buildFilters();

                                      if (isMobile) {
                                        return Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: filters,
                                        );
                                      }

                                      return Row(children: filters);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void _searchOperation(String query) {}

  void _resetAllFilterValues() {
    setState(() {
      _selectedCategory = null;
      _selectedSubCategory = null;
      _selectedLocation = null;
      _selectedDepartment = null;
      _selectedTicketType = null;
      _currentActionStatus = '';
      _currentFromDate = null;
      _currentToDate = null;
      _searchController?.clear();
      selectedRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

      apiCallForFetchTicketReportWeb();
    });
  }
}
