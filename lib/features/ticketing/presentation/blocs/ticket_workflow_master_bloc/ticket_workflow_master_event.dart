part of 'ticket_workflow_master_bloc.dart';

abstract class TicketWorkflowMasterEvent {}

class TicketWorkflowListRequested extends TicketWorkflowMasterEvent {
  final int companyID;

  TicketWorkflowListRequested({required this.companyID});
}
