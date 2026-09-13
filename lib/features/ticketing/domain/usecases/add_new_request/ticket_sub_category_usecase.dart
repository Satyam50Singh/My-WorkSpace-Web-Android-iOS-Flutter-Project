import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/add_new_request/ticket_sub_category_entity.dart';
import '../../repositories/add_new_request_repository.dart';

class TicketSubCategoryUseCase {
  final AddNewRequestRepository repository;

  TicketSubCategoryUseCase(this.repository);

  Future<Either<Failure, TicketSubCategoryEntity>> call({
    required int categoryID,
  }) {
    return repository.fetchTicketSubCategory(categoryID: categoryID);
  }
}
