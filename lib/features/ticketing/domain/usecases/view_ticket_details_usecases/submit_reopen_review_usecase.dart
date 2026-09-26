import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/submit_reopen_review_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_entities/submit_reopen_review_entity.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/view_ticket_detail_repository.dart';

class SubmitReopenReviewUseCase {
  final ViewTicketDetailRepository repository;

  SubmitReopenReviewUseCase(this.repository);

  Future<Either<Failure, SubmitReopenReviewEntity>> call({
    required SubmitReopenReviewRequest payload,
  }) {
    return repository.submitReopenReviewTicket(payload: payload);
  }
}
