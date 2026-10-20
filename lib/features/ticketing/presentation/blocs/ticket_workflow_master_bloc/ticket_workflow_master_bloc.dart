import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_workflow_usecases/insert_update_workflow_usecase.dart';

import '../../../domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import '../../../domain/usecases/ticket_workflow_usecases/ticket_workflow_master_usecase.dart';

part 'ticket_workflow_master_event.dart';
part 'ticket_workflow_master_state.dart';

class TicketWorkflowMasterBloc
    extends Bloc<TicketWorkflowMasterEvent, TicketWorkflowMasterState> {
  final TicketWorkflowMasterUseCase _ticketWorkflowMasterUseCase;
  final InsertUpdateWorkflowUseCase _insertUpdateWorkflowUseCase;

  TicketWorkflowMasterBloc(
    this._ticketWorkflowMasterUseCase,
    this._insertUpdateWorkflowUseCase,
  ) : super(TicketWorkflowMasterInitial()) {
    on<TicketWorkflowListRequested>(_onTicketWorkflowListRequested);
    on<DeleteWorkflowListRequested>(_onDeleteWorkflowListRequested);
  }

  FutureOr<void> _onTicketWorkflowListRequested(
    TicketWorkflowListRequested event,
    Emitter<TicketWorkflowMasterState> emit,
  ) async {
    emit(TicketWorkflowMasterLoading());

    try {
      final result = await _ticketWorkflowMasterUseCase.call(
        companyID: event.companyID,
      );
      result.fold(
        (error) =>
            emit(TicketWorkflowMasterFailure(errorMessage: error.message)),
        (data) => emit(TicketWorkflowMasterSuccess(ticketWorkflowList: data)),
      );
    } catch (e) {
      emit(TicketWorkflowMasterFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onDeleteWorkflowListRequested(
    DeleteWorkflowListRequested event,
    Emitter<TicketWorkflowMasterState> emit,
  ) async {
    emit(TicketWorkflowMasterLoading());

    try {
      final result = await _insertUpdateWorkflowUseCase.call(
        payload: event.payload,
      );
      result.fold(
        (error) =>
            emit(TicketWorkflowMasterFailure(errorMessage: error.message)),
        (data) => emit(DeleteWorkflowMasterSuccess(message: data)),
      );
    } catch (e) {
      emit(TicketWorkflowMasterFailure(errorMessage: e.toString()));
    }
  }
}
