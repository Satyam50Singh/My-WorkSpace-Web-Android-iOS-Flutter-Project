part of 'ticketing_bloc.dart';

abstract class TicketingEvent {}

class TicketingMyRequestDetailRequested extends TicketingEvent {
  TicketMyRequestRequest? payload;

  TicketingMyRequestDetailRequested({this.payload});
}
