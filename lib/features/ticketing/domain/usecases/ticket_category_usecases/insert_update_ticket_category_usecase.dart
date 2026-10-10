import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_category_models/insert_update_ticket_category_request_model.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticket_category_master_repository.dart';

class InsertUpdateTicketCategoryUseCase {
  final TicketCategoryMasterRepository _repository;

  InsertUpdateTicketCategoryUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required InsertUpdateTicketCategoryRequestModel payload,
  }) async {
    return await _repository.insertUpdateTicketCategory(payload: payload);
  }
}
