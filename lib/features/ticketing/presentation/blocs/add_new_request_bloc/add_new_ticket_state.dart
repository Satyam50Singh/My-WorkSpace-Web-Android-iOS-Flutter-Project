part of 'add_new_ticket_bloc.dart';

abstract class AddNewTicketState {}

final class AddNewTicketInitial extends AddNewTicketState {}

final class AddNewTicketLoading extends AddNewTicketState {}

final class TicketWorkFlowDetailsLoading extends AddNewTicketState {}

final class AddNewTicketSubmitLoading extends AddNewTicketState {}

final class AddNewTicketFailure extends AddNewTicketState {
  final String errorMessage;

  AddNewTicketFailure(this.errorMessage);
}

final class TicketLocationCategorySuccess extends AddNewTicketState {
  final TicketLocationCategoryEntity data;

  TicketLocationCategorySuccess(this.data);
}

final class TicketSubCategorySuccess extends AddNewTicketState {
  final TicketSubCategoryEntity data;

  TicketSubCategorySuccess(this.data);
}

final class TicketWorkFlowDetailsSuccess extends AddNewTicketState {
  final TicketWorkflowDetailsEntity data;

  TicketWorkFlowDetailsSuccess(this.data);
}

final class AddNewTicketSubmitSuccess extends AddNewTicketState {
  final AddNewTicketRequestEntity data;

  AddNewTicketSubmitSuccess(this.data);
}
