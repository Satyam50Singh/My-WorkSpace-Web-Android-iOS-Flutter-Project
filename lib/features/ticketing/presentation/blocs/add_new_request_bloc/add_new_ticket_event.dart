part of 'add_new_ticket_bloc.dart';

abstract class AddNewTicketEvent extends Equatable {
  const AddNewTicketEvent();

  @override
  List<Object?> get props => [];
}

final class FetchTicketLocationCategoryRequested extends AddNewTicketEvent {
  final TicketLocationCategoryRequest payload;

  const FetchTicketLocationCategoryRequested(this.payload);

  @override
  List<Object?> get props => [payload];
}

final class FetchTicketSubCategoryRequested extends AddNewTicketEvent {
  final int categoryID;

  const FetchTicketSubCategoryRequested(this.categoryID);

  @override
  List<Object?> get props => [categoryID];
}

final class FetchTicketWorkFlowDetailsRequested extends AddNewTicketEvent {
  final int categoryID;
  final int subCategoryID;

  const FetchTicketWorkFlowDetailsRequested(this.categoryID, this.subCategoryID);

  @override
  List<Object?> get props => [categoryID, subCategoryID];
}

final class AddNewTicketSubmitted extends AddNewTicketEvent {
  final AddNewTicketRequestModel payload;
  final List<AppMultipartFile> imageFiles;

  const AddNewTicketSubmitted(this.payload, this.imageFiles);

  @override
  List<Object?> get props => [payload, imageFiles];
}