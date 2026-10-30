part of 'ticket_report_master_bloc.dart';

abstract class TicketReportMasterState {}

final class TicketReportMasterInitial extends TicketReportMasterState {}

final class TicketReportMasterLoading extends TicketReportMasterState {}

final class FetchCatSubCatLocDeptTypeListSuccess
    extends TicketReportMasterState {
  FetchCatSubCatLocDeptTypeListEntity? data;

  FetchCatSubCatLocDeptTypeListSuccess({this.data});
}

final class FetchCatSubCatLocDeptTypeListFailure
    extends TicketReportMasterState {
  final String errorMessage;

  FetchCatSubCatLocDeptTypeListFailure({required this.errorMessage});
}

final class FetchTicketReportWebSuccess extends TicketReportMasterState {
  FetchTicketReportWebEntity? data;

  FetchTicketReportWebSuccess({this.data});
}

final class FetchTicketReportWebFailure extends TicketReportMasterState {
  final String errorMessage;

  FetchTicketReportWebFailure({required this.errorMessage});
}
