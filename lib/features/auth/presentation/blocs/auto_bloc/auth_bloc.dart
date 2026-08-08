import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<ValidateCompanyCodeRequested>(_onValidateCompanyCodeRequested);
    on<LoginRequested>(_onLoginRequested);
  }

  FutureOr<void> _onValidateCompanyCodeRequested(
    ValidateCompanyCodeRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoading());
    debugPrint('Will call a Use case from here ${event.companyCode}');
    try {} catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  FutureOr<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoading());
    try {} catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
