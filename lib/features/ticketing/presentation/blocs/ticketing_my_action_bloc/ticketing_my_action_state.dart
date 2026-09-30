part of 'ticketing_my_action_bloc.dart';

abstract class TicketingMyActionState {}

final class TicketingMyActionInitial extends TicketingMyActionState {}

final class TicketingMyActionLoading extends TicketingMyActionState {}

final class TicketingMyActionFailure extends TicketingMyActionState {
  final String errorMessage;

  TicketingMyActionFailure({required this.errorMessage});
}

final class AcceptTicketSuccess extends TicketingMyActionState {
  final String message;

  AcceptTicketSuccess({required this.message});
}

final class UpdateTicketActionSuccess extends TicketingMyActionState {
  final String message;

  UpdateTicketActionSuccess({required this.message});
}
