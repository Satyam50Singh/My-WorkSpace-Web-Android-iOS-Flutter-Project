import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/update_ticket_action_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticketing_my_action_usecases/update_ticket_action_usecase.dart';

import '../../../data/models/add_new_request/app_multipart_file.dart';
import '../../../domain/usecases/ticketing_my_action_usecases/accept_web_ticket_usecase.dart';

part 'ticketing_my_action_event.dart';
part 'ticketing_my_action_state.dart';

class TicketingMyActionBloc
    extends Bloc<TicketingMyActionEvent, TicketingMyActionState> {
  final AcceptWebTicketUseCase _acceptWebTicketUseCase;
  final UpdateTicketActionUseCase _updateTicketActionUseCase;

  TicketingMyActionBloc(
    this._acceptWebTicketUseCase,
    this._updateTicketActionUseCase,
  ) : super(TicketingMyActionInitial()) {
    on<AcceptWebTicketRequested>(_onAcceptWebTicketRequested);
    on<UpdateTicketActionRequested>(_onUpdateTicketActionRequested);
  }

  FutureOr<void> _onAcceptWebTicketRequested(
    AcceptWebTicketRequested event,
    Emitter<TicketingMyActionState> emit,
  ) async {
    try {
      emit(TicketingMyActionLoading());
      final result = await _acceptWebTicketUseCase.call(payload: event.payload);
      result.fold(
        (failure) =>
            emit(TicketingMyActionFailure(errorMessage: failure.message)),
        (data) => emit(AcceptTicketSuccess(message: data)),
      );
    } catch (e) {
      emit(TicketingMyActionFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onUpdateTicketActionRequested(
    UpdateTicketActionRequested event,
    Emitter<TicketingMyActionState> emit,
  ) async {
    try {
      // emit(TicketingMyActionLoading());
      final result = await _updateTicketActionUseCase.call(
        payload: event.payload,
        images: event.images ?? [],
      );
      result.fold(
        (failure) =>
            emit(TicketingMyActionFailure(errorMessage: failure.message)),
        (data) => emit(UpdateTicketActionSuccess(message: data)),
      );
    } catch (e) {
      emit(TicketingMyActionFailure(errorMessage: e.toString()));
    }
  }
}
