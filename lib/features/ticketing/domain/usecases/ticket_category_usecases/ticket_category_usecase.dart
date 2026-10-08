import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_category_master_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/ticket_category_entities/ticket_category_entity.dart';

class TicketCategoryUseCase {
  final TicketCategoryMasterRepository _repository;

  TicketCategoryUseCase(this._repository);

  Future<Either<Failure, List<TicketCategoryEntity>>> call({
    required int companyID,
  }) async {
    return await _repository.fetchTicketCategoryMasterList(
      companyID: companyID,
    );
  }
}
