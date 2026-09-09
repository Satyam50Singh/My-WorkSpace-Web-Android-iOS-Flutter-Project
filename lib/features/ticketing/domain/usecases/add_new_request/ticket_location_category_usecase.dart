import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/add_new_request_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../data/models/add_new_request/ticket_location_category_request.dart';
import '../../entities/add_new_request/ticket_location_category_entity.dart';

class TicketLocationCategoryUseCase {
  final AddNewRequestRepository repository;

  TicketLocationCategoryUseCase(this.repository);

  Future<Either<Failure, TicketLocationCategoryEntity>> call({
    required TicketLocationCategoryRequest payload,
  }) {
    return repository.fetchTicketLocationCategory(payload: payload);
  }
}
