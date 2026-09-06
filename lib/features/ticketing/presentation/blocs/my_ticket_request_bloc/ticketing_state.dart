part of 'ticketing_bloc.dart';

abstract class TicketingState {}

final class TicketingInitial extends TicketingState {}

final class TicketingLoading extends TicketingState {}

final class TicketingFailure extends TicketingState {
  final String errorMessage;

  TicketingFailure(this.errorMessage);
}

final class TicketingMyRequestDetailSuccess extends TicketingState {
  final TicketDetail ticketDetail;

  TicketingMyRequestDetailSuccess(this.ticketDetail);
}

final class TicketingExportSuccess extends TicketingState {
  final TicketDetail ticketDetail;

  TicketingExportSuccess(this.ticketDetail);
}
