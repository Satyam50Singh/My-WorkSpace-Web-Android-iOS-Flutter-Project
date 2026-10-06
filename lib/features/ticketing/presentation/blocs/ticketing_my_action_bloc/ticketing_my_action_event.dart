part of 'ticketing_my_action_bloc.dart';

abstract class TicketingMyActionEvent {}

class AcceptWebTicketRequested extends TicketingMyActionEvent {
  AcceptWebTicketRequestModel payload;

  AcceptWebTicketRequested({required this.payload});
}

class UpdateTicketActionRequested extends TicketingMyActionEvent {
  UpdateTicketActionRequestModel payload;
  List<AppMultipartFile>? images;

  UpdateTicketActionRequested({required this.payload, this.images});
}

class TicketTransferUserListRequested extends TicketingMyActionEvent {
  int ticketId;

  TicketTransferUserListRequested({required this.ticketId});
}

class TransferTicketWebRequested extends TicketingMyActionEvent {
  TransferTicketWebRequestModel payload;

  TransferTicketWebRequested({required this.payload});
}

class TransferToOtherWorkflowRequested extends TicketingMyActionEvent {
  TransferToOtherWorkflowRequestBody payload;

  TransferToOtherWorkflowRequested({required this.payload});
}
