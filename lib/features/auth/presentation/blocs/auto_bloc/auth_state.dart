part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

final class ValidatedCompanyCodeSuccess extends AuthState {
  final Company companyDetails;

  ValidatedCompanyCodeSuccess(this.companyDetails);

  List<Object> get props => [companyDetails];
}

final class EmployeeLoginSuccess extends AuthState {
  final EmployeeDetail employeeDetails;

  EmployeeLoginSuccess(this.employeeDetails);

  List<Object> get props => [employeeDetails];
}
