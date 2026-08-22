import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_history_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/view_ticket_details_bloc/view_ticket_details_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/view_ticket_detail_header.dart';

import '../../../../core/utils/loader_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/view_ticket_detail_v6.dart';
import '../widgets/view_ticket_details/ticket_detail_over_view.dart';
import '../widgets/view_ticket_details/ticket_detail_tab_bar.dart';

class ViewTicketDetails extends StatefulWidget {
  final String ticketId;

  const ViewTicketDetails({super.key, required this.ticketId});

  @override
  State<ViewTicketDetails> createState() => _ViewTicketDetailsState();
}

class _ViewTicketDetailsState extends State<ViewTicketDetails> {
  String _selectedTab = 'Ticket Details';
  ViewTicketDetailV6Entity? viewTicketDetailV6Response;
  List<TicketWorkflowEntity>? viewTicketWorkflowResponse;
  List<TicketHistoryEntity>? viewTicketActionHistoryResponse;

  @override
  void initState() {
    super.initState();

    var state = context.read<EmployeeDetailCubit>().state;

    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      final empCd = employee.empCd;

      final payload = ViewTicketDetailRequest(
        companyId: companyId,
        empCd: empCd,
        ticketId: widget.ticketId.toLowerCase().replaceFirst("tkt", ''),
      );

      _fetchViewTicketDetailV6Api(payload);
      _fetchViewTicketWorkFlowDetails(payload);
      _fetchViewTicketActionHistory(payload);
    }
  }

  void _fetchViewTicketDetailV6Api(ViewTicketDetailRequest payload) {
    context.read<ViewTicketDetailsBloc>().add(
      ViewTicketDetailsV6Requested(payload: payload),
    );
  }

  void _fetchViewTicketWorkFlowDetails(ViewTicketDetailRequest payload) {
    context.read<ViewTicketDetailsBloc>().add(
      ViewTicketWorkflowDetailsRequested(payload: payload),
    );
  }

  void _fetchViewTicketActionHistory(ViewTicketDetailRequest payload) {
    context.read<ViewTicketDetailsBloc>().add(
      ViewTicketActionHistoryRequested(payload: payload),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewTicketDetailsBloc, ViewTicketDetailsState>(
      listener: (context, state) {
        if (state is ViewTicketDetailsLoading) {
          LoaderUtils.showLoader(context);
        } else if (state is ViewTicketDetailsFailure) {
          LoaderUtils.hideLoader(context);
          SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
        } else if (state is ViewTicketDetailsV6Success ||
            state is ViewTicketWorkflowDetailsSuccess ||
            state is ViewTicketActionHistorySuccess) {
          LoaderUtils.hideLoader(context);
        }

        if (state is ViewTicketDetailsV6Success) {
          viewTicketDetailV6Response = state.viewTicketDetailV6.first;
        }
        if (state is ViewTicketWorkflowDetailsSuccess) {
          viewTicketWorkflowResponse = state.ticketWorkflow;
        }
        if (state is ViewTicketActionHistorySuccess) {
          viewTicketActionHistoryResponse = state.ticketHistory;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (viewTicketDetailV6Response != null)
              ViewTicketDetailHeader(
                ticketId: widget.ticketId,
                ticketStatus: viewTicketDetailV6Response?.ticketStatus,
              ),

            SizedBox(height: 16.0),

            TicketDetailTabBar(
              onSelectedTab: (String tabName) {
                setState(() {
                  _selectedTab = tabName;
                });
              },
            ),

            SizedBox(height: 16.0),

            // Conditional Rendering based on selected tab
            if (_selectedTab == 'Ticket Details' &&
                viewTicketDetailV6Response != null)
              Expanded(
                child: SingleChildScrollView(
                  child: TicketDetailOverView(ticketDetails: viewTicketDetailV6Response),
                ),
              ),

            if (_selectedTab == 'Workflow')
              const Center(child: Text("Workflow Content")),
            if (_selectedTab == 'Action History')
              const Center(child: Text("Action History Content")),
          ],
        );
      },
    );
  }
}
