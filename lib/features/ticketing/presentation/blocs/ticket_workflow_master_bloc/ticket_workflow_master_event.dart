part of 'ticket_workflow_master_bloc.dart';

abstract class TicketWorkflowMasterEvent {}

class TicketWorkflowListRequested extends TicketWorkflowMasterEvent {
  final int companyID;

  TicketWorkflowListRequested({required this.companyID});
}

class DeleteWorkflowListRequested extends TicketWorkflowMasterEvent {
  final InsertUpdateWorkflowRequestModel payload;

  DeleteWorkflowListRequested({required this.payload});
}

class WorkflowUserGroupListRequested extends TicketWorkflowMasterEvent {
  final int companyID;

  WorkflowUserGroupListRequested({required this.companyID});
}

class InsertUpdateWorkflowListRequested extends TicketWorkflowMasterEvent {
  final InsertUpdateWorkflowRequestModel payload;

  InsertUpdateWorkflowListRequested({required this.payload});
}

class TicketWorkflowDetailByIDRequested extends TicketWorkflowMasterEvent {
  final int companyID;
  final int workflowID;

  TicketWorkflowDetailByIDRequested({
    required this.companyID,
    required this.workflowID,
  });
}
