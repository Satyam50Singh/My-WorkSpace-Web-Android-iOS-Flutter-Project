import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_report_entities/fetch_cat_sub_cat_loc_dept_type_list_entity.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/ticket_report_models/fetch_ticket_report_web_request_model.dart';
import '../entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';

abstract class TicketReportMasterRepository {
  Future<Either<Failure, FetchCatSubCatLocDeptTypeListEntity>>
  fetchCatSubCatLocDeptTypeList({required int companyID});

  Future<Either<Failure, FetchTicketReportWebEntity>> fetchTicketReportWeb({
    required FetchTicketReportWebRequestModel payload,
  });
}
