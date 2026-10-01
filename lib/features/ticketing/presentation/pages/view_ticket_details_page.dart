import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/update_ticket_action_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/submit_reopen_review_request.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_entities/ticket_history_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_entities/ticket_workflow_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_my_action_bloc/ticketing_my_action_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/view_ticket_details_bloc/view_ticket_details_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/action_dialogs.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_detail_action_history.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_detail_workflow.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/view_ticket_detail_header.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/loader_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';
import '../widgets/view_ticket_details/ticket_detail_over_view.dart';
import '../widgets/view_ticket_details/ticket_detail_tab_bar.dart';

class ViewTicketDetailsPage extends StatefulWidget {
  final String ticketId;
  final String pageTag;

  const ViewTicketDetailsPage({
    super.key,
    required this.ticketId,
    required this.pageTag,
  });

  @override
  State<ViewTicketDetailsPage> createState() => _ViewTicketDetailsPageState();
}

class _ViewTicketDetailsPageState extends State<ViewTicketDetailsPage> {
  String _selectedTab = 'Ticket Details';
  ViewTicketDetailV6Entity? viewTicketDetailV6Response;
  List<TicketWorkflowEntity>? viewTicketWorkflowResponse;
  List<TicketHistoryEntity>? viewTicketActionHistoryResponse;

  String get _cleanedTicketId =>
      widget.ticketId.toLowerCase().replaceFirst("tkt", "");

  String get _currentPlatform {
    if (kIsWeb) return "Web";
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "Android";
      case TargetPlatform.iOS:
        return "iOS";
      default:
        return "Web";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllDetails();
  }

  ViewTicketDetailRequest? _createTicketDetailRequest() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      return ViewTicketDetailRequest(
        companyId: employee.companyId,
        empCd: employee.empCd,
        ticketId: _cleanedTicketId,
      );
    }
    return null;
  }

  void _fetchAllDetails() {
    final payload = _createTicketDetailRequest();
    if (payload != null) {
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

  void _submitReOpenReviewTicket(String remarks, int isReview) {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;

      final payload = SubmitReopenReviewRequest(
        companyId: employee.companyId,
        empCd: employee.empCd,
        ticketId: _cleanedTicketId,
        remarks: remarks,
        isReview: isReview,
      );
      context.read<ViewTicketDetailsBloc>().add(
        SubmitReopenReviewTicketRequested(payload: payload),
      );
    }
  }

  void _apiCallForAcceptWebTicket({bool forceAccept = false}) {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched && viewTicketDetailV6Response != null) {
      final bool isAcceptedByAnotherUser =
          viewTicketDetailV6Response?.isAcceptedByAnotherUser ?? false;

      if (!isAcceptedByAnotherUser || forceAccept) {
        final employee = state.employeeDetail;
        final payload = AcceptWebTicketRequestModel(
          empCD: employee.empCd,
          companyID: employee.companyId,
          platformType: _currentPlatform,
          ticketId: viewTicketDetailV6Response?.ticketID?.toString(),
          isAcceptedByAnotherUser: isAcceptedByAnotherUser,
        );
        debugPrint('Payload: ${payload.toString()}');
        context.read<TicketingMyActionBloc>().add(
          AcceptWebTicketRequested(payload: payload),
        );
      } else {
        if (viewTicketDetailV6Response != null) {
          ActionDialogs.showAlreadyAcceptedDialog(
            context: context,
            ticket: viewTicketDetailV6Response!,
            onAcceptTicketPressed: (BuildContext ctx) {
              Navigator.of(ctx).pop();
              _apiCallForAcceptWebTicket(forceAccept: true);
            },
          );
        }
      }
    }
  }

  void _showInProgressTicketDialog() {
    ActionDialogs.showUpdateTicketActionDialog(
      context,
      "In Progress Ticket",
      Icons.play_circle_outline,
      'Submit',
      'Enter remarks...',
      (remarks) {
        _apiCallForInProgressTicket(remarks);
      },
    );
  }

  void _apiCallForInProgressTicket(String remarks) {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final payload = UpdateTicketActionRequestModel(
        ticketId: _cleanedTicketId,
        closeTicketDesc: remarks,
        ticketAction: "In Progress",
        empCD: employee.empCd,
        companyID: employee.companyId,
        platformType: _currentPlatform,
        holdTillDatetime: "",
        isImageUploaded: 0,
        imageCount: 0,
        currentLevel: viewTicketDetailV6Response?.level,
      );
      context.read<TicketingMyActionBloc>().add(
        UpdateTicketActionRequested(payload: payload),
      );
    }
  }

  void _showHoldTicketDialog() {
    ActionDialogs.showUpdateTicketActionDialog(
      context,
      "Hold Ticket",
      Icons.pause_circle_outline,
      'Submit Hold',
      'Enter hold remarks...',
      (remarks) {
        _apiCallForInProgressTicket(remarks);
      },
      color: AppColors.amberDark,
    );
  }

  void reloadPage() {
    _fetchAllDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ViewTicketDetailsBloc, ViewTicketDetailsState>(
          listener: (context, state) {
            if (state is ViewTicketDetailsLoading) {
              LoaderUtils.showLoader(context);
            } else if (state is ViewTicketDetailsFailure) {
              LoaderUtils.hideLoader(context);
              SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
            } else if (state is ViewTicketDetailsV6Success) {
              LoaderUtils.hideLoader(context);
              if (state.viewTicketDetailV6.isNotEmpty) {
                setState(() {
                  viewTicketDetailV6Response = state.viewTicketDetailV6.first;
                });
              }
            } else if (state is ViewTicketWorkflowDetailsSuccess) {
              LoaderUtils.hideLoader(context);
              setState(() {
                viewTicketWorkflowResponse = state.ticketWorkflow;
              });
            } else if (state is ViewTicketActionHistorySuccess) {
              LoaderUtils.hideLoader(context);
              setState(() {
                viewTicketActionHistoryResponse = state.ticketHistory;
              });
            } else if (state is SubmitReopenReviewSuccess) {
              LoaderUtils.hideLoader(context);
              Navigator.of(context, rootNavigator: true).pop();
              SnackBarUtils.showFloatingSnackBar(
                context,
                state.submitReopenReviewEntity.message ?? "Action successful",
              );
              reloadPage();
            } else if (state is SubmitReopenReviewFailure) {
              LoaderUtils.hideLoader(context);
              SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
            }
          },
        ),
        BlocListener<TicketingMyActionBloc, TicketingMyActionState>(
          listener: (context, state) {
            if (state is TicketingMyActionLoading) {
              LoaderUtils.showLoader(context);
            } else if (state is TicketingMyActionFailure) {
              LoaderUtils.hideLoader(context);
              SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
            } else if (state is AcceptTicketSuccess) {
              LoaderUtils.hideLoader(context);
              SnackBarUtils.showFloatingSnackBar(context, state.message);
              reloadPage();
            } else if (state is UpdateTicketActionSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              LoaderUtils.hideLoader(context);
              SnackBarUtils.showFloatingSnackBar(context, state.message);
              reloadPage();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (context.canPop()) {
            context.pop();
          } else {
            if (widget.pageTag == 'my-actions') {
              context.goNamed('my-actions');
            } else {
              context.goNamed('my-tickets');
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (viewTicketDetailV6Response != null)
              ViewTicketDetailHeader(
                ticketId: widget.ticketId,
                ticketStatus: viewTicketDetailV6Response?.ticketStatus,
                pageTag: widget.pageTag,
              ),

            const SizedBox(height: 16.0),

            if (viewTicketDetailV6Response != null)
              TicketDetailTabBar(
                onSelectedTab: (String tabName) {
                  setState(() {
                    _selectedTab = tabName;
                  });
                },
              ),

            const SizedBox(height: 16.0),

            // Conditional Rendering based on selected tab
            if (_selectedTab == 'Ticket Details' &&
                viewTicketDetailV6Response != null)
              Expanded(
                child: SingleChildScrollView(
                  child: TicketDetailOverView(
                    pageTag: widget.pageTag,
                    ticketDetails: viewTicketDetailV6Response,
                    onActionSubmit: _submitReOpenReviewTicket,
                    onTransferTicket: () {},
                    onAcceptTicket: _apiCallForAcceptWebTicket,
                    onInProgressTicket: _showInProgressTicketDialog,
                    onHoldTicket: _showHoldTicketDialog,
                    onCloseTicket: () {},
                  ),
                ),
              ),

            if (_selectedTab == 'Workflow')
              Expanded(
                child: SingleChildScrollView(
                  child: TicketDetailWorkflow(
                    pageTag: widget.pageTag,
                    workFlowDetail: viewTicketWorkflowResponse,
                    ticketDetails: viewTicketDetailV6Response,
                    onActionSubmit: _submitReOpenReviewTicket,
                    onTransferTicket: () {},
                    onAcceptTicket: _apiCallForAcceptWebTicket,
                    onInProgressTicket: _showInProgressTicketDialog,
                    onHoldTicket: _showHoldTicketDialog,
                    onCloseTicket: () {},
                  ),
                ),
              ),

            if (_selectedTab == 'Action History')
              Expanded(
                child: SingleChildScrollView(
                  child: TicketDetailActionHistory(
                    pageTag: widget.pageTag,
                    actionHistoryList: viewTicketActionHistoryResponse,
                    ticketDetails: viewTicketDetailV6Response,
                    onActionSubmit: _submitReOpenReviewTicket,
                    onTransferTicket: () {},
                    onAcceptTicket: _apiCallForAcceptWebTicket,
                    onInProgressTicket: _showInProgressTicketDialog,
                    onHoldTicket: _showHoldTicketDialog,
                    onCloseTicket: () {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
