import 'package:dio/dio.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/core/network/api_endpoints.dart';
import 'package:my_worksphere_web/core/network/api_exceptions.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_action_history_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_details_v6_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../models/view_ticket_details/ticket_workflow_response_model.dart';
import '../models/view_ticket_details/view_ticket_detail_request.dart';

abstract class ViewTicketDetailRemoteDataSource {
  Future<ViewTicketDetailsV6ResponseModel> fetchTicketDetailsV6({
    required ViewTicketDetailRequest payload,
  });

  Future<TicketWorkflowResponseModel> fetchTicketWorkflowDetails({
    required ViewTicketDetailRequest payload,
  });

  Future<ViewTicketActionHistoryResponseModel> fetchTicketActionHistory({
    required ViewTicketDetailRequest payload,
  });
}

class ViewTicketDetailRemoteDataSourceImpl
    extends ViewTicketDetailRemoteDataSource {
  final ApiClient _apiClient;

  ViewTicketDetailRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ViewTicketDetailsV6ResponseModel> fetchTicketDetailsV6({
    required ViewTicketDetailRequest payload,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchViewTicketDetailsV6,
        queryParameters: {
          'CompanyID': payload.companyId,
          'EmpCD': payload.empCd,
          'TicketID': payload.ticketId,
        },
      );
      return ViewTicketDetailsV6ResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<TicketWorkflowResponseModel> fetchTicketWorkflowDetails({
    required ViewTicketDetailRequest payload,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchViewTicketWorkflowDetails,
        queryParameters: {
          'CompanyID': payload.companyId,
          'EmpCD': payload.empCd,
          'TicketID': payload.ticketId,
        },
      );
      return TicketWorkflowResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<ViewTicketActionHistoryResponseModel> fetchTicketActionHistory({
    required ViewTicketDetailRequest payload,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchViewTicketActionHistory,
        queryParameters: {
          'CompanyID': payload.companyId,
          'EmpCD': payload.empCd,
          'TicketID': payload.ticketId,
        },
      );
      return ViewTicketActionHistoryResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
