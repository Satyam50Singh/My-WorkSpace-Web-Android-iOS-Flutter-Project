import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_category_models/fetch_department_list_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_category_models/fetch_ticket_category_list_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_category_models/insert_update_ticket_category_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/common_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';

abstract class TicketCategoryMasterDataSource {
  Future<FetchTicketCategoryListResponseModel> fetchTicketCategoryList({
    required int companyId,
  });

  Future<FetchDepartmentListResponseModel> fetchDepartmentList({
    required int companyId,
  });

  Future<CommonResponseModel> insertUpdateTicketCategory({
    required InsertUpdateTicketCategoryRequestModel payload,
  });
}

class TicketCategoryMasterDataSourceImpl
    extends TicketCategoryMasterDataSource {
  final ApiClient _apiClient;

  TicketCategoryMasterDataSourceImpl(this._apiClient);

  @override
  Future<FetchTicketCategoryListResponseModel> fetchTicketCategoryList({
    required int companyId,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketCategoryList,
        queryParameters: {'CompanyID': companyId, 'Category_ID': 0},
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

  @override
  Future<FetchDepartmentListResponseModel> fetchDepartmentList({
    required int companyId,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchMasterDepartmentList,
        queryParameters: {'CompanyID': companyId},
      );

      return FetchDepartmentListResponseModel.fromJson(json);
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
    required InsertUpdateTicketCategoryRequestModel payload,
  }) async {
    try {
      final json = await _apiClient.post(
        ApiEndpoints.insertUpdateTicketCategory,
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
