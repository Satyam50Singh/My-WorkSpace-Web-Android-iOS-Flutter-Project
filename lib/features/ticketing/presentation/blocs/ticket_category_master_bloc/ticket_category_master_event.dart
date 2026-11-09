part of 'ticket_category_master_bloc.dart';

abstract class TicketCategoryMasterEvent extends Equatable {
  const TicketCategoryMasterEvent();

  @override
  List<Object?> get props => [];
}

class TicketCategoryListRequested extends TicketCategoryMasterEvent {
  final int companyId;

  const TicketCategoryListRequested({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class DepartmentMasterListRequested extends TicketCategoryMasterEvent {
  final int companyId;

  const DepartmentMasterListRequested({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class InsertUpdateCategoryRequested extends TicketCategoryMasterEvent {
  final InsertUpdateTicketCategoryRequestModel payload;

  const InsertUpdateCategoryRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}
