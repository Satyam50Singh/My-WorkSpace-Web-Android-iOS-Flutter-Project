import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/core/network/api_endpoints.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_location_category_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/add_new_request/ticket_location_category_request.dart';

abstract class AddNewRequestDataSource {
  Future<TicketLocationCategoryResponseModel> fetchTicketLocationCategory(
    TicketLocationCategoryRequest payload,
  );
}

class AddNewRequestDataSourceImpl extends AddNewRequestDataSource {
  final ApiClient _apiClient;

  AddNewRequestDataSourceImpl(this._apiClient);

  @override
  Future<TicketLocationCategoryResponseModel> fetchTicketLocationCategory(
    TicketLocationCategoryRequest payload,
  ) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketLocationCategoryV2,
        queryParameters: {
          'CompanyID': payload.companyId,
          'EmpCD': payload.empCd,
          'RetailerID': payload.retailerId,
        },
      );

      return TicketLocationCategoryResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
