import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/ticket_sub_category_master_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_sub_category_master_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../models/ticket_sub_category_models/insert_update_sub_category_request_model.dart';

class TicketSubCategoryMasterRepositoryImpl
    extends TicketSubCategoryMasterRepository {
  final TicketSubCategoryMasterDataSource _dataSource;

  TicketSubCategoryMasterRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<SubCategoryMasterEntity>>>
  fetchTicketSubCategoryMasterList({required int companyID}) async {
    try {
      final response = await _dataSource.fetchTicketSubCategoryList(
        companyID: companyID,
      );
      if (response.status == 1 && response.subCategoryList != null) {
        return Right(
          response.subCategoryList
                  ?.map((subCategory) => subCategory.toEntity())
                  .toList() ??
              [],
        );
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
  Future<Either<Failure, String>> insertUpdateTicketSubCategory({
    required InsertUpdateSubCategoryRequestModel payload,
  }) async {
    try {
      final response = await _dataSource.insertUpdateTicketCategory(
        payload: payload,
      );
      if (response.status == 1 && response.message != null) {
        return Right(response.message ?? "Something went wrong!");
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
