import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';

class TicketWorkflowDetailsResponseModel {
  int? status;
  String? message;
  TicketWorkFlowModel? workFlowModel;

  TicketWorkflowDetailsResponseModel({
    this.status,
    this.message,
    this.workFlowModel,
  });

  factory TicketWorkflowDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TicketWorkflowDetailsResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      workFlowModel: TicketWorkFlowModel.fromJson(json),
    );
  }
}

class TicketWorkFlowModel extends TicketWorkflowDetailsEntity {
  TicketWorkFlowModel({super.workFlowDetailList});

  factory TicketWorkFlowModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkFlowModel(
      workFlowDetailList: json['TicketWorkflow'] != null
          ? (json['TicketWorkflow'] as List)
                .map(
                  (i) =>
                      TicketWorkflowModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  TicketWorkflowDetailsEntity toEntity() {
    return TicketWorkflowDetailsEntity(workFlowDetailList: workFlowDetailList);
  }
}

class TicketWorkflowModel extends AddNewTicketWorkFlowEntity {
  TicketWorkflowModel({
    super.level,
    super.userName,
    super.groupName,
    super.userID,
    super.groupID,
    super.userProfilePic,
    super.time,
    super.totalUsers,
    super.workflowUsers,
  });

  factory TicketWorkflowModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkflowModel(
      level: json['Level'] as int?,
      userName: json['UserName'] as String?,
      groupName: json['GroupName'] as String?,
      userID: json['UserID'] as String?,
      groupID: json['GroupID'] as int?,
      userProfilePic: json['User_ProfilePic'] as String?,
      time: json['Time'] as int?,
      totalUsers: json['Total_Users'] as int?,
      workflowUsers: json['Workflow_Users'] != null
          ? (json['Workflow_Users'] as List)
                .map(
                  (i) => WorkflowUserModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }
}

class WorkflowUserModel extends WorkflowUserEntity {
  WorkflowUserModel({super.userName, super.profileImage});

  factory WorkflowUserModel.fromJson(Map<String, dynamic> json) {
    return WorkflowUserModel(
      userName: json['UserName'] as String?,
      profileImage: json['Profile_Image'] as String?,
    );
  }
}
