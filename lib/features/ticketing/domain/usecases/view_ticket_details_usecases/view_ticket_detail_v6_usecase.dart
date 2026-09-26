import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/view_ticket_detail_repository.dart';

import '../../entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';

class ViewTicketDetailV6UseCase {
  final ViewTicketDetailRepository repository;

  ViewTicketDetailV6UseCase(this.repository);

  Future<Either<Failure, List<ViewTicketDetailV6Entity>>> call({
    required ViewTicketDetailRequest payload,
  }) {
    return repository.fetchTicketDetailsV6(payload: payload);
  }
}
