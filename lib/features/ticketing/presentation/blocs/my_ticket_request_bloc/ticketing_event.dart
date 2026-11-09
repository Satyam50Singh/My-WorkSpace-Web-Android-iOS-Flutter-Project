part of 'ticketing_bloc.dart';

abstract class TicketingEvent extends Equatable {
  const TicketingEvent();

  @override
  List<Object?> get props => [];
}

class TicketingMyRequestDetailRequested extends TicketingEvent {
  final TicketMyRequestRequest? payload;

  const TicketingMyRequestDetailRequested({this.payload});

  @override
  List<Object?> get props => [payload];
}

class TicketingExportRequested extends TicketingEvent {
  final TicketMyRequestRequest? payload;

  const TicketingExportRequested({this.payload});

  @override
  List<Object?> get props => [payload];
}
