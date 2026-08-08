import 'package:dio/dio.dart';
import 'package:my_worksphere_web/core/error/exceptions.dart';
import 'package:my_worksphere_web/features/auth/data/models/validate_company_code_response/validate_company_code_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<ValidateCompanyCodeResponseModel> validateCompanyCode({
    required String companyCode,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  @override
  Future<ValidateCompanyCodeResponseModel> validateCompanyCode({
    required String companyCode,
  }) async {
    try {
      // call api here
      return ValidateCompanyCodeResponseModel.fromJson({});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
