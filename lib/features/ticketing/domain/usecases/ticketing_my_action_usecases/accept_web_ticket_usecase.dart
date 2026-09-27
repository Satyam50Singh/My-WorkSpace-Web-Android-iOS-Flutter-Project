import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticketing_my_action_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../data/models/ticketing_my_action_models/accept_web_ticket_request_model.dart';

class AcceptWebTicketUseCase {
  final TicketingMyActionRepository _repository;

  AcceptWebTicketUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required AcceptWebTicketRequestModel payload,
  }) {
    return _repository.acceptWebTicketRequested(payload: payload);
  }
}
