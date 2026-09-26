import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_my_request_request.dart';

import '../entities/ticket_detail_entity.dart';

abstract class TicketingRepository {
  Future<Either<Failure, TicketDetailEntity>> getMyRequestDetails({
    required TicketMyRequestRequest request,
  });
}
