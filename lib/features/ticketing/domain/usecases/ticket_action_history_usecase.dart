import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_history_entity.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/view_ticket_details/view_ticket_detail_request.dart';
import '../repositories/view_ticket_detail_repository.dart';

class TicketActionHistoryUseCase {
  final ViewTicketDetailRepository repository;

  TicketActionHistoryUseCase(this.repository);

  Future<Either<Failure, List<TicketHistoryEntity>>> call({
    required ViewTicketDetailRequest payload,
  }) {
    return repository.fetchTicketActionHistory(payload: payload);
  }
}
