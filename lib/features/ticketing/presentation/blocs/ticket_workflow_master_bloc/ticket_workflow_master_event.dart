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
