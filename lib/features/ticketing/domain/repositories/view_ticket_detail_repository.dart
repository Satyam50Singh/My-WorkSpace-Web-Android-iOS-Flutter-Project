import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_history_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_v6.dart';

abstract class ViewTicketDetailRepository {
  Future<Either<Failure, List<ViewTicketDetailV6Entity>>> fetchTicketDetailsV6({
    required ViewTicketDetailRequest payload,
  });

  Future<Either<Failure, List<TicketWorkflowEntity>>> fetchTicketWorkflowDetails({
    required ViewTicketDetailRequest payload,
  });

  Future<Either<Failure, List<TicketHistoryEntity>>> fetchTicketActionHistory({
    required ViewTicketDetailRequest payload,
  });
}
