import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import '../../../domain/usecases/ticket_workflow_usecases/ticket_workflow_master_usecase.dart';

part 'ticket_workflow_master_event.dart';
part 'ticket_workflow_master_state.dart';

class TicketWorkflowMasterBloc
    extends Bloc<TicketWorkflowMasterEvent, TicketWorkflowMasterState> {
  final TicketWorkflowMasterUseCase _ticketWorkflowMasterUseCase;

  TicketWorkflowMasterBloc(this._ticketWorkflowMasterUseCase)
    : super(TicketWorkflowMasterInitial()) {
    on<TicketWorkflowListRequested>(_onTicketWorkflowListRequested);
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
}
