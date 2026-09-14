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

final class FetchTicketWorkFlowDetailsRequested extends AddNewTicketEvent {
  int categoryID;
  int subCategoryID;

  FetchTicketWorkFlowDetailsRequested(this.categoryID, this.subCategoryID);
}

final class AddNewTicketSubmitted extends AddNewTicketEvent {
  AddNewTicketRequestModel payload;
  List<AppMultipartFile> imageFiles;

  AddNewTicketSubmitted(this.payload, this.imageFiles);
}