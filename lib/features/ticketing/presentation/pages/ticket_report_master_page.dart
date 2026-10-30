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
import '../../domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import '../blocs/ticket_report_master_bloc/ticket_report_master_bloc.dart';
import '../widgets/ticket_report_master_widget/ticket_report_count_horizontal_list.dart';
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
                            onPressed: () {},
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
                      debugPrint('FetchCatSubCatLocDeptTypeListSuccess');
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
                                    ],
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
}

void _searchOperation(String query) {}
