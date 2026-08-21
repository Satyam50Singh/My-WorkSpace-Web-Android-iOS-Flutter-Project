import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/view_ticket_detail_repository.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/view_ticket_details/view_ticket_detail_request.dart';
import '../entities/ticket_workflow_entity.dart';

class TicketWorkflowUseCase {
  final ViewTicketDetailRepository repository;

  TicketWorkflowUseCase(this.repository);

  Future<Either<Failure, List<TicketWorkflowEntity>>> call({
    required ViewTicketDetailRequest payload,
  }) {
    return repository.fetchTicketWorkflowDetails(payload: payload);
  }
}
