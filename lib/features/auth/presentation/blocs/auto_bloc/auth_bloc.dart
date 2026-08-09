import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/company.dart';
import 'package:my_worksphere_web/features/auth/domain/usecases/validate_company_code_usecase.dart';

import '../../../data/models/employee_login/employee_user_request.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/employee_login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ValidateCompanyCodeUseCase _validateCompanyCodeUseCase;
  final EmployeeLoginUseCase _employeeLoginUseCase;

  AuthBloc(this._validateCompanyCodeUseCase, this._employeeLoginUseCase)
    : super(AuthInitial()) {
    on<ValidateCompanyCodeRequested>(_onValidateCompanyCodeRequested);
    on<LoginRequested>(_onLoginRequested);
  }

  FutureOr<void> _onValidateCompanyCodeRequested(
    ValidateCompanyCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _validateCompanyCodeUseCase(
        companyCode: event.companyCode,
      );

      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (companyDetails) => emit(ValidatedCompanyCodeSuccess(companyDetails)),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  FutureOr<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final payload = EmployeeUserRequest(
        username: event.userName,
        password: event.password,
        companyId: event.companyId,
        userType: event.userType,
      );
      final result = await _employeeLoginUseCase(employeeUserRequest: payload);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (userDetails) => emit(EmployeeLoginSuccess(userDetails)),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
