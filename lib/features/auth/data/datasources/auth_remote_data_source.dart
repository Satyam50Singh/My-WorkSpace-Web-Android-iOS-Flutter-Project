import 'package:dio/dio.dart';
import 'package:my_worksphere_web/core/error/exceptions.dart';
import 'package:my_worksphere_web/features/auth/data/models/validate_company_code_response/validate_company_code_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<ValidateCompanyCodeResponseModel> validateCompanyCode({
    required String companyCode,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ValidateCompanyCodeResponseModel> validateCompanyCode({
    required String companyCode,
  }) async {
    try {
      final json = await apiClient.get(
        ApiEndpoints.validateCompanyCode,
        queryParameters: {"CompanyCode": companyCode},
      );
      return ValidateCompanyCodeResponseModel.fromJson(json);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
