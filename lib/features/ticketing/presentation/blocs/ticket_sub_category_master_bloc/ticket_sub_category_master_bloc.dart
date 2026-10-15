import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_sub_category_models/insert_update_sub_category_request_model.dart';

import '../../../domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import '../../../domain/usecases/ticket_sub_category_usecase/insert_update_sub_category_usecase.dart';
import '../../../domain/usecases/ticket_sub_category_usecase/ticket_sub_category_master_usecase.dart';

part 'ticket_sub_category_master_event.dart';
part 'ticket_sub_category_master_state.dart';

class TicketSubCategoryMasterBloc
    extends Bloc<TicketSubCategoryMasterEvent, TicketSubCategoryMasterState> {
  final TicketSubCategoryMasterUseCase _subCategoryMasterUseCase;
  final InsertUpdateSubCategoryUseCase _insertUpdateSubCategoryUseCase;

  TicketSubCategoryMasterBloc(
    this._subCategoryMasterUseCase,
    this._insertUpdateSubCategoryUseCase,
  ) : super(TicketSubCategoryMasterInitial()) {
    on<TicketSubCategoryListRequested>(_onTicketSubCategoryListRequested);
    on<InsertUpdateSubCategoryRequested>(_onInsertUpdateSubCategoryRequested);
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

  FutureOr<void> _onInsertUpdateSubCategoryRequested(
    InsertUpdateSubCategoryRequested event,
    Emitter<TicketSubCategoryMasterState> emit,
  ) async {
    emit(TicketSubCategoryMasterLoading());
    try {
      final result = await _insertUpdateSubCategoryUseCase.call(
        payload: event.payload,
      );
      result.fold(
        (error) =>
            emit(InsertUpdateSubCategoryFailure(errorMessage: error.message)),
        (data) => emit(InsertUpdateSubCategorySuccess(message: data)),
      );
    } catch (e) {
      emit(TicketSubCategoryMasterFailure(errorMessage: e.toString()));
    }
  }
}
