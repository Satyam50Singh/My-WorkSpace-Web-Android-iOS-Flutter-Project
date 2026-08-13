import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_bloc.dart';

import '../../data/models/ticket_my_request/ticket_my_request_request.dart';

class TicketingMyRequest extends StatefulWidget {
  const TicketingMyRequest({super.key});

  @override
  State<TicketingMyRequest> createState() => _TicketingMyRequestState();
}

class _TicketingMyRequestState extends State<TicketingMyRequest> {
  @override
  void initState() {
    super.initState();

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
    return BlocConsumer<TicketingBloc, TicketingState>(
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
          final ticketRequestCount = state.ticketDetail.ticketRequestCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: ticketRequestCount?.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    color: AppColors.background,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticketRequestCount![index].total.toString()),
                        Text(ticketRequestCount[index].open.toString()),
                        Text(ticketRequestCount[index].assigned.toString()),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }

        return const Center(child: Text('Ticketing My Request'));
      },
    );
  }
}
