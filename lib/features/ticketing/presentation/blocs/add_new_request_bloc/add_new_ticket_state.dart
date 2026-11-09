part of 'add_new_ticket_bloc.dart';

abstract class AddNewTicketState extends Equatable {
  const AddNewTicketState();

  @override
  List<Object?> get props => [];
}

final class AddNewTicketInitial extends AddNewTicketState {}

final class AddNewTicketLoading extends AddNewTicketState {}

final class TicketWorkFlowDetailsLoading extends AddNewTicketState {}

final class AddNewTicketSubmitLoading extends AddNewTicketState {}

final class AddNewTicketFailure extends AddNewTicketState {
  final String errorMessage;

  const AddNewTicketFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class TicketLocationCategorySuccess extends AddNewTicketState {
  final TicketLocationCategoryEntity data;

  const TicketLocationCategorySuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class TicketSubCategorySuccess extends AddNewTicketState {
  final TicketSubCategoryEntity data;

  const TicketSubCategorySuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class TicketWorkFlowDetailsSuccess extends AddNewTicketState {
  final TicketWorkflowDetailsEntity data;

  const TicketWorkFlowDetailsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class AddNewTicketSubmitSuccess extends AddNewTicketState {
  final AddNewTicketRequestEntity data;

  const AddNewTicketSubmitSuccess(this.data);

  @override
  List<Object?> get props => [data];
}
