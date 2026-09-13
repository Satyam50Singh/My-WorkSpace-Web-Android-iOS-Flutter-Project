part of 'add_new_ticket_bloc.dart';

abstract class AddNewTicketEvent {}

final class FetchTicketLocationCategoryRequested extends AddNewTicketEvent {
  TicketLocationCategoryRequest payload;

  FetchTicketLocationCategoryRequested(this.payload);
}

final class FetchTicketSubCategoryRequested extends AddNewTicketEvent {
  int categoryID;

  FetchTicketSubCategoryRequested(this.categoryID);
}