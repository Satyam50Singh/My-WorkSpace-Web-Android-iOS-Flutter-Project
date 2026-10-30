import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_report_models/fetch_cat_sub_cat_loc_dept_type_list_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/ticket_report_models/fetch_ticket_report_web_request_model.dart';
import '../models/ticket_report_models/fetch_ticket_report_web_response_model.dart';

abstract class TicketReportMasterDataSource {
  Future<FetchCatSubCatLocDeptTypeListResponseModel>
  fetchCatSubCatLocDeptTypeList({required int companyID});

  Future<FetchTicketReportWebResponseModel> fetchTicketReportWeb({
    required FetchTicketReportWebRequestModel payload,
  });
}

class TicketReportMasterDataSourceImpl extends TicketReportMasterDataSource {
  final ApiClient _apiClient;

  TicketReportMasterDataSourceImpl(this._apiClient);

  @override
  Future<FetchCatSubCatLocDeptTypeListResponseModel>
  fetchCatSubCatLocDeptTypeList({required int companyID}) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchCatSubCatLocDeptTypeList,
        queryParameters: {'CompanyID': companyID},
      );

      return FetchCatSubCatLocDeptTypeListResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<FetchTicketReportWebResponseModel> fetchTicketReportWeb({
    required FetchTicketReportWebRequestModel payload,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketReportWeb,
        queryParameters: {
          'CompanyID': payload.companyID,
          'FromDate': payload.fromDate,
          'ToDate': payload.toDate,
          'PageSize': payload.pageSize,
          'PageCount': payload.pageCount,
          'ActionStatus': payload.actionStatus,
          'SearchText': payload.searchText,
          'DepartmentId': payload.departmentId,
          'CategoryId': payload.categoryId,
          'TicketType': payload.ticketType,
          'LocationID': payload.locationId,
          'SubCategoryID': payload.subCategoryId,
        },
      );

      return FetchTicketReportWebResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
