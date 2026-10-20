import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticket_workflow_master_repository.dart';

class InsertUpdateWorkflowUseCase {
  final TicketWorkflowMasterRepository _repository;

  InsertUpdateWorkflowUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required InsertUpdateWorkflowRequestModel payload,
  }) async {
    return await _repository.insertUpdateTicketWorkflow(payload: payload);
  }
}
