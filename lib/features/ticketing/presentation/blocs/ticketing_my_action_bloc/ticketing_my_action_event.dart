part of 'ticketing_my_action_bloc.dart';

abstract class TicketingMyActionEvent extends Equatable {
  const TicketingMyActionEvent();

  @override
  List<Object?> get props => [];
}

class AcceptWebTicketRequested extends TicketingMyActionEvent {
  final AcceptWebTicketRequestModel payload;

  const AcceptWebTicketRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class UpdateTicketActionRequested extends TicketingMyActionEvent {
  final UpdateTicketActionRequestModel payload;
  final List<AppMultipartFile>? images;

  const UpdateTicketActionRequested({required this.payload, this.images});

  @override
  List<Object?> get props => [payload, images];
}

class TicketTransferUserListRequested extends TicketingMyActionEvent {
  final int ticketId;

  const TicketTransferUserListRequested({required this.ticketId});

  @override
  List<Object?> get props => [ticketId];
}

class TransferTicketWebRequested extends TicketingMyActionEvent {
  final TransferTicketWebRequestModel payload;

  const TransferTicketWebRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class TransferToOtherWorkflowRequested extends TicketingMyActionEvent {
  final TransferToOtherWorkflowRequestBody payload;

  const TransferToOtherWorkflowRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}
