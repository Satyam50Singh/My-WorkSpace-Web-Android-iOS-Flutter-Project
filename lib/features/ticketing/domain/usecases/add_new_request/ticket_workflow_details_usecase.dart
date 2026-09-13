import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/add_new_request/ticket_workflow_details_entity.dart';
import '../../repositories/add_new_request_repository.dart';

class TicketWorkFlowDetailsUseCase {
  final AddNewRequestRepository repository;

  TicketWorkFlowDetailsUseCase(this.repository);

  Future<Either<Failure, TicketWorkflowDetailsEntity>> call({
    required int categoryID,
    required int subCategoryID,
  }) {
    return repository.fetchTicketWorkFlowDetails(
      categoryID: categoryID,
      subCategoryID: subCategoryID,
    );
  }
}
