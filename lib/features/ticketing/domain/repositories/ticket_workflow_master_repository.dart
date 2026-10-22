import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';

abstract class TicketWorkflowMasterRepository {
  Future<Either<Failure, List<TicketWorkflowMasterEntity>>>
  fetchTicketWorkflowList({required int companyID});

  Future<Either<Failure, String>> insertUpdateTicketWorkflow({
    required InsertUpdateWorkflowRequestModel payload,
  });

  Future<Either<Failure, WorkflowUserGroupListEntity>>
  fetchWorkPermitConfigUserGroupChecklistList({required int companyID});
}
