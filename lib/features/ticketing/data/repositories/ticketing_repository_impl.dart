import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/exceptions.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/ticketing_remote_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_my_request_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_detail_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticketing_repository.dart';

class TicketingRepositoryImpl extends TicketingRepository {
  TicketingRemoteDataSource ticketingRemoteDataSource;

  TicketingRepositoryImpl(this.ticketingRemoteDataSource);

  @override
  Future<Either<Failure, TicketDetailEntity>> getMyRequestDetails({
    required TicketMyRequestRequest request,
  }) async {
    try {
      final response = await ticketingRemoteDataSource.getMyRequestDetails(
        request,
      );
      if (response.status == 1 || response.status == 2) {
        return Right(response.ticketDetail!.toEntity());
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
