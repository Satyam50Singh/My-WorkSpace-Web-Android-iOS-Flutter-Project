import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/transfer_ticket_web_request_model.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticketing_my_action_repository.dart';

class TransferTicketWebUseCase {
  final TicketingMyActionRepository _repository;

  TransferTicketWebUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required TransferTicketWebRequestModel payload,
  }) {
    return _repository.transferTicketWebRequested(payload: payload);
  }
}
