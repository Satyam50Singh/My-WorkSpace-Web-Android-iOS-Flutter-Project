import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/submit_reopen_review_request.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/submit_reopen_review_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_v6.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/submit_reopen_review_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_action_history_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_workflow_usecase.dart';

import '../../../domain/entities/ticket_history_entity.dart';
import '../../../domain/entities/ticket_workflow_entity.dart';
import '../../../domain/usecases/view_ticket_detail_v6_usecase.dart';

part 'view_ticket_details_event.dart';
part 'view_ticket_details_state.dart';

class ViewTicketDetailsBloc
    extends Bloc<ViewTicketDetailsEvent, ViewTicketDetailsState> {
  final ViewTicketDetailV6UseCase _detailV6UseCase;
  final TicketActionHistoryUseCase _actionHistoryUseCase;
  final TicketWorkflowUseCase _workflowUseCase;
  final SubmitReopenReviewUseCase _submitReopenReviewUseCase;

  ViewTicketDetailsBloc(
    this._detailV6UseCase,
    this._actionHistoryUseCase,
    this._workflowUseCase,
    this._submitReopenReviewUseCase,
  ) : super(ViewTicketDetailsInitial()) {
    on<ViewTicketDetailsV6Requested>(_onViewTicketDetailsV6Requested);
    on<ViewTicketWorkflowDetailsRequested>(
      _onViewTicketWorkflowDetailsRequested,
    );
    on<ViewTicketActionHistoryRequested>(_onViewTicketActionHistoryRequested);
    on<SubmitReopenReviewTicketRequested>(_onSubmitReopenReviewTicketRequested);
  }

  FutureOr<void> _onViewTicketDetailsV6Requested(
    ViewTicketDetailsV6Requested event,
    Emitter<ViewTicketDetailsState> emit,
  ) async {
    emit(ViewTicketDetailsLoading());
    try {
      if (event.payload != null) {
        final result = await _detailV6UseCase(payload: event.payload!);
        result.fold(
          (failure) => emit(ViewTicketDetailsFailure(failure.message)),
          (response) => emit(ViewTicketDetailsV6Success(response)),
        );
      } else {
        emit(ViewTicketDetailsFailure('Payload is null'));
      }
    } catch (e) {
      emit(ViewTicketDetailsFailure(e.toString()));
    }
  }

  FutureOr<void> _onViewTicketWorkflowDetailsRequested(
    ViewTicketWorkflowDetailsRequested event,
    Emitter<ViewTicketDetailsState> emit,
  ) async {
    emit(ViewTicketDetailsLoading());
    try {
      if (event.payload != null) {
        final result = await _workflowUseCase(payload: event.payload!);
        result.fold(
          (failure) => emit(ViewTicketDetailsFailure(failure.message)),
          (response) => emit(ViewTicketWorkflowDetailsSuccess(response)),
        );
      } else {
        emit(ViewTicketDetailsFailure('Payload is null'));
      }
    } catch (e) {
      emit(ViewTicketDetailsFailure(e.toString()));
    }
  }

  FutureOr<void> _onViewTicketActionHistoryRequested(
    ViewTicketActionHistoryRequested event,
    Emitter<ViewTicketDetailsState> emit,
  ) async {
    emit(ViewTicketDetailsLoading());
    try {
      if (event.payload != null) {
        final result = await _actionHistoryUseCase(payload: event.payload!);
        result.fold(
          (failure) => emit(ViewTicketDetailsFailure(failure.message)),
          (response) => emit(ViewTicketActionHistorySuccess(response)),
        );
      } else {
        emit(ViewTicketDetailsFailure('Payload is null'));
      }
    } catch (e) {
      emit(ViewTicketDetailsFailure(e.toString()));
    }
  }

  FutureOr<void> _onSubmitReopenReviewTicketRequested(
    SubmitReopenReviewTicketRequested event,
    Emitter<ViewTicketDetailsState> emit,
  ) async {
    emit(ViewTicketDetailsLoading());
    try {
      if (event.payload != null) {
        final result = await _submitReopenReviewUseCase(
          payload: event.payload!,
        );
        result.fold(
          (failure) => emit(ViewTicketDetailsFailure(failure.message)),
          (response) => emit(SubmitReopenReviewSuccess(response)),
        );
      } else {
        emit(ViewTicketDetailsFailure('Payload is null'));
      }
    } catch (e) {
      emit(ViewTicketDetailsFailure(e.toString()));
    }
  }
}
