part of 'ticketing_bloc.dart';

abstract class TicketingEvent {}

class TicketingMyRequestDetailRequested extends TicketingEvent {
  TicketMyRequestRequest? payload;

  TicketingMyRequestDetailRequested({this.payload});
}

class TicketingExportRequested extends TicketingEvent {
  TicketMyRequestRequest? payload;

  TicketingExportRequested({this.payload});
}
