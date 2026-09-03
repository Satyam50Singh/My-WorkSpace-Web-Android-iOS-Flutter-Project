import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_date_range_picker.dart';
import 'package:my_worksphere_web/core/routes/app_routes.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_count_horizontal_list.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_list_table_view.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/ticket_my_request/ticket_my_request_request.dart';
import '../blocs/my_ticket_request_bloc/ticketing_bloc.dart';
import '../widgets/my_request_web_app_bar.dart';

class TicketingMyRequest extends StatefulWidget {
  const TicketingMyRequest({super.key});

  @override
  State<TicketingMyRequest> createState() => _TicketingMyRequestState();
}

class _TicketingMyRequestState extends State<TicketingMyRequest> {
  int? _currentPageSize;
  int _currentPageCount = 1;
  String? _currentFromDate;
  String? _currentToDate;
  String? _currentActionStatus;
  String? _currentSearchText;
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails(actionStatus: '');
  }

  void _fetchTicketDetails({
    String? actionStatus = "",
    int? pageCount = 1,
    int? pageSize = 10,
    String? fromDate,
    String? toDate,
    String? searchText,
  }) {
    _currentPageCount = pageCount ?? 1;
    final employeeState = context.read<EmployeeDetailCubit>().state;

    if (employeeState is EmployeeDetailFetched) {
      final employee = employeeState.employeeDetail;
      final dateFormatter = DateFormat("dd/MM/yyyy");

      final payload = TicketMyRequestRequest(
        companyId: employee.companyId,
        empCd: employee.empCd,
        fromDate:
            _currentFromDate ??
            fromDate ??
            dateFormatter.format(DateTime.now()),
        toDate:
            _currentToDate ??
            toDate ??
                dateFormatter.format(DateTime.now()),
        pageCount: pageCount,
        pageSize: _currentPageSize ?? pageSize,
        departmentId: 0,
        categoryId: 0,
        actionStatus: _currentActionStatus ?? actionStatus,
        searchText: _currentSearchText ?? searchText ?? '',
      );

      context.read<TicketingBloc>().add(
        TicketingMyRequestDetailRequested(payload: payload),
      );
    }
  }

  void _resetAllFilters() {
    _currentFromDate = null;
    _currentToDate = null;
    _currentActionStatus = '';
    _currentSearchText = '';
    // Add this to update the UI highlight
    setState(() {
      selectedStatus = 'All';
    });
    _fetchTicketDetails(
      actionStatus: '',
      pageCount: 1,
      pageSize: 10,
      fromDate: _currentFromDate,
      toDate: _currentToDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMini = width < 360;
    final isMobile = width < 600;

    return Column(
      children: [
        if (!isMobile && !isMini) const TicketingMyRequestWebAppBar(),
        SizedBox(height: 16),

        if (!isMobile)
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
                        onDateRangeChanged: (fromDate, toDate) {
                          _currentFromDate = fromDate;
                          _currentToDate = toDate;
                          _fetchTicketDetails(
                            actionStatus: '',
                            pageCount: 1,
                            pageSize: 10,
                            fromDate: _currentFromDate,
                            toDate: _currentToDate,
                          );
                        },
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          label: Text('Reset'),
                          onPressed: _resetAllFilters,
                          icon: Icon(Icons.filter_alt_off),
                          style: IconButton.styleFrom(
                            elevation: 4,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            backgroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),

                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 240,
                        maxHeight: 48,
                      ),
                      child: CustomSearchBar(
                        hintText: 'Search...',
                        onChanged: (value) {
                          if (value.isNotEmpty && value.length > 2) {
                            _currentSearchText = value;
                            _fetchTicketDetails(
                              pageCount: 1,
                              pageSize: 10,
                              searchText: _currentSearchText,
                            );
                          } else {
                            if (value.isEmpty) {
                              _currentSearchText = '';
                              _fetchTicketDetails(
                                pageCount: 1,
                                pageSize: 10,
                                searchText: _currentSearchText,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (isMobile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomDateRangePicker(
                        onDateRangeChanged: (fromDate, toDate) {
                          _currentFromDate = fromDate;
                          _currentToDate = toDate;
                          _fetchTicketDetails(
                            actionStatus: '',
                            pageCount: 1,
                            pageSize: 10,
                            fromDate: _currentFromDate,
                            toDate: _currentToDate,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        label: Text('Reset'),
                        onPressed: _resetAllFilters,
                        icon: Icon(Icons.filter_alt_off),
                        style: IconButton.styleFrom(
                          elevation: 4,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          backgroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search by ticket ID or subject...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    prefixIconColor: AppColors.primaryDark,
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && value.length > 2) {
                      _currentSearchText = value;
                      _fetchTicketDetails(
                        pageCount: 1,
                        pageSize: 10,
                        searchText: _currentSearchText,
                      );
                    } else {
                      if (value.isEmpty) {
                        _currentSearchText = '';
                        _fetchTicketDetails(
                          pageCount: 1,
                          pageSize: 10,
                          searchText: _currentSearchText,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

        Expanded(
          child: BlocConsumer<TicketingBloc, TicketingState>(
            listener: (context, state) {
              if (state is TicketingLoading) {
                LoaderUtils.showLoader(context);
              } else if (state is TicketingFailure) {
                LoaderUtils.hideLoader(context);
                SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
              } else if (state is TicketingMyRequestDetailSuccess) {
                LoaderUtils.hideLoader(context);
              }
            },
            builder: (context, state) {
              if (state is TicketingMyRequestDetailSuccess) {
                final ticketingDetailList = state.ticketDetail.ticketDetailList;
                final ticketRequestCount =
                    state.ticketDetail.ticketRequestCount?.isNotEmpty == true
                    ? state.ticketDetail.ticketRequestCount![0]
                    : null;
                final totalRecords = state.ticketDetail.totalRecords ?? 0;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ticketRequestCount != null)
                        TicketCountHorizontalList(
                          ticketRequestCount: ticketRequestCount,
                          onPressed: (actionStatus) {
                            _currentActionStatus = actionStatus;
                            _fetchTicketDetails(
                              actionStatus: _currentActionStatus,
                            );
                            setState(() {
                              selectedStatus = actionStatus;
                            });
                          },
                          selectedStatus: selectedStatus,
                        ),

                      SizedBox(height: 36),

                      Expanded(
                        child: TicketListTableView(
                          ticketingDetailList: ticketingDetailList,
                          rowsPerPage:
                              (totalRecords > 0 &&
                                  totalRecords < (_currentPageSize ?? 10))
                              ? totalRecords
                              : (_currentPageSize ?? 10),
                          currentPage: _currentPageCount,
                          totalRecordsCount: totalRecords,
                          updatePageSize: (pageSize) {
                            _currentPageSize = pageSize;
                            _fetchTicketDetails(pageSize: pageSize);
                          },
                          updatePageCount: (pageCount) {
                            _fetchTicketDetails(pageCount: pageCount);
                          },
                          onTapViewTicketDetail: (selectedTicketId) {
                            debugPrint('Selected Ticket ID: $selectedTicketId');
                            context.goNamed(
                              AppRoutes.viewTicketDetails,
                              pathParameters: {'ticketId': selectedTicketId},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
