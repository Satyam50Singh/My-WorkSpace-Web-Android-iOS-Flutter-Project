import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_sub_category_models/fetch_ticket_sub_category_list_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/ticket_sub_category_models/insert_update_sub_category_request_model.dart';
import '../models/ticketing_my_action_models/common_response_model.dart';

abstract class TicketSubCategoryMasterDataSource {
  Future<FetchTicketSubCategoryListResponseModel> fetchTicketSubCategoryList({
    required int companyID,
  });

  Future<CommonResponseModel> insertUpdateTicketCategory({
    required InsertUpdateSubCategoryRequestModel payload,
  });
}

class TicketSubCategoryMasterDataSourceImpl
    extends TicketSubCategoryMasterDataSource {
  final ApiClient _apiClient;

  TicketSubCategoryMasterDataSourceImpl(this._apiClient);

  @override
  Future<FetchTicketSubCategoryListResponseModel> fetchTicketSubCategoryList({
    required int companyID,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketSubCategoryList,
        queryParameters: {'CompanyID': companyID, 'SubCategory_ID': 0},
      );

      return FetchTicketSubCategoryListResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<CommonResponseModel> insertUpdateTicketCategory({
    required InsertUpdateSubCategoryRequestModel payload,
  }) async {
    try {
      final json = await _apiClient.post(
        ApiEndpoints.insertUpdateTicketSubCategory,
        data: FormData.fromMap({'0': jsonEncode(payload.toJson())}),
      );

      return CommonResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
