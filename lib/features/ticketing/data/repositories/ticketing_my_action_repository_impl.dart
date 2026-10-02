import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/datasources/ticketing_my_action_remote_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/update_ticket_action_request_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/ticketing_my_action_repository.dart';
import '../models/add_new_request/app_multipart_file.dart';
import '../models/ticketing_my_action_models/accept_web_ticket_request_model.dart';

class TicketingMyActionRepositoryImpl extends TicketingMyActionRepository {
  final TicketingMyActionRemoteDataSource _dataSource;

  TicketingMyActionRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, String>> acceptWebTicketRequested({
    required AcceptWebTicketRequestModel payload,
  }) async {
    try {
      final response = await _dataSource.acceptWebTicketRequested(
        payload: payload,
      );
      if (response.status == 1 || response.status == 2) {
        return Right(response.message ?? '');
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
  Future<Either<Failure, String>> updateTicketActionRequested({
    required UpdateTicketActionRequestModel payload,
    List<AppMultipartFile>? images,
  }) async {
    try {
      final response = await _dataSource.updateTicketActionRequested(
        payload: payload,
        images: images,
      );
      if (response.status == 1 || response.status == 2) {
        return Right(response.message ?? '');
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
