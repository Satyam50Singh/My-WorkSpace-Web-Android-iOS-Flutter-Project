part of 'ticket_sub_category_master_bloc.dart';

abstract class TicketSubCategoryMasterState extends Equatable {
  const TicketSubCategoryMasterState();

  @override
  List<Object?> get props => [];
}

final class TicketSubCategoryMasterInitial
    extends TicketSubCategoryMasterState {}

final class TicketSubCategoryMasterLoading
    extends TicketSubCategoryMasterState {}

final class InsertSubCategoryMasterLoading
    extends TicketSubCategoryMasterState {}

final class DeleteTicketSubCategoryLoading
    extends TicketSubCategoryMasterState {}

final class TicketSubCategoryMasterFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  const TicketSubCategoryMasterFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class TicketSubCategoryMasterSuccess
    extends TicketSubCategoryMasterState {
  final List<SubCategoryMasterEntity> subCategoryList;

  const TicketSubCategoryMasterSuccess({required this.subCategoryList});

  @override
  List<Object?> get props => [subCategoryList];
}

final class InsertTicketSubCategorySuccess
    extends TicketSubCategoryMasterState {
  final String message;

  const InsertTicketSubCategorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class InsertTicketSubCategoryFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  const InsertTicketSubCategoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class UpdateTicketSubCategorySuccess
    extends TicketSubCategoryMasterState {
  final String message;

  const UpdateTicketSubCategorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UpdateTicketSubCategoryFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  const UpdateTicketSubCategoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class DeleteTicketSubCategorySuccess
    extends TicketSubCategoryMasterState {
  final String message;

  const DeleteTicketSubCategorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class DeleteTicketSubCategoryFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  const DeleteTicketSubCategoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
