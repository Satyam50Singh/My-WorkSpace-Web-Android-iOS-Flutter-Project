import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_report_models/fetch_ticket_report_web_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_report_entities/fetch_cat_sub_cat_loc_dept_type_list_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_report_master_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../datasources/ticket_report_master_data_source.dart';

class TicketReportMasterRepositoryImpl extends TicketReportMasterRepository {
  final TicketReportMasterDataSource _dataSource;

  TicketReportMasterRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, FetchCatSubCatLocDeptTypeListEntity>>
  fetchCatSubCatLocDeptTypeList({required int companyID}) async {
    try {
      final response = await _dataSource.fetchCatSubCatLocDeptTypeList(
        companyID: companyID,
      );
      if (response.status == 1) {
        return Right(response);
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
  Future<Either<Failure, FetchTicketReportWebEntity>> fetchTicketReportWeb({
    required FetchTicketReportWebRequestModel payload,
  })  async {
    try {
      final response = await _dataSource.fetchTicketReportWeb(
        payload: payload,
      );
      if (response.status == 1) {
        return Right(response);
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
