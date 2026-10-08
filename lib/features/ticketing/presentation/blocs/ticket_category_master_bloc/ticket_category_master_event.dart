part of 'ticket_category_master_bloc.dart';

abstract class TicketCategoryMasterEvent {}

class TicketCategoryListRequested extends TicketCategoryMasterEvent {
  final int companyID;

  TicketCategoryListRequested({required this.companyID});
}
