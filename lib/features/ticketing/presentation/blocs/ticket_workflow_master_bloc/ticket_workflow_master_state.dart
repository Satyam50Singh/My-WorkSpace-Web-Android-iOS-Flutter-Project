part of 'ticket_workflow_master_bloc.dart';

abstract class TicketWorkflowMasterState extends Equatable {
  const TicketWorkflowMasterState();

  @override
  List<Object?> get props => [];
}

final class TicketWorkflowMasterInitial extends TicketWorkflowMasterState {}

final class TicketWorkflowMasterLoading extends TicketWorkflowMasterState {}

final class TicketWorkflowMasterFailure extends TicketWorkflowMasterState {
  final String errorMessage;

  const TicketWorkflowMasterFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class TicketWorkflowMasterSuccess extends TicketWorkflowMasterState {
  final List<TicketWorkflowMasterEntity>? ticketWorkflowList;

  const TicketWorkflowMasterSuccess({this.ticketWorkflowList});

  @override
  List<Object?> get props => [ticketWorkflowList];
}

final class DeleteWorkflowMasterSuccess extends TicketWorkflowMasterState {
  final String message;

  const DeleteWorkflowMasterSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class WorkflowUserGroupMasterSuccess extends TicketWorkflowMasterState {
  final WorkflowUserGroupListEntity? data;

  const WorkflowUserGroupMasterSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

final class InsertUpdateWorkflowMasterSuccess extends TicketWorkflowMasterState {
  final String message;

  const InsertUpdateWorkflowMasterSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class TicketWorkflowDetailByIDFailure extends TicketWorkflowMasterState {
  final String errorMessage;

  const TicketWorkflowDetailByIDFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class TicketWorkflowDetailByIDSuccess extends TicketWorkflowMasterState {
  final TicketWorkflowDetailEntity? workflowDetail;

  const TicketWorkflowDetailByIDSuccess({this.workflowDetail});

  @override
  List<Object?> get props => [workflowDetail];
}
