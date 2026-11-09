part of 'ticket_workflow_master_bloc.dart';

abstract class TicketWorkflowMasterEvent extends Equatable {
  const TicketWorkflowMasterEvent();

  @override
  List<Object?> get props => [];
}

class TicketWorkflowListRequested extends TicketWorkflowMasterEvent {
  final int companyId;

  const TicketWorkflowListRequested({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class DeleteWorkflowListRequested extends TicketWorkflowMasterEvent {
  final InsertUpdateWorkflowRequestModel payload;

  const DeleteWorkflowListRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class WorkflowUserGroupListRequested extends TicketWorkflowMasterEvent {
  final int companyId;

  const WorkflowUserGroupListRequested({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class InsertUpdateWorkflowListRequested extends TicketWorkflowMasterEvent {
  final InsertUpdateWorkflowRequestModel payload;

  const InsertUpdateWorkflowListRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class TicketWorkflowDetailByIDRequested extends TicketWorkflowMasterEvent {
  final int companyId;
  final int workflowID;

  const TicketWorkflowDetailByIDRequested({
    required this.companyId,
    required this.workflowID,
  });

  @override
  List<Object?> get props => [companyId, workflowID];
}
