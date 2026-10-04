import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticketing_my_action_entities/ticket_transfer_user_list_entity.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticketing_my_action_repository.dart';

class TicketTransferUserListUseCase {
  final TicketingMyActionRepository _repository;

  TicketTransferUserListUseCase(this._repository);

  Future<Either<Failure, List<TicketTransferUserListEntity>>> call({required int ticketID}) {
    return _repository.ticketTransferUserListRequested(ticketID: ticketID);
  }
}
