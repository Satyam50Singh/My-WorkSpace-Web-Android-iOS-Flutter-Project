import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/department_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_category_usecases/department_master_usecase.dart';
import 'package:my_worksphere_web/features/ticketing/domain/usecases/ticket_category_usecases/ticket_category_usecase.dart';

part 'ticket_category_master_event.dart';
part 'ticket_category_master_state.dart';

class TicketCategoryMasterBloc
    extends Bloc<TicketCategoryMasterEvent, TicketCategoryMasterState> {
  final TicketCategoryUseCase _ticketCategoryUseCase;
  final DepartmentMasterUseCase _departmentMasterUsecCase;

  TicketCategoryMasterBloc(
    this._ticketCategoryUseCase,
    this._departmentMasterUsecCase,
  ) : super(TicketCategoryMasterInitial()) {
    on<TicketCategoryListRequested>(_onTicketCategoryListRequested);
    on<DepartmentMasterListRequested>(_onDepartmentMasterListRequested);
  }

  FutureOr<void> _onTicketCategoryListRequested(
    TicketCategoryListRequested event,
    Emitter<TicketCategoryMasterState> emit,
  ) async {
    emit(TicketCategoryMasterLoading());
    try {
      final result = await _ticketCategoryUseCase.call(
        companyID: event.companyID,
      );
      result.fold(
        (error) =>
            emit(TicketCategoryMasterFailure(errorMessage: error.message)),
        (data) => emit(TicketCategoryMasterSuccess(categoryList: data)),
      );
    } catch (e) {
      emit(TicketCategoryMasterFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onDepartmentMasterListRequested(
    DepartmentMasterListRequested event,
    Emitter<TicketCategoryMasterState> emit,
  ) async {
    emit(DepartmentMasterListLoading());
    try {
      final result = await _departmentMasterUsecCase.call(
        companyID: event.companyID,
      );
      result.fold(
        (error) =>
            emit(TicketCategoryMasterFailure(errorMessage: error.message)),
        (data) => emit(DepartmentMasterListSuccess(departmentList: data)),
      );
    } catch (e) {
      emit(TicketCategoryMasterFailure(errorMessage: e.toString()));
    }
  }
}
