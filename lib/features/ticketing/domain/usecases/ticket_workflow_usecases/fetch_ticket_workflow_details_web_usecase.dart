import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_detail_entity.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticket_workflow_master_repository.dart';

class FetchTicketWorkflowDetailsWebUseCase {
  final TicketWorkflowMasterRepository _repository;

  FetchTicketWorkflowDetailsWebUseCase(this._repository);

  Future<Either<Failure, TicketWorkflowDetailEntity>> call({
    required int companyID,
    required int workflowID,
  }) async {
    return await _repository.fetchTicketWorkflowDetailsWeb(
      companyID: companyID,
      workflowID: workflowID,
    );
  }
}
