import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/exceptions.dart';
import 'package:my_worksphere_web/features/auth/data/models/validate_company_code_response/validate_company_code_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/employee_login/employee_login_response_model.dart';
import '../models/employee_login/employee_user_request.dart';

abstract class AuthRemoteDataSource {
  Future<ValidateCompanyCodeResponseModel> validateCompanyCode({
    required String companyCode,
  });

  Future<EmployerLoginResponseModel> employeeLogin({
    required EmployeeUserRequest employeeUserRequest,
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
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<EmployerLoginResponseModel> employeeLogin({
    required EmployeeUserRequest employeeUserRequest,
  }) async {
    try {
      final json = await apiClient.get(
        ApiEndpoints.employeeLogin,
        queryParameters: {
          "UserName": employeeUserRequest.username,
          "Password": employeeUserRequest.password,
          "UserType": employeeUserRequest.userType,
          "CompanyID": employeeUserRequest.companyId,
        },
      );

      return EmployerLoginResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
