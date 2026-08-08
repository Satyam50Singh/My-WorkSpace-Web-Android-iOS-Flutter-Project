import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
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

      return Right(response.companyDetailList.first);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
