import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/update_ticket_action_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticketing_my_action_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../data/models/add_new_request/app_multipart_file.dart';

class UpdateTicketActionUseCase {
  final TicketingMyActionRepository _repository;

  UpdateTicketActionUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required UpdateTicketActionRequestModel payload,
    List<AppMultipartFile>? images,
  }) {
    return _repository.updateTicketActionRequested(payload: payload, images: images);
  }
}
