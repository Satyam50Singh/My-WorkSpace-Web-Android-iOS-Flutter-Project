import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';

abstract class TicketingMyActionRepository {
  Future<Either<Failure, String>> acceptWebTicketRequested({
    required AcceptWebTicketRequestModel payload,
  });
}
