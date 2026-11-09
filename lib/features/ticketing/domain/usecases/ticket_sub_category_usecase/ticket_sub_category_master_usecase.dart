import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_sub_category_master_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/ticket_category_entities/sub_category_master_entity.dart';

class TicketSubCategoryMasterUseCase {
  final TicketSubCategoryMasterRepository _repository;

  TicketSubCategoryMasterUseCase(this._repository);

  Future<Either<Failure, List<SubCategoryMasterEntity>>> call({
    required int companyId,
  }) async {
    return await _repository.fetchTicketSubCategoryMasterList(
      companyId: companyId,
    );
  }
}
