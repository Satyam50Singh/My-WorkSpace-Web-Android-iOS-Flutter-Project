part of 'ticket_report_master_bloc.dart';

abstract class TicketReportMasterEvent {}

class FetchCatSubCatLocDeptTypeListRequested extends TicketReportMasterEvent {
  final int companyID;

  FetchCatSubCatLocDeptTypeListRequested({required this.companyID});
}

class FetchTicketReportWebRequested extends TicketReportMasterEvent {
  final FetchTicketReportWebRequestModel payload;

  FetchTicketReportWebRequested({required this.payload});
}
