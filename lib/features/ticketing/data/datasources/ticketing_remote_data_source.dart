import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_endpoints.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_my_request_request.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_my_request_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';

abstract class TicketingRemoteDataSource {
  Future<TicketMyRequestResponseModel> getMyRequestDetails(
    TicketMyRequestRequest payload,
  );
}

class TicketingRemoteDataSourceImpl extends TicketingRemoteDataSource {
  final ApiClient apiClient;

  TicketingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<TicketMyRequestResponseModel> getMyRequestDetails(
    TicketMyRequestRequest payload,
  ) async {
    try {
      final json = await apiClient.get(
        ApiEndpoints.fetchTicketMyRequestDetails,
        queryParameters: {
          'CompanyID': payload.companyId,
          'EmpCD': payload.empCd,
          'FromDate': payload.fromDate,
          'ToDate': payload.toDate,
          'PageSize': payload.pageSize,
          'PageCount': payload.pageCount,
          'ActionStatus': payload.actionStatus,
          'SearchText': payload.searchText,
          'DepartmentId': payload.departmentId,
          'CategoryId': payload.categoryId,
          'TicketType': payload.ticketType,
        },
      );
      debugPrint('Response: $json');
      return TicketMyRequestResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
