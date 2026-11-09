part of 'ticket_report_master_bloc.dart';

abstract class TicketReportMasterState extends Equatable {
  const TicketReportMasterState();

  @override
  List<Object?> get props => [];
}

final class TicketReportMasterInitial extends TicketReportMasterState {}

final class TicketReportMasterLoading extends TicketReportMasterState {}

final class FetchCatSubCatLocDeptTypeListSuccess
    extends TicketReportMasterState {
  final FetchCatSubCatLocDeptTypeListEntity? data;

  const FetchCatSubCatLocDeptTypeListSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

final class FetchCatSubCatLocDeptTypeListFailure
    extends TicketReportMasterState {
  final String errorMessage;

  const FetchCatSubCatLocDeptTypeListFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class FetchTicketReportWebSuccess extends TicketReportMasterState {
  final FetchTicketReportWebEntity? data;

  const FetchTicketReportWebSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

final class FetchTicketReportWebFailure extends TicketReportMasterState {
  final String errorMessage;

  const FetchTicketReportWebFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
