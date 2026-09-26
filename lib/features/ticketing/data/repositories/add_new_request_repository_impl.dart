import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/add_new_request_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/add_new_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/app_multipart_file.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_location_category_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/add_new_ticket_request_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/add_new_request_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/add_new_request/ticket_sub_category_entity.dart';

class AddNewRequestRepositoryImpl extends AddNewRequestRepository {
  final AddNewRequestDataSource dataSource;

  AddNewRequestRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, TicketLocationCategoryEntity>>
  fetchTicketLocationCategory({
    required TicketLocationCategoryRequest payload,
  }) async {
    try {
      final response = await dataSource.fetchTicketLocationCategory(payload);
      if (response.status == 1 && response.ticketLocationCategory != null) {
        return Right(response.ticketLocationCategory!.toEntity());
      } else {
        final message = response.message?.trim();
        return Left(
          ServerFailure(
            message?.isNotEmpty == true
                ? message ?? "Something went wrong!"
                : "Something went wrong!",
          ),
        );
      }
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TicketSubCategoryEntity>> fetchTicketSubCategory({
    required int categoryID,
  }) async {
    try {
      final response = await dataSource.fetchTicketSubCategory(categoryID);
      if (response.status == 1 && response.ticketSubCategory != null) {
        return Right(response.ticketSubCategory!.toEntity());
      } else {
        final message = response.message?.trim();
        return Left(
          ServerFailure(
            message?.isNotEmpty == true
                ? message ?? "Something went wrong!"
                : "Something went wrong!",
          ),
        );
      }
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TicketWorkflowDetailsEntity>>
  fetchTicketWorkFlowDetails({
    required int categoryID,
    required int subCategoryID,
  }) async {
    try {
      final response = await dataSource.fetchTicketWorkFlowDetails(
        categoryID: categoryID,
        subCategoryID: subCategoryID,
      );
      if (response.status == 1 && response.workFlowModel != null) {
        return Right(response.workFlowModel!.toEntity());
      } else {
        final message = response.message?.trim();
        return Left(
          ServerFailure(
            message?.isNotEmpty == true
                ? message ?? "Something went wrong!"
                : "Something went wrong!",
          ),
        );
      }
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AddNewTicketRequestEntity>> addNewTicketSubmitted({
    required AddNewTicketRequestModel payload,
    required List<AppMultipartFile> imageFiles,
  }) async {
    try {
      final response = await dataSource.addNewTicketSubmitted(
        payload: payload,
        imageFiles: imageFiles,
      );
      if (response.status == 1 && response.addNewTicketModel != null) {
        return Right(response.addNewTicketModel!.toEntity());
      } else {
        final message = response.message?.trim();
        return Left(
          ServerFailure(
            message?.isNotEmpty == true
                ? message ?? "Something went wrong!"
                : "Something went wrong!",
          ),
        );
      }
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }
}
