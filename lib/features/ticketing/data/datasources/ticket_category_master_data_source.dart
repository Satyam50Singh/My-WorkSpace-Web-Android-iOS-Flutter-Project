import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_category_models/fetch_ticket_category_list_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';

abstract class TicketCategoryMasterDataSource {
  Future<FetchTicketCategoryListResponseModel> fetchTicketCategoryList({
    required int companyID,
  });
}

class TicketCategoryMasterDataSourceImpl
    extends TicketCategoryMasterDataSource {
  final ApiClient _apiClient;

  TicketCategoryMasterDataSourceImpl(this._apiClient);

  @override
  Future<FetchTicketCategoryListResponseModel> fetchTicketCategoryList({
    required int companyID,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketCategoryList,
        queryParameters: {'CompanyID': companyID, 'Category_ID': 0},
      );

      return FetchTicketCategoryListResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
