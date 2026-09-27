import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';

abstract class TicketingMyActionRemoteDataSource {
  Future<AcceptWebTicketResponseModel> acceptWebTicketRequested({
    required AcceptWebTicketRequestModel payload,
  });
}

class TicketingMyActionRemoteDataSourceImpl
    extends TicketingMyActionRemoteDataSource {
  final ApiClient _apiClient;

  TicketingMyActionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AcceptWebTicketResponseModel> acceptWebTicketRequested({
    required AcceptWebTicketRequestModel payload,
  }) async {
    try {
      final json = await _apiClient.post(
        ApiEndpoints.acceptWebTicket,
        data: FormData.fromMap({'0': jsonEncode(payload.toJson())}),
      );

      return AcceptWebTicketResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
