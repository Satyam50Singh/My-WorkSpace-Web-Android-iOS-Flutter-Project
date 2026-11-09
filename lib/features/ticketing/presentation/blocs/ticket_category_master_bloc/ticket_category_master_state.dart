part of 'ticket_category_master_bloc.dart';

abstract class TicketCategoryMasterState extends Equatable {
  const TicketCategoryMasterState();

  @override
  List<Object?> get props => [];
}

final class TicketCategoryMasterInitial extends TicketCategoryMasterState {}

final class TicketCategoryMasterLoading extends TicketCategoryMasterState {}

final class InsertCategoryMasterLoading extends TicketCategoryMasterState {}

final class DeleteTicketCategoryLoading extends TicketCategoryMasterState {}

final class DepartmentMasterListLoading extends TicketCategoryMasterState {}

final class TicketCategoryMasterFailure extends TicketCategoryMasterState {
  final String errorMessage;

  const TicketCategoryMasterFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class TicketCategoryMasterSuccess extends TicketCategoryMasterState {
  final List<TicketCategoryEntity> categoryList;

  const TicketCategoryMasterSuccess({required this.categoryList});

  @override
  List<Object?> get props => [categoryList];
}

final class DepartmentMasterListSuccess extends TicketCategoryMasterState {
  final List<DepartmentEntity> departmentList;

  const DepartmentMasterListSuccess({required this.departmentList});

  @override
  List<Object?> get props => [departmentList];
}

final class DepartmentMasterListFailure extends TicketCategoryMasterState {
  final String errorMessage;

  const DepartmentMasterListFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class DeleteTicketCategoryFailure extends TicketCategoryMasterState {
  final String errorMessage;

  const DeleteTicketCategoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class InsertTicketCategoryFailure extends TicketCategoryMasterState {
  final String errorMessage;

  const InsertTicketCategoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class UpdateTicketCategoryFailure extends TicketCategoryMasterState {
  final String errorMessage;

  const UpdateTicketCategoryFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class InsertTicketCategorySuccess extends TicketCategoryMasterState {
  final String message;

  const InsertTicketCategorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class UpdateTicketCategorySuccess extends TicketCategoryMasterState {
  final String message;

  const UpdateTicketCategorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class DeleteTicketCategorySuccess extends TicketCategoryMasterState {
  final String message;

  const DeleteTicketCategorySuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
