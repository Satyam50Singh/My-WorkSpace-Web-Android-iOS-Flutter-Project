part of 'employee_detail_cubit.dart';

abstract class EmployeeDetailState {}

final class EmployeeDetailInitial extends EmployeeDetailState {}

final class EmployeeDetailFetched extends EmployeeDetailState {
  final EmployeeDetail employeeDetail;

  EmployeeDetailFetched({required this.employeeDetail});
}

final class EmployeeDetailCleared extends EmployeeDetailState {}
