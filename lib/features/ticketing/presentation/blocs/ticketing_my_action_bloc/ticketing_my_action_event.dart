part of 'ticketing_my_action_bloc.dart';

abstract class TicketingMyActionEvent {}

class AcceptWebTicketRequested extends TicketingMyActionEvent {
  AcceptWebTicketRequestModel payload;

  AcceptWebTicketRequested({required this.payload});
}

class UpdateTicketActionRequested extends TicketingMyActionEvent {
  UpdateTicketActionRequestModel payload;

  UpdateTicketActionRequested({required this.payload});
}
