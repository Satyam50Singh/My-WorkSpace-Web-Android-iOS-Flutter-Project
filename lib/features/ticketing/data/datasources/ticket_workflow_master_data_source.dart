import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/ticket_workflow_list_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/common_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';

abstract class TicketWorkflowMasterDataSource {
  Future<TicketWorkflowListResponseModel> fetchTicketWorkflowList({
    required int companyID,
  });

  Future<CommonResponseModel> insertUpdateTicketWorkflow({
    required InsertUpdateWorkflowRequestModel payload,
  });
}

class TicketWorkflowMasterDataSourceImpl
    extends TicketWorkflowMasterDataSource {
  final ApiClient _apiClient;

  TicketWorkflowMasterDataSourceImpl(this._apiClient);

  @override
  Future<TicketWorkflowListResponseModel> fetchTicketWorkflowList({
    required int companyID,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketWorkflowList,
        queryParameters: {'CompanyID': companyID},
      );
      return TicketWorkflowListResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<CommonResponseModel> insertUpdateTicketWorkflow({
    required InsertUpdateWorkflowRequestModel payload,
  }) async {
    try {
      final json = await _apiClient.post(
        ApiEndpoints.insertUpdateTicketWorkflow,
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
