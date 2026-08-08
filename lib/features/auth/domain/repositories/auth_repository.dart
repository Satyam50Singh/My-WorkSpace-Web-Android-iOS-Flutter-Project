import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';

import '../entities/company.dart';

abstract class AuthRepository {
  Future<Either<Failure, Company>> validateCompanyCode({
    required String companyCode,
  });
}
