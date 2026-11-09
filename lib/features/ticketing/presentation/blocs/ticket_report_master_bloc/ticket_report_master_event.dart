part of 'ticket_report_master_bloc.dart';

abstract class TicketReportMasterEvent extends Equatable {
  const TicketReportMasterEvent();

  @override
  List<Object?> get props => [];
}

class FetchCatSubCatLocDeptTypeListRequested extends TicketReportMasterEvent {
  final int companyId;

  const FetchCatSubCatLocDeptTypeListRequested({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class FetchTicketReportWebRequested extends TicketReportMasterEvent {
  final FetchTicketReportWebRequestModel payload;

  const FetchTicketReportWebRequested({required this.payload});

  @override
  List<Object?> get props => [payload];
}
