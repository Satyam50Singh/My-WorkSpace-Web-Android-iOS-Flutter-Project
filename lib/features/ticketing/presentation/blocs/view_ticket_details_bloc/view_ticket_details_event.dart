part of 'view_ticket_details_bloc.dart';

abstract class ViewTicketDetailsEvent {}

class ViewTicketDetailsV6Requested extends ViewTicketDetailsEvent {
  final ViewTicketDetailRequest? payload;

  ViewTicketDetailsV6Requested({this.payload});
}

class ViewTicketWorkflowDetailsRequested extends ViewTicketDetailsEvent {
  final ViewTicketDetailRequest? payload;

  ViewTicketWorkflowDetailsRequested({this.payload});
}

class ViewTicketActionHistoryRequested extends ViewTicketDetailsEvent {
  final ViewTicketDetailRequest? payload;

  ViewTicketActionHistoryRequested({this.payload});
}
