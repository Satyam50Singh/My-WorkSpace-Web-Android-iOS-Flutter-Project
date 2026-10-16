part of 'ticket_category_master_bloc.dart';

abstract class TicketCategoryMasterState {}

final class TicketCategoryMasterInitial extends TicketCategoryMasterState {}

final class TicketCategoryMasterLoading extends TicketCategoryMasterState {}

final class InsertCategoryMasterLoading extends TicketCategoryMasterState {}

final class DeleteTicketCategoryLoading extends TicketCategoryMasterState {}

final class DepartmentMasterListLoading extends TicketCategoryMasterState {}

final class TicketCategoryMasterFailure extends TicketCategoryMasterState {
  final String errorMessage;

  TicketCategoryMasterFailure({required this.errorMessage});
}

final class TicketCategoryMasterSuccess extends TicketCategoryMasterState {
  final List<TicketCategoryEntity> categoryList;

  TicketCategoryMasterSuccess({required this.categoryList});
}

final class DepartmentMasterListSuccess extends TicketCategoryMasterState {
  final List<DepartmentEntity> departmentList;

  DepartmentMasterListSuccess({required this.departmentList});
}

final class DepartmentMasterListFailure extends TicketCategoryMasterState {
  final String errorMessage;

  DepartmentMasterListFailure({required this.errorMessage});
}

final class DeleteTicketCategoryFailure extends TicketCategoryMasterState {
  final String errorMessage;

  DeleteTicketCategoryFailure({required this.errorMessage});
}

final class InsertTicketCategoryFailure extends TicketCategoryMasterState {
  final String errorMessage;

  InsertTicketCategoryFailure({required this.errorMessage});
}

final class UpdateTicketCategoryFailure extends TicketCategoryMasterState {
  final String errorMessage;

  UpdateTicketCategoryFailure({required this.errorMessage});
}

final class InsertTicketCategorySuccess extends TicketCategoryMasterState {
  final String message;

  InsertTicketCategorySuccess({required this.message});
}

final class UpdateTicketCategorySuccess extends TicketCategoryMasterState {
  final String message;

  UpdateTicketCategorySuccess({required this.message});
}

final class DeleteTicketCategorySuccess extends TicketCategoryMasterState {
  final String message;

  DeleteTicketCategorySuccess({required this.message});
}
