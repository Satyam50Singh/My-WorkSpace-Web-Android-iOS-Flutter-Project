import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/ticket_workflow_list_response_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_detail_entity.dart';

class TicketWorkflowDetailResponseModel extends TicketWorkflowDetailEntity {
  const TicketWorkflowDetailResponseModel({
    super.status,
    super.message,
    TicketWorkflowModel? workflow,
    List<WorkflowDetailItemModel>? workflowDetails,
  }) : super(
         workflow: workflow,
         workflowDetails: workflowDetails,
       );

  factory TicketWorkflowDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkflowDetailResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      workflow: json['workflow'] != null
          ? TicketWorkflowModel.fromJson(json['workflow'] as Map<String, dynamic>)
          : null,
      workflowDetails: json['workflow_details'] != null
          ? (json['workflow_details'] as List)
                .map(
                  (i) => WorkflowDetailItemModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'workflow': workflow is TicketWorkflowModel
          ? (workflow as TicketWorkflowModel).toJson()
          : workflow != null
              ? TicketWorkflowModel(
                  workflow?.workflowID,
                  workflow?.workflowName,
                  workflow?.categoryID,
                  workflow?.category,
                  workflow?.subCategoryID,
                  workflow?.subCategory,
                  workflow?.noOfLevels,
                ).toJson()
              : null,
      'workflow_details': workflowDetails
          ?.map(
            (e) => (e is WorkflowDetailItemModel)
                ? e.toJson()
                : WorkflowDetailItemModel(
                    workflowDetailId: e.workflowDetailId,
                    level: e.level,
                    userIDs: e.userIDs,
                    groupID: e.groupID,
                    userGroupName: e.userGroupName,
                    escalateTime: e.escalateTime,
                    isEmail: e.isEmail,
                    isSMS: e.isSMS,
                    isAppNotification: e.isAppNotification,
                    isWebNotification: e.isWebNotification,
                  ).toJson(),
          )
          .toList(),
    };
  }

  TicketWorkflowDetailEntity toEntity() {
    return TicketWorkflowDetailEntity(
      status: status,
      message: message,
      workflow: workflow,
      workflowDetails: workflowDetails,
    );
  }
}

class WorkflowDetailItemModel extends WorkflowDetailItemEntity {
  const WorkflowDetailItemModel({
    super.workflowDetailId,
    super.level,
    super.userIDs,
    super.groupID,
    super.userGroupName,
    super.escalateTime,
    super.isEmail,
    super.isSMS,
    super.isAppNotification,
    super.isWebNotification,
  });

  factory WorkflowDetailItemModel.fromJson(Map<String, dynamic> json) {
    return WorkflowDetailItemModel(
      workflowDetailId: json['Workflow_Detail_Id'] as int?,
      level: json['Level'] as int?,
      userIDs: json['UserIDs'] as String?,
      groupID: json['GroupID'] as int?,
      userGroupName: json['User_Group_Name'] as String?,
      escalateTime: json['Escalate_Time'] as int?,
      isEmail: json['Is_Email'] as int?,
      isSMS: json['Is_SMS'] as int?,
      isAppNotification: json['Is_AppNotification'] as int?,
      isWebNotification: json['Is_WebNotification'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Workflow_Detail_Id': workflowDetailId,
      'Level': level,
      'UserIDs': userIDs,
      'GroupID': groupID,
      'User_Group_Name': userGroupName,
      'Escalate_Time': escalateTime,
      'Is_Email': isEmail,
      'Is_SMS': isSMS,
      'Is_AppNotification': isAppNotification,
      'Is_WebNotification': isWebNotification,
    };
  }

  WorkflowDetailItemEntity toEntity() {
    return WorkflowDetailItemEntity(
      workflowDetailId: workflowDetailId,
      level: level,
      userIDs: userIDs,
      groupID: groupID,
      userGroupName: userGroupName,
      escalateTime: escalateTime,
      isEmail: isEmail,
      isSMS: isSMS,
      isAppNotification: isAppNotification,
      isWebNotification: isWebNotification,
    );
  }
}
