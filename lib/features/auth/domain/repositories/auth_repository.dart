import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';

import '../../data/models/employee_login/employee_user_request.dart';
import '../entities/company.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Company>> validateCompanyCode({
    required String companyCode,
  });

  Future<Either<Failure, User>> employeeLogin({
    required EmployeeUserRequest employeeUserRequest,
  });
}
