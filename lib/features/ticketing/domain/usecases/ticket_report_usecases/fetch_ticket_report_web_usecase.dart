import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../data/models/ticket_report_models/fetch_ticket_report_web_request_model.dart';
import '../../entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import '../../repositories/ticket_report_master_repository.dart';

class FetchTicketReportWebUseCase {
  final TicketReportMasterRepository _repository;

  FetchTicketReportWebUseCase(this._repository);

  Future<Either<Failure, FetchTicketReportWebEntity>> call({
    required FetchTicketReportWebRequestModel payload,
  }) async {
    return await _repository.fetchTicketReportWeb(payload: payload);
  }
}
