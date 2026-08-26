import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/exceptions.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/submit_reopen_review_request.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/submit_reopen_review_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_history_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_v6.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/view_ticket_detail_repository.dart';

import '../datasources/view_ticket_detail_remote_data_source.dart';

class ViewTicketDetailRepositoryImpl extends ViewTicketDetailRepository {
  final ViewTicketDetailRemoteDataSource remoteDataSource;

  ViewTicketDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ViewTicketDetailV6Entity>>> fetchTicketDetailsV6({
    required ViewTicketDetailRequest payload,
  }) async {
    try {
      final response = await remoteDataSource.fetchTicketDetailsV6(
        payload: payload,
      );
      if (response.status == 1) {
        return Right(
          response.ticketDetails!.toList().map((e) => e.toEntity()).toList(),
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
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TicketWorkflowEntity>>>
  fetchTicketWorkflowDetails({required ViewTicketDetailRequest payload}) async {
    try {
      final response = await remoteDataSource.fetchTicketWorkflowDetails(
        payload: payload,
      );
      if (response.status == 1 && response.ticketWorkflow != null) {
        return Right(
          response.ticketWorkflow!.toList().map((e) => e.toEntity()).toList(),
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
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TicketHistoryEntity>>> fetchTicketActionHistory({
    required ViewTicketDetailRequest payload,
  }) async {
    try {
      final response = await remoteDataSource.fetchTicketActionHistory(
        payload: payload,
      );
      if (response.status == 1) {
        return Right(
          response.ticketHistory!.toList().map((e) => e.toEntity()).toList(),
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
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SubmitReopenReviewEntity>> submitReopenReviewTicket({
    required SubmitReopenReviewRequest payload,
  }) async {
    try {
      final response = await remoteDataSource.submitReopenReviewTicket(
        payload: payload,
      );
      if (response.status == 1) {
        return Right(
          SubmitReopenReviewEntity(response.status, response.message),
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
      return Left(ServerFailure(e.message));
    }
  }
}
