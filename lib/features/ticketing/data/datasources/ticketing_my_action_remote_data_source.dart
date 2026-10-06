import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/add_new_ticket_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/common_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/ticket_transfer_user_list_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/transfer_ticket_web_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/transfer_to_other_workflow_request_body.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/update_ticket_action_request_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/add_new_request/app_multipart_file.dart';

abstract class TicketingMyActionRemoteDataSource {
  Future<AcceptWebTicketResponseModel> acceptWebTicketRequested({
    required AcceptWebTicketRequestModel payload,
  });

  Future<CommonResponseModel> updateTicketActionRequested({
    required UpdateTicketActionRequestModel payload,
    List<AppMultipartFile>? images,
  });

  Future<TicketTransferUserListResponseModel> ticketTransferUserListRequested({
    required int ticketID,
  });

  Future<CommonResponseModel> transferTicketWebRequested({
    required TransferTicketWebRequestModel payload,
  });

  Future<AddNewTicketResponseModel> transferToOtherWorkflow({
    required TransferToOtherWorkflowRequestBody payload,
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

  @override
  Future<CommonResponseModel> updateTicketActionRequested({
    required UpdateTicketActionRequestModel payload,
    List<AppMultipartFile>? images,
  }) async {
    try {
      if (images != null && images.isNotEmpty) {
        final multipartFiles = await Future.wait(
          images.map((file) async {
            if (file.bytes != null) {
              return MultipartFile.fromBytes(file.bytes!, filename: file.name);
            } else {
              return await MultipartFile.fromFile(
                file.path!,
                filename: file.name,
              );
            }
          }),
        );

        final json = await _apiClient.post(
          ApiEndpoints.updateTicketActionV4,
          data: FormData.fromMap({
            '0': jsonEncode(payload.toJson()),
            '1': multipartFiles,
          }),
        );
        return CommonResponseModel.fromJson(json);
      } else {
        final json = await _apiClient.post(
          ApiEndpoints.updateTicketActionV4,
          data: FormData.fromMap({'0': jsonEncode(payload.toJson())}),
        );
        return CommonResponseModel.fromJson(json);
      }
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<TicketTransferUserListResponseModel> ticketTransferUserListRequested({
    required int ticketID,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketTransferUserList,
        queryParameters: {'TicketID': ticketID},
      );
      return TicketTransferUserListResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<CommonResponseModel> transferTicketWebRequested({
    required TransferTicketWebRequestModel payload,
  }) async {
    try {
      final json = await _apiClient.post(
        ApiEndpoints.transferTicketWeb,
        data: FormData.fromMap({'0': jsonEncode(payload.toJson())}),
      );

      return CommonResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<AddNewTicketResponseModel> transferToOtherWorkflow({
    required TransferToOtherWorkflowRequestBody payload,
  }) async {
    try {
      final json = await _apiClient.post(
        ApiEndpoints.transferToOtherWorkflow,
        data: FormData.fromMap({'0': jsonEncode(payload.toJson())}),
      );

      return AddNewTicketResponseModel.fromJson(json);
    } on ApiException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
