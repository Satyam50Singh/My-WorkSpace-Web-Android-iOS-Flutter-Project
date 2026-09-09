import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/add_new_request/ticket_location_category_usecase.dart';

import '../../../data/models/add_new_request/ticket_location_category_request.dart';

part 'add_new_ticket_event.dart';
part 'add_new_ticket_state.dart';

class AddNewTicketBloc extends Bloc<AddNewTicketEvent, AddNewTicketState> {
  final TicketLocationCategoryUseCase ticketLocationCategoryUseCase;

  AddNewTicketBloc(this.ticketLocationCategoryUseCase)
    : super(AddNewTicketInitial()) {
    on<FetchTicketLocationCategoryRequested>(
      _onFetchTicketLocationCategoryRequested,
    );
  }

  FutureOr<void> _onFetchTicketLocationCategoryRequested(
    FetchTicketLocationCategoryRequested event,
    Emitter<AddNewTicketState> emit,
  ) async {
    emit(AddNewTicketLoading());
    try {
      final result = await ticketLocationCategoryUseCase.call(
        payload: event.payload,
      );

      result.fold(
        (error) => emit(AddNewTicketFailure(error.message)),
        (data) => emit(TicketLocationCategorySuccess(data)),
      );
    } catch (e) {
      emit(AddNewTicketFailure(e.toString()));
    }
  }
}
