import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';

import '../../../../core/error/failures.dart';

abstract class TicketSubCategoryMasterRepository {
  Future<Either<Failure, List<SubCategoryMasterEntity>>> fetchTicketSubCategoryMasterList({required int companyID});
}
