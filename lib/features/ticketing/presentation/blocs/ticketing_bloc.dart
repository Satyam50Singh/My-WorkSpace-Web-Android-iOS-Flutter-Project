import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_my_request_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticketing_my_request_usecase.dart';

import '../../domain/entities/ticket_detail.dart';

part 'ticketing_event.dart';
part 'ticketing_state.dart';

class TicketingBloc extends Bloc<TicketingEvent, TicketingState> {
  final TicketingMyRequestUseCase _ticketingUseCase;

  TicketingBloc(this._ticketingUseCase) : super(TicketingInitial()) {
    on<TicketingMyRequestDetailRequested>(_onTicketingMyRequestDetailRequested);
  }

  FutureOr<void> _onTicketingMyRequestDetailRequested(
    TicketingMyRequestDetailRequested event,
    Emitter<TicketingState> emit,
  ) async {
    emit(TicketingLoading());
    try {
      if (event.payload != null) {
        final result = await _ticketingUseCase(payload: event.payload!);

        result.fold(
          (failure) => emit(TicketingFailure(failure.message)),
          (myRequestDetails) =>
              emit(TicketingMyRequestDetailSuccess(myRequestDetails)),
        );
      } else {
        emit(TicketingFailure('Payload is null'));
      }
    } catch (e) {
      emit(TicketingFailure(e.toString()));
    }
  }
}
