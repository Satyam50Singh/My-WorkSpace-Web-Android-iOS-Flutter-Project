import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/transfer_ticket_web_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/update_ticket_action_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/submit_reopen_review_request.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_entities/ticket_history_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_entities/ticket_workflow_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_my_action_bloc/ticketing_my_action_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/view_ticket_details_bloc/view_ticket_details_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/ticket_action_dialog_utils.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_detail_action_history.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_detail_workflow.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/view_ticket_detail_header.dart';
import 'package:path/path.dart' as p;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/loader_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../data/models/add_new_request/app_multipart_file.dart';
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

  String performedAction = "";

  bool _shouldRefreshParent = false;

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
          TicketActionDialogUtils.showAlreadyAcceptedDialog(
            context: context,
            ticketDetail: viewTicketDetailV6Response!,
            onAcceptTicketPressed: (BuildContext ctx) {
              Navigator.of(ctx).pop();
              _apiCallForAcceptWebTicket(forceAccept: true);
            },
          );
        }
      }
    }
  }

  void _apiCallForUpdateTicketAction(
    String remarks,
    String action, {
    String? holdUntil,
    List<AppMultipartFile>? images,
  }) {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final payload = UpdateTicketActionRequestModel(
        ticketId: _cleanedTicketId,
        closeTicketDesc: remarks,
        ticketAction: action,
        empCD: employee.empCd,
        companyID: employee.companyId,
        platformType: _currentPlatform,
        holdTillDatetime: holdUntil ?? "",
        isImageUploaded: (images != null && images.isNotEmpty) ? 1 : 0,
        imageCount: images != null ? images.length : 0,
        currentLevel: viewTicketDetailV6Response?.level,
      );
      context.read<TicketingMyActionBloc>().add(
        UpdateTicketActionRequested(payload: payload, images: images),
      );
    }
  }

  void _showUpdateTicketActionDialog(String action) {
    if (action == "In Progress") {
      TicketActionDialogUtils.showUpdateTicketActionDialog(
        context,
        "In Progress Ticket",
        Icons.play_circle_outline,
        'Submit',
        'Enter remarks...',
        (remarks, holdUntil) {
          performedAction = "In Progress";
          _apiCallForUpdateTicketAction(remarks, "In Progress");
        },
      );
    } else if (action == "Hold") {
      TicketActionDialogUtils.showUpdateTicketActionDialog(
        context,
        "Hold Ticket",
        Icons.pause_circle_outline,
        'Submit Hold',
        'Enter hold remarks... ',
        (remarks, holdUntil) {
          performedAction = "Hold";
          _apiCallForUpdateTicketAction(remarks, "Hold", holdUntil: holdUntil);
        },
        color: AppColors.amberDark,
      );
    } else if (action == "Close") {
      TicketActionDialogUtils.showCloseTicketActionDialog(
        context,
        "Close Ticket",
        Icons.check_circle_outline,
        'Submit & Close',
        'Enter closure remarks... ',
        (remarks, selectedWebFiles, selectedFiles) {
          performedAction = "Close";
          final List<AppMultipartFile> imageFiles = [];
          if (kIsWeb) {
            if (selectedWebFiles == null) return;
            for (var file in selectedWebFiles) {
              imageFiles.add(
                AppMultipartFile(
                  name: file.keys.first,
                  bytes: file.values.first,
                ),
              );
            }
          } else {
            if (selectedFiles == null) return;
            for (var file in selectedFiles) {
              final ioFile = file.values.first!;
              imageFiles.add(
                AppMultipartFile(
                  name: p.basename(file.keys.first),
                  path: ioFile.path,
                ),
              );
            }
          }
          debugPrint('imageFiles = ${selectedFiles?.length}');
          debugPrint('imageFiles = ${selectedFiles?.length}');
          _apiCallForUpdateTicketAction(remarks, "Closed", images: imageFiles);
        },
        color: AppColors.btnBgGreen,
      );
    }
  }

  void _showTransferTicketActionDialog() {
    if (viewTicketDetailV6Response?.isActionAllowed == true) {
      // if (kIsWeb) {
        TicketActionDialogUtils.showTransferTicketActionDialog(
          buildContext: context,
          color: AppColors.btnBgRed,
          ticketId: viewTicketDetailV6Response?.ticketID,
          onTransferBtnPressed: (remarks, userCode) {
            debugPrint('remark = $remarks, userCode = $userCode');
            final state = context.read<EmployeeDetailCubit>().state;
            if (state is EmployeeDetailFetched) {
              final payload = TransferTicketWebRequestModel(
                ticketId: viewTicketDetailV6Response?.ticketID,
                remarks: remarks,
                empCD: state.employeeDetail.empCd,
                transferToUserId: userCode,
                companyID: state.employeeDetail.companyId,
                platformType: _currentPlatform,
              );

              debugPrint(payload.toString());
              performedAction = "Transferred";

              context.read<TicketingMyActionBloc>().add(
                TransferTicketWebRequested(payload: payload),
              );
            }
          },
        );
      // }
    } else if (viewTicketDetailV6Response?.isActionAllowed == true) {}
  }

  void reloadPage() {
    _fetchAllDetails();
  }

  void _handleBack() {
    context.pop(_shouldRefreshParent);
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
              _shouldRefreshParent = true;
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
              SnackBarUtils.showFloatingSnackBar(
                context,
                'Ticket Accepted Successfully.',
              );
              _shouldRefreshParent = true;
              reloadPage();
            } else if (state is UpdateTicketActionSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              LoaderUtils.hideLoader(context);
              SnackBarUtils.showFloatingSnackBar(
                context,
                '$performedAction Action performed successfully.',
              );
              _shouldRefreshParent = true;
              reloadPage();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _handleBack();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (viewTicketDetailV6Response != null)
              ViewTicketDetailHeader(
                ticketId: widget.ticketId,
                ticketStatus: viewTicketDetailV6Response?.ticketStatus,
                onBack: () {
                  _handleBack();
                },
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
                    onTransferTicket: _showTransferTicketActionDialog,
                    onAcceptTicket: _apiCallForAcceptWebTicket,
                    onUpdateTicketAction: (action) =>
                        _showUpdateTicketActionDialog(action),
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
                    onTransferTicket: _showTransferTicketActionDialog,
                    onAcceptTicket: _apiCallForAcceptWebTicket,
                    onUpdateTicketAction: (action) =>
                        _showUpdateTicketActionDialog(action),
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
                    onTransferTicket: _showTransferTicketActionDialog,
                    onAcceptTicket: _apiCallForAcceptWebTicket,
                    onUpdateTicketAction: (action) =>
                        _showUpdateTicketActionDialog(action),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
