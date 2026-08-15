import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_count_horizontal_list.dart';

import '../../data/models/ticket_my_request/ticket_my_request_request.dart';
import '../widgets/my_request_web_app_bar.dart';

class TicketingMyRequest extends StatefulWidget {
  const TicketingMyRequest({super.key});

  @override
  State<TicketingMyRequest> createState() => _TicketingMyRequestState();
}

class _TicketingMyRequestState extends State<TicketingMyRequest> {
  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
  }

  void _fetchTicketDetails() {
    final employeeState = context.read<EmployeeDetailCubit>().state;

    if (employeeState is EmployeeDetailFetched) {
      final employee = employeeState.employeeDetail;

      final payload = TicketMyRequestRequest(
        companyId: employee.companyId,
        empCd: employee.empCd,
        fromDate: "06/08/2026",
        toDate: "12/08/2026",
        pageCount: 1,
        pageSize: 10,
        departmentId: 0,
        categoryId: 0,
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

        BlocConsumer<TicketingBloc, TicketingState>(
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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.red.shade200,
                      height: 60,
                      width: double.infinity,
                      child: Center(child: Text('Space for Calender')),
                    ),

                    if (ticketRequestCount != null)
                      TicketCountHorizontalList(
                        ticketRequestCount: ticketRequestCount,
                      ),

                    SizedBox(height: 36),
                    Container(
                      color: Colors.yellow.shade200,
                      height: 400,
                      width: double.infinity,
                      child: Center(child: Text('Space for table view')),
                    ),
                  ],
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
