import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import '../../../domain/usecases/ticket_sub_category_usecase/ticket_sub_category_master_usecase.dart';

part 'ticket_sub_category_master_event.dart';
part 'ticket_sub_category_master_state.dart';

class TicketSubCategoryMasterBloc
    extends Bloc<TicketSubCategoryMasterEvent, TicketSubCategoryMasterState> {
  final TicketSubCategoryMasterUseCase _subCategoryMasterUseCase;

  TicketSubCategoryMasterBloc(this._subCategoryMasterUseCase)
    : super(TicketSubCategoryMasterInitial()) {
    on<TicketSubCategoryListRequested>(_onTicketSubCategoryListRequested);
  }

  FutureOr<void> _onTicketSubCategoryListRequested(
    TicketSubCategoryListRequested event,
    Emitter<TicketSubCategoryMasterState> emit,
  ) async {
    emit(TicketSubCategoryMasterLoading());
    try {
      final result = await _subCategoryMasterUseCase.call(
        companyID: event.companyID,
      );
      result.fold(
        (error) =>
            emit(TicketSubCategoryMasterFailure(errorMessage: error.message)),
        (data) => emit(TicketSubCategoryMasterSuccess(subCategoryList: data)),
      );
    } catch (e) {
      emit(TicketSubCategoryMasterFailure(errorMessage: e.toString()));
    }
  }
}
