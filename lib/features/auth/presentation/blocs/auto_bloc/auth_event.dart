part of 'auth_bloc.dart';

abstract class AuthEvent {}

class ValidateCompanyCodeRequested extends AuthEvent {
  final String companyCode;

  ValidateCompanyCodeRequested({required this.companyCode});
}

class LoginRequested extends AuthEvent {
  final String userName;
  final String password;
  final int companyId;
  final String userType;

  LoginRequested({
    required this.userName,
    required this.password,
    required this.companyId,
    required this.userType,
  });
}
