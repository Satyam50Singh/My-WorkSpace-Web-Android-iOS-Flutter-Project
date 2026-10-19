import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/ticket_workflow_master_repository.dart';
import '../datasources/ticket_workflow_master_data_source.dart';

class TicketWorkflowMasterRepositoryImpl
    extends TicketWorkflowMasterRepository {
  final TicketWorkflowMasterDataSource _dataSource;

  TicketWorkflowMasterRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<TicketWorkflowMasterEntity>>>
  fetchTicketWorkflowList({required int companyID}) async {
    try {
      final response = await _dataSource.fetchTicketWorkflowList(
        companyID: companyID,
      );
      if (response.status == 1 && response.workflowList != null) {
        final ticketWorkflowList = response.workflowList!
            .map((e) => e.toEntity())
            .toList();
        debugPrint('Hello world I am here $ticketWorkflowList');
        return Right(ticketWorkflowList);
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
