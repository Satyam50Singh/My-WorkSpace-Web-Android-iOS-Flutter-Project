import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/ticket_category_master_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_category_master_repository.dart';

import '../../../../core/error/exceptions.dart';

class TicketCategoryMasterRepositoryImpl
    extends TicketCategoryMasterRepository {
  final TicketCategoryMasterDataSource _dataSource;

  TicketCategoryMasterRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<TicketCategoryEntity>>>
  fetchTicketCategoryMasterList({required int companyID})  async {
    try {
      final response = await _dataSource.fetchTicketCategoryList(companyID: companyID);
      if (response.status == 1 && response.categoryList != null) {
        return Right(
          response.categoryList?.map((category) => category.toEntity()).toList() ?? [],
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
}
