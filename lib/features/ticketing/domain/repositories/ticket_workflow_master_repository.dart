import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';

import '../../../../core/error/failures.dart';

abstract class TicketWorkflowMasterRepository {
  Future<Either<Failure, List<TicketWorkflowMasterEntity>>>
  fetchTicketWorkflowList({required int companyID});
}
