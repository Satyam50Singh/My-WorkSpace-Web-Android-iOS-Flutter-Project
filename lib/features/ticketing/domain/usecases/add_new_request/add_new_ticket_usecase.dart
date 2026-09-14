import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/app_multipart_file.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/add_new_ticket_request_entity.dart';

import '../../../../../core/error/failures.dart';
import '../../../data/models/add_new_request/add_new_ticket_request_model.dart';
import '../../repositories/add_new_request_repository.dart';

class AddNewTicketUseCase {
  final AddNewRequestRepository repository;

  AddNewTicketUseCase(this.repository);

  Future<Either<Failure, AddNewTicketRequestEntity>> call({
    required AddNewTicketRequestModel payload,
    required List<AppMultipartFile> imageFiles,
  }) {
    return repository.addNewTicketSubmitted(
      payload: payload,
      imageFiles: imageFiles,
    );
  }
}
