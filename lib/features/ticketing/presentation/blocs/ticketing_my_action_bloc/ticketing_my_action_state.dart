part of 'ticketing_my_action_bloc.dart';

abstract class TicketingMyActionState extends Equatable {
  const TicketingMyActionState();

  @override
  List<Object?> get props => [];
}

final class TicketingMyActionInitial extends TicketingMyActionState {}

final class TicketingMyActionLoading extends TicketingMyActionState {}

final class TicketTransferUserListLoading extends TicketingMyActionState {}

final class TicketingMyActionFailure extends TicketingMyActionState {
  final String errorMessage;

  const TicketingMyActionFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class TransferToOtherWorkflowFailure extends TicketingMyActionState {
  final String errorMessage;

  const TransferToOtherWorkflowFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class AcceptTicketSuccess extends TicketingMyActionState {
  final String message;

  const AcceptTicketSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UpdateTicketActionSuccess extends TicketingMyActionState {
  final String message;

  const UpdateTicketActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class TransferToOtherWorkflowSuccess extends TicketingMyActionState {
  final String message;

  const TransferToOtherWorkflowSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class TicketTransferUserListSuccess extends TicketingMyActionState {
  final List<TicketTransferUserListEntity> userList;

  const TicketTransferUserListSuccess({required this.userList});

  @override
  List<Object?> get props => [userList];
}
