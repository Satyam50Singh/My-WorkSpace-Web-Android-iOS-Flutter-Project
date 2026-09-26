import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/network/api_client.dart';
import 'package:my_worksphere_web/core/network/api_endpoints.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/app_multipart_file.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/add_new_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_location_category_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_sub_category_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_workflow_details_response_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/add_new_request/add_new_ticket_response_model.dart';
import '../models/add_new_request/ticket_location_category_request.dart';

abstract class AddNewRequestDataSource {
  Future<TicketLocationCategoryResponseModel> fetchTicketLocationCategory(
    TicketLocationCategoryRequest payload,
  );

  Future<TicketSubCategoryResponseModel> fetchTicketSubCategory(int categoryID);

  Future<TicketWorkflowDetailsResponseModel> fetchTicketWorkFlowDetails({
    required int categoryID,
    required int subCategoryID,
  });

  Future<AddNewTicketResponseModel> addNewTicketSubmitted({
    required AddNewTicketRequestModel payload,
    required List<AppMultipartFile> imageFiles,
  });
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

  @override
  Future<TicketSubCategoryResponseModel> fetchTicketSubCategory(
    int categoryID,
  ) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketSubCategory,
        queryParameters: {'CategoryID': categoryID},
      );
      return TicketSubCategoryResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<TicketWorkflowDetailsResponseModel> fetchTicketWorkFlowDetails({
    required int categoryID,
    required int subCategoryID,
  }) async {
    try {
      final json = await _apiClient.get(
        ApiEndpoints.fetchTicketWorkflowDetailsV2,
        queryParameters: {
          'CategoryID': categoryID,
          'SubCategoryID': subCategoryID,
        },
      );
      return TicketWorkflowDetailsResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }

  @override
  Future<AddNewTicketResponseModel> addNewTicketSubmitted({
    required AddNewTicketRequestModel payload,
    required List<AppMultipartFile> imageFiles,
  }) async {
    try {
      final multipartFiles = await Future.wait(
        imageFiles.map((file) async {
          if (file.bytes != null) {
            return MultipartFile.fromBytes(
              file.bytes!,
              filename: file.name,
            );
          } else {
            return await MultipartFile.fromFile(
              file.path!,
              filename: file.name,
            );
          }
        }),
      );
      final json = await _apiClient.post(
        ApiEndpoints.fetchTicketRequestDetailsV4,
        data: FormData.fromMap({
          '0': jsonEncode(payload.toJson()),
          '1': multipartFiles,
        }),
      );
      return AddNewTicketResponseModel.fromJson(json);
    } on ApiException catch (e) {
      debugPrint('ApiException: ${e.message}');
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw ServerException(message: e.message ?? "Something went wrong!");
    }
  }
}
