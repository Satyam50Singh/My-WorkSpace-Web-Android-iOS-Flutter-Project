part of 'ticket_sub_category_master_bloc.dart';

abstract class TicketSubCategoryMasterEvent extends Equatable {
  const TicketSubCategoryMasterEvent();

  @override
  List<Object?> get props => [];
}

class TicketSubCategoryListRequested extends TicketSubCategoryMasterEvent {
  final int companyId;

  const TicketSubCategoryListRequested({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class InsertUpdateSubCategoryRequested extends TicketSubCategoryMasterEvent {
  final InsertUpdateSubCategoryRequestModel payload;

  const InsertUpdateSubCategoryRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}