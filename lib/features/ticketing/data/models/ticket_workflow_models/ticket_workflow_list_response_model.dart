import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';

class TicketWorkflowListResponseModel {
  int? status;
  String? message;
  List<TicketWorkflowModel>? workflowList;

  TicketWorkflowListResponseModel({
    this.status,
    this.message,
    this.workflowList,
  });

  factory TicketWorkflowListResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkflowListResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      workflowList: json['workflow_details'] != null
          ? (json['workflow_details'] as List)
                .map(
                  (i) =>
                      TicketWorkflowModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }
}

class TicketWorkflowModel extends TicketWorkflowMasterEntity {
  TicketWorkflowModel(
    super.workflowID,
    super.workflowName,
    super.categoryID,
    super.category,
    super.subCategoryID,
    super.subCategory,
    super.noOfLevels,
  );

  TicketWorkflowModel.fromJson(Map<String, dynamic> json)
    : super(
        json['WorkflowID'] as int?,
        json['Workflow_Name'] as String?,
        json['Category_ID'] as int?,
        json['Category'] as String?,
        json['SubCategory_ID'] as int?,
        json['SubCategory'] as String?,
        json['No_Of_Levels'] as int?,
      );

  TicketWorkflowMasterEntity toEntity() {
    return TicketWorkflowMasterEntity(
      workflowID,
      workflowName,
      categoryID,
      category,
      subCategoryID,
      subCategory,
      noOfLevels,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'WorkflowID': workflowID,
      'Workflow_Name': workflowName,
      'Category_ID': categoryID,
      'Category': category,
      'SubCategory_ID': subCategoryID,
      'SubCategory': subCategory,
      'No_Of_Levels': noOfLevels,
    };
  }
}
