import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/domain/repositories/ticket_report_master_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/ticket_report_entities/fetch_cat_sub_cat_loc_dept_type_list_entity.dart';

class FetchCatSubCatLocDeptTypeListUseCase {
  final TicketReportMasterRepository _repository;

  FetchCatSubCatLocDeptTypeListUseCase(this._repository);

  Future<Either<Failure, FetchCatSubCatLocDeptTypeListEntity>> call({
    required int companyID,
  }) async {
    return await _repository.fetchCatSubCatLocDeptTypeList(
      companyID: companyID,
    );
  }
}
