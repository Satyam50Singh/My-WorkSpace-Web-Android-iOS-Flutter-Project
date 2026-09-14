import 'package:dartz/dartz.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/app_multipart_file.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/ticket_location_category_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_sub_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/add_new_request/add_new_ticket_request_model.dart';
import '../entities/add_new_request/add_new_ticket_request_entity.dart';

abstract class AddNewRequestRepository {
  Future<Either<Failure, TicketLocationCategoryEntity>>
  fetchTicketLocationCategory({required TicketLocationCategoryRequest payload});

  Future<Either<Failure, TicketSubCategoryEntity>> fetchTicketSubCategory({
    required int categoryID,
  });

  Future<Either<Failure, TicketWorkflowDetailsEntity>> fetchTicketWorkFlowDetails({
    required int categoryID,
    required int subCategoryID,
  });

  Future<Either<Failure, AddNewTicketRequestEntity>> addNewTicketSubmitted({
    required AddNewTicketRequestModel payload,
    required List<AppMultipartFile> imageFiles,
  });
}
