import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticket_workflow_master_repository.dart';

class WorkflowUserGroupListUseCase {
  final TicketWorkflowMasterRepository _repository;

  WorkflowUserGroupListUseCase(this._repository);

  Future<Either<Failure, WorkflowUserGroupListEntity>> call({
    required int companyID,
  }) async {
    return await _repository.fetchWorkPermitConfigUserGroupChecklistList(
      companyID: companyID,
    );
  }
}
