part of 'ticket_category_master_bloc.dart';

abstract class TicketCategoryMasterState {}

final class TicketCategoryMasterInitial extends TicketCategoryMasterState {}

final class TicketCategoryMasterLoading extends TicketCategoryMasterState {}

final class TicketCategoryMasterFailure extends TicketCategoryMasterState {
  final String errorMessage;

  TicketCategoryMasterFailure({required this.errorMessage});
}

final class TicketCategoryMasterSuccess extends TicketCategoryMasterState {
  final List<TicketCategoryEntity> categoryList;

  TicketCategoryMasterSuccess({required this.categoryList});
}
