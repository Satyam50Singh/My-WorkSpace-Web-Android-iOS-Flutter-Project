part of 'ticket_sub_category_master_bloc.dart';

abstract class TicketSubCategoryMasterState {}

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

  TicketSubCategoryMasterFailure({required this.errorMessage});
}

final class TicketSubCategoryMasterSuccess
    extends TicketSubCategoryMasterState {
  final List<SubCategoryMasterEntity> subCategoryList;

  TicketSubCategoryMasterSuccess({required this.subCategoryList});
}

final class InsertTicketSubCategorySuccess
    extends TicketSubCategoryMasterState {
  final String message;

  InsertTicketSubCategorySuccess({required this.message});
}

final class InsertTicketSubCategoryFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  InsertTicketSubCategoryFailure({required this.errorMessage});
}

final class UpdateTicketSubCategorySuccess
    extends TicketSubCategoryMasterState {
  final String message;

  UpdateTicketSubCategorySuccess({required this.message});
}

final class UpdateTicketSubCategoryFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  UpdateTicketSubCategoryFailure({required this.errorMessage});
}

final class DeleteTicketSubCategorySuccess
    extends TicketSubCategoryMasterState {
  final String message;

  DeleteTicketSubCategorySuccess({required this.message});
}

final class DeleteTicketSubCategoryFailure
    extends TicketSubCategoryMasterState {
  final String errorMessage;

  DeleteTicketSubCategoryFailure({required this.errorMessage});
}
