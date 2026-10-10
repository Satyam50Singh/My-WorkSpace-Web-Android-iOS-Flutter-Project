import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';

import '../../../../core/error/failures.dart';
import '../entities/ticket_category_entities/department_entity.dart';

abstract class TicketCategoryMasterRepository {
  Future<Either<Failure, List<TicketCategoryEntity>>> fetchTicketCategoryMasterList({
    required int companyID,
  });

  Future<Either<Failure, List<DepartmentEntity>>> fetchDepartmentMasterList({
    required int companyID,
  });
}
