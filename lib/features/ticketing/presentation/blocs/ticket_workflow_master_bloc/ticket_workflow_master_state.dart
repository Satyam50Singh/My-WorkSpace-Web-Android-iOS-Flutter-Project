part of 'ticket_workflow_master_bloc.dart';

abstract class TicketWorkflowMasterState {}

final class TicketWorkflowMasterInitial extends TicketWorkflowMasterState {}

final class TicketWorkflowMasterLoading extends TicketWorkflowMasterState {}

final class TicketWorkflowMasterFailure extends TicketWorkflowMasterState {
  final String errorMessage;

  TicketWorkflowMasterFailure({required this.errorMessage});
}

final class TicketWorkflowMasterSuccess extends TicketWorkflowMasterState {
  final List<TicketWorkflowMasterEntity>? ticketWorkflowList;

  TicketWorkflowMasterSuccess({this.ticketWorkflowList});
}

final class DeleteWorkflowMasterSuccess extends TicketWorkflowMasterState {
  final String message;

  DeleteWorkflowMasterSuccess({required this.message});
}

final class WorkflowUserGroupMasterSuccess extends TicketWorkflowMasterState {
  final WorkflowUserGroupListEntity? data;

  WorkflowUserGroupMasterSuccess({required this.data});
}

final class InsertUpdateWorkflowMasterSuccess extends TicketWorkflowMasterState {
  final String message;

  InsertUpdateWorkflowMasterSuccess({required this.message});
}
