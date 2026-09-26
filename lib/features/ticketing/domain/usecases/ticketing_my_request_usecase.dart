import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/core/error/failures.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_my_request_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticketing_repository.dart';

import '../entities/ticket_detail_entity.dart';

class TicketingMyRequestUseCase {
  TicketingRepository ticketingRepository;

  TicketingMyRequestUseCase(this.ticketingRepository);

  Future<Either<Failure, TicketDetailEntity>> call({
    required TicketMyRequestRequest payload,
  }) {
    return ticketingRepository.getMyRequestDetails(request: payload);
  }
}
