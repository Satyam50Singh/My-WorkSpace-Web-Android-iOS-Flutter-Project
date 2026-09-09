part of 'add_new_ticket_bloc.dart';

abstract class AddNewTicketState {}

final class AddNewTicketInitial extends AddNewTicketState {}

final class AddNewTicketLoading extends AddNewTicketState {}

final class AddNewTicketFailure extends AddNewTicketState {
  final String errorMessage;

  AddNewTicketFailure(this.errorMessage);
}

final class TicketLocationCategorySuccess extends AddNewTicketState {
  final TicketLocationCategoryEntity data;

  TicketLocationCategorySuccess(this.data);
}
