import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/company.dart';
import 'package:my_worksphere_web/features/auth/domain/repositories/auth_repository.dart';

class ValidateCompanyCodeUseCase {
  final AuthRepository _authRepository;

  ValidateCompanyCodeUseCase(this._authRepository);

  Future<Either<Failure, Company>> call({required String companyCode}) {
    return _authRepository.validateCompanyCode(companyCode: companyCode);
  }
}
