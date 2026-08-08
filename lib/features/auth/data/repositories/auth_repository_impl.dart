import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/auth/data/models/validate_company_code_response/validate_company_code_response_model.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/company.dart';
import 'package:my_worksphere_web/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Company>> validateCompanyCode({
    required String companyCode,
  }) async {
    try {
      final response = await remoteDataSource.validateCompanyCode(
        companyCode: companyCode,
      );

      if (response.status == 1 && response.companyDetailList.isNotEmpty) {
        return Right(response.companyDetailList.first);
      } else {
        return Left(
          ServerFailure(
            response.message.isNotEmpty
                ? response.message
                : "Company code does not exist",
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
