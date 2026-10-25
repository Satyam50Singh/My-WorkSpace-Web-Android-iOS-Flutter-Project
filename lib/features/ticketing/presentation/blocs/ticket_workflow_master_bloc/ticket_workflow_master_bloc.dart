import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_workflow_usecases/fetch_ticket_workflow_details_web_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_workflow_usecases/insert_update_workflow_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_workflow_usecases/workflow_user_group_list_usecase.dart';

import '../../../domain/entities/ticket_workflow_entities/ticket_workflow_detail_entity.dart';
import '../../../domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import '../../../domain/usecases/ticket_workflow_usecases/ticket_workflow_master_usecase.dart';

part 'ticket_workflow_master_event.dart';
part 'ticket_workflow_master_state.dart';

class TicketWorkflowMasterBloc
    extends Bloc<TicketWorkflowMasterEvent, TicketWorkflowMasterState> {
  final TicketWorkflowMasterUseCase _ticketWorkflowMasterUseCase;
  final InsertUpdateWorkflowUseCase _insertUpdateWorkflowUseCase;
  final WorkflowUserGroupListUseCase _workflowUserGroupListUseCase;
  final FetchTicketWorkflowDetailsWebUseCase _ticketWorkflowDetailsWebUseCase;

  TicketWorkflowMasterBloc(
    this._ticketWorkflowMasterUseCase,
    this._insertUpdateWorkflowUseCase,
    this._workflowUserGroupListUseCase,
    this._ticketWorkflowDetailsWebUseCase,
  ) : super(TicketWorkflowMasterInitial()) {
    on<TicketWorkflowListRequested>(_onTicketWorkflowListRequested);
    on<DeleteWorkflowListRequested>(_onDeleteWorkflowListRequested);
    on<WorkflowUserGroupListRequested>(_onWorkflowUserGroupListRequested);
    on<InsertUpdateWorkflowListRequested>(_onInsertUpdateWorkflowListRequested);
    on<TicketWorkflowDetailByIDRequested>(_onTicketWorkflowDetailByIDRequested);
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

  FutureOr<void> _onWorkflowUserGroupListRequested(
    WorkflowUserGroupListRequested event,
    Emitter<TicketWorkflowMasterState> emit,
  ) async {
    emit(TicketWorkflowMasterLoading());

    try {
      final result = await _workflowUserGroupListUseCase.call(
        companyID: event.companyID,
      );
      result.fold(
        (error) =>
            emit(TicketWorkflowMasterFailure(errorMessage: error.message)),
        (data) => emit(WorkflowUserGroupMasterSuccess(data: data)),
      );
    } catch (e) {
      emit(TicketWorkflowMasterFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onInsertUpdateWorkflowListRequested(
    InsertUpdateWorkflowListRequested event,
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
        (data) => emit(InsertUpdateWorkflowMasterSuccess(message: data)),
      );
    } catch (e) {
      emit(TicketWorkflowMasterFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onTicketWorkflowDetailByIDRequested(
    TicketWorkflowDetailByIDRequested event,
    Emitter<TicketWorkflowMasterState> emit,
  ) async {
    emit(TicketWorkflowMasterLoading());

    try {
      final result = await _ticketWorkflowDetailsWebUseCase.call(
        companyID: event.companyID,
        workflowID: event.workflowID,
      );
      result.fold(
        (error) =>
            emit(TicketWorkflowDetailByIDFailure(errorMessage: error.message)),
        (data) => emit(TicketWorkflowDetailByIDSuccess(workflowDetail: data)),
      );
    } catch (e) {
      emit(TicketWorkflowMasterFailure(errorMessage: e.toString()));
    }
  }
}
