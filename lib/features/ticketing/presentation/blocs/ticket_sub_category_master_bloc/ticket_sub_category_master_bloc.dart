import 'dart:async';

import 'package:bloc/bloc.dart';
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
    if (event.payload.action == 'D') {
      emit(DeleteTicketSubCategoryLoading());
    } else {
      emit(InsertSubCategoryMasterLoading());
    }

    try {
      final result = await _insertUpdateSubCategoryUseCase.call(
        payload: event.payload,
      );
      if (event.payload.action == 'C') {
        result.fold(
          (error) => emit(
            InsertTicketSubCategoryFailure(errorMessage: error.message),
          ),
          (data) => emit(InsertTicketSubCategorySuccess(message: data)),
        );
      } else if (event.payload.action == 'U') {
        result.fold(
          (error) => emit(
            UpdateTicketSubCategoryFailure(errorMessage: error.message),
          ),
          (data) => emit(UpdateTicketSubCategorySuccess(message: data)),
        );
      } else if (event.payload.action == 'D') {
        result.fold(
          (error) => emit(
            DeleteTicketSubCategoryFailure(errorMessage: error.message),
          ),
          (data) => emit(DeleteTicketSubCategorySuccess(message: data)),
        );
      }
    } catch (e) {
      if (event.payload.action == 'C') {
        emit(InsertTicketSubCategoryFailure(errorMessage: e.toString()));
      } else if (event.payload.action == 'U') {
        emit(UpdateTicketSubCategoryFailure(errorMessage: e.toString()));
      } else if (event.payload.action == 'D') {
        emit(DeleteTicketSubCategoryFailure(errorMessage: e.toString()));
      } else {
        emit(TicketSubCategoryMasterFailure(errorMessage: e.toString()));
      }
    }
  }
}
