import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_report_entities/fetch_cat_sub_cat_loc_dept_type_list_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_report_usecases/fetch_cat_sub_cat_loc_dept_type_list_usecase.dart';

import '../../../data/models/ticket_report_models/fetch_ticket_report_web_request_model.dart';
import '../../../domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import '../../../domain/usecases/ticket_report_usecases/fetch_ticket_report_web_usecase.dart';

part 'ticket_report_master_event.dart';
part 'ticket_report_master_state.dart';

class TicketReportMasterBloc
    extends Bloc<TicketReportMasterEvent, TicketReportMasterState> {
  final FetchCatSubCatLocDeptTypeListUseCase _catSubCatLocDeptTypeListUseCase;
  final FetchTicketReportWebUseCase _fetchTicketReportWebUseCase;

  TicketReportMasterBloc(
    this._catSubCatLocDeptTypeListUseCase,
    this._fetchTicketReportWebUseCase,
  ) : super(TicketReportMasterInitial()) {
    on<FetchCatSubCatLocDeptTypeListRequested>(
      _onFetchCatSubCatLocDeptTypeListRequested,
    );
    on<FetchTicketReportWebRequested>(_onFetchTicketReportWebRequested);
  }

  FutureOr<void> _onFetchCatSubCatLocDeptTypeListRequested(
    FetchCatSubCatLocDeptTypeListRequested event,
    Emitter<TicketReportMasterState> emit,
  ) async {
    emit(TicketReportMasterLoading());
    try {
      final result = await _catSubCatLocDeptTypeListUseCase.call(
        companyID: event.companyID,
      );
      result.fold(
        (error) => emit(
          FetchCatSubCatLocDeptTypeListFailure(errorMessage: error.message),
        ),
        (data) => emit(FetchCatSubCatLocDeptTypeListSuccess(data: data)),
      );
    } catch (e) {
      emit(FetchCatSubCatLocDeptTypeListFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onFetchTicketReportWebRequested(
    FetchTicketReportWebRequested event,
    Emitter<TicketReportMasterState> emit,
  ) async {
    emit(TicketReportMasterLoading());
    try {
      final result = await _fetchTicketReportWebUseCase.call(
        payload: event.payload,
      );
      result.fold(
        (error) =>
            emit(FetchTicketReportWebFailure(errorMessage: error.message)),
        (data) => emit(FetchTicketReportWebSuccess(data: data)),
      );
    } catch (e) {
      emit(FetchTicketReportWebFailure(errorMessage: e.toString()));
    }
  }
}
