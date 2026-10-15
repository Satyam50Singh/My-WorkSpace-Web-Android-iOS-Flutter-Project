import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_sub_category_models/insert_update_sub_category_request_model.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/ticket_sub_category_master_repository.dart';

class InsertUpdateSubCategoryUseCase {
  final TicketSubCategoryMasterRepository _repository;

  InsertUpdateSubCategoryUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required InsertUpdateSubCategoryRequestModel payload,
  }) async {
    return await _repository.insertUpdateTicketSubCategory(payload: payload);
  }
}
