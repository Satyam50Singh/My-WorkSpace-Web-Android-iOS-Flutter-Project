import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/transfer_to_other_workflow_request_body.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticketing_my_action_repository.dart';

class TransferToOtherWorkflowUseCase {
  final TicketingMyActionRepository _repository;

  TransferToOtherWorkflowUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required TransferToOtherWorkflowRequestBody payload,
  }) {
    return _repository.transferToOtherWorkflow(payload: payload);
  }
}