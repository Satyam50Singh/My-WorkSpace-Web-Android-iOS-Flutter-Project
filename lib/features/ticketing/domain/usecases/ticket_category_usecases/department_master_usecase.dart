import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/ticket_category_entities/department_entity.dart';
import '../../repositories/ticket_category_master_repository.dart';

class DepartmentMasterUseCase {
  final TicketCategoryMasterRepository _repository;

  DepartmentMasterUseCase(this._repository);

  Future<Either<Failure, List<DepartmentEntity>>> call({
    required int companyID,
  }) async {
    return await _repository.fetchDepartmentMasterList(
      companyID: companyID,
    );
  }
}