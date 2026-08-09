import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/employee_login/employee_user_request.dart';
import '../entities/user.dart';

class EmployeeLoginUseCase {
  final AuthRepository _repository;

  EmployeeLoginUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required EmployeeUserRequest employeeUserRequest,
  }) {
    return _repository.employeeLogin(employeeUserRequest: employeeUserRequest);
  }
}
