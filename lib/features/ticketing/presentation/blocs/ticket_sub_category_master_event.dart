part of 'ticket_sub_category_master_bloc.dart';

abstract class TicketSubCategoryMasterEvent {}

class TicketSubCategoryListRequested extends TicketSubCategoryMasterEvent {
  final int companyID;

  TicketSubCategoryListRequested({required this.companyID});
}