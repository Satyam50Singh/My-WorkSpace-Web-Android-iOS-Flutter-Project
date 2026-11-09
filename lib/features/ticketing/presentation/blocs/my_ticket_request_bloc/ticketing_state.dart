part of 'ticketing_bloc.dart';

abstract class TicketingState extends Equatable {
  const TicketingState();

  @override
  List<Object?> get props => [];
}

final class TicketingInitial extends TicketingState {}

final class TicketingLoading extends TicketingState {}

final class TicketingFailure extends TicketingState {
  final String errorMessage;

  const TicketingFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class TicketingMyRequestDetailSuccess extends TicketingState {
  final TicketDetailEntity ticketDetail;

  const TicketingMyRequestDetailSuccess(this.ticketDetail);

  @override
  List<Object?> get props => [ticketDetail];
}

final class TicketingExportSuccess extends TicketingState {
  final TicketDetailEntity ticketDetail;

  const TicketingExportSuccess(this.ticketDetail);

  @override
  List<Object?> get props => [ticketDetail];
}
