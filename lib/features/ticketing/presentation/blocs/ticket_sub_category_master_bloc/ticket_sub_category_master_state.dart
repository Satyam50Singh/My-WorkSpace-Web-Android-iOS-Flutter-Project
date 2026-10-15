part of 'ticket_sub_category_master_bloc.dart';

@immutable
sealed class TicketSubCategoryMasterState {}

final class TicketSubCategoryMasterInitial extends TicketSubCategoryMasterState {}


final class TicketSubCategoryMasterLoading extends TicketSubCategoryMasterState {}

final class TicketSubCategoryMasterFailure extends TicketSubCategoryMasterState {
  final String errorMessage;

  TicketSubCategoryMasterFailure({required this.errorMessage});
}

final class TicketSubCategoryMasterSuccess extends TicketSubCategoryMasterState {
  final List<SubCategoryMasterEntity> subCategoryList;

  TicketSubCategoryMasterSuccess({required this.subCategoryList});
}

final class InsertUpdateSubCategorySuccess extends TicketSubCategoryMasterState {
  final String message;

  InsertUpdateSubCategorySuccess({required this.message});
}

final class InsertUpdateSubCategoryFailure extends TicketSubCategoryMasterState {
  final String errorMessage;

  InsertUpdateSubCategoryFailure({required this.errorMessage});
}