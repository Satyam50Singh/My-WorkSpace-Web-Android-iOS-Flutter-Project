import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_date_range_picker.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_count_horizontal_list.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_list_table_view.dart';

import '../../data/models/ticket_my_request/ticket_my_request_request.dart';
import '../widgets/my_request_web_app_bar.dart';

class TicketingMyRequest extends StatefulWidget {
  const TicketingMyRequest({super.key});

  @override
  State<TicketingMyRequest> createState() => _TicketingMyRequestState();
}

class _TicketingMyRequestState extends State<TicketingMyRequest> {
  int? _currentPageSize;
  int _currentPageCount = 1;

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
  }) {
    _currentPageCount = pageCount ?? 1;
    final employeeState = context.read<EmployeeDetailCubit>().state;

    if (employeeState is EmployeeDetailFetched) {
      final employee = employeeState.employeeDetail;

      final payload = TicketMyRequestRequest(
        companyId: employee.companyId,
        empCd: employee.empCd,
        fromDate: fromDate ?? DateFormat("dd/MM/yyyy").format(DateTime.now()),
        toDate: toDate ?? DateFormat("dd/MM/yyyy").format(DateTime.now()),
        pageCount: pageCount,
        pageSize: _currentPageSize ?? pageSize,
        departmentId: 0,
        categoryId: 0,
        actionStatus: actionStatus,
      );

      context.read<TicketingBloc>().add(
        TicketingMyRequestDetailRequested(payload: payload),
      );
    }
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

        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomDateRangePicker(
              onDateRangeChanged: (fromDate, toDate) {
                _fetchTicketDetails(
                  actionStatus: '',
                  pageCount: 1,
                  pageSize: 10,
                  fromDate: fromDate,
                  toDate: toDate,
                );
              },
            ),
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
                            _fetchTicketDetails(actionStatus: actionStatus);
                          },
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
