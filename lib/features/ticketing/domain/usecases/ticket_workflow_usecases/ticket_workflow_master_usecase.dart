import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_workflow_master_repository.dart';

import '../../../../../core/error/failures.dart';

class TicketWorkflowMasterUseCase {
  final TicketWorkflowMasterRepository _repository;

  TicketWorkflowMasterUseCase(this._repository);

  Future<Either<Failure, List<TicketWorkflowMasterEntity>>> call({
    required int companyID,
  }) async {
    return await _repository.fetchTicketWorkflowList(companyID: companyID);
  }
}
