import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_location_category_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';

import '../../../../core/error/failures.dart';

abstract class AddNewRequestRepository {
  Future<Either<Failure, TicketLocationCategoryEntity>>
  fetchTicketLocationCategory({required TicketLocationCategoryRequest payload});
}
